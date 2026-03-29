import 'package:powerocr/features/scanning/domain/entities/text_block.dart';
import 'package:powerocr/features/scanning/domain/entities/text_recognition_result.dart';

class TextAlignmentUtils {
  static String alignText(TextRecognitionResult result) {
    if (result.blocks.isEmpty) {
      return result.text;
    }

    var sortedBlocks = List<TextBlock>.from(result.blocks);
    sortedBlocks.sort((a, b) {
      double aCenterY = (a.boundingBox[1] + a.boundingBox[3]) / 2;
      double bCenterY = (b.boundingBox[1] + b.boundingBox[3]) / 2;
      return aCenterY.compareTo(bCenterY);
    });

    List<List<TextBlock>> lines = [];
    List<TextBlock> currentLine = [sortedBlocks.first];

    for (int i = 1; i < sortedBlocks.length; i++) {
      final curr = sortedBlocks[i];
      double currentLineAvgY =
          currentLine
              .map((b) => (b.boundingBox[1] + b.boundingBox[3]) / 2)
              .reduce((a, b) => a + b) /
          currentLine.length;
      double currCenterY = (curr.boundingBox[1] + curr.boundingBox[3]) / 2;
      double currHeight = (curr.boundingBox[3] - curr.boundingBox[1]).abs();

      if ((currCenterY - currentLineAvgY).abs() < currHeight * 0.6) {
        currentLine.add(curr);
      } else {
        lines.add(currentLine);
        currentLine = [curr];
      }
    }
    if (currentLine.isNotEmpty) {
      lines.add(currentLine);
    }

    double totalCharWidth = 0;
    int totalChars = 0;
    double minGlobalX = double.infinity;
    for (var block in sortedBlocks) {
      if (block.boundingBox[0] < minGlobalX) {
        minGlobalX = block.boundingBox[0];
      }
      double w = (block.boundingBox[2] - block.boundingBox[0]).abs();
      totalCharWidth += w;
      totalChars += block.text.length;
    }
    double avgCharWidth = totalChars > 0
        ? (totalCharWidth / totalChars) * 1.05
        : 9.0;
    if (avgCharWidth <= 0) avgCharWidth = 9.0;

    StringBuffer sb = StringBuffer();

    for (var line in lines) {
      line.sort((a, b) => a.boundingBox[0].compareTo(b.boundingBox[0]));

      int currentColumn = 0;
      for (int i = 0; i < line.length; i++) {
        var block = line[i];
        double startX = block.boundingBox[0];

        int targetColumn = ((startX - minGlobalX) / avgCharWidth).round();
        int spacesToAdd = targetColumn - currentColumn;

        if (spacesToAdd > 0) {
          sb.write(' ' * spacesToAdd);
          currentColumn += spacesToAdd;
        } else if (i > 0) {
          sb.write(' ');
          currentColumn += 1;
        }
        sb.write(block.text);
        currentColumn += block.text.length;
      }
      sb.writeln();
    }

    return sb.toString();
  }
}
