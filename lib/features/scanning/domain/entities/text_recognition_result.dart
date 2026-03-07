import 'package:equatable/equatable.dart';
import 'package:powerocr/database/hive_entities/scan_history_entity/scan_history_entity.dart';
import 'package:powerocr/database/hive_entities/scan_text_block_history_entity/scan_text_block_history_entity.dart';

class TextRecognitionResult extends Equatable {
  final String text;
  final List<TextBlock> blocks;
  final int imageWidth;
  final int imageHeight;
  final String imagePath;
  final DateTime createdAt;

  const TextRecognitionResult({
    required this.text,
    this.blocks = const [],
    this.imageWidth = 0,
    this.imageHeight = 0,
    required this.imagePath,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [text, blocks, imageWidth, imageHeight];

  static ScanHistoryEntity toScanHistoryEntity(TextRecognitionResult result) {
    return ScanHistoryEntity(
      imagePath: result.imagePath,
      text: result.text,
      createdAt: result.createdAt,
    );
  }

  static List<ScanTextBlockHistoryEntity> toScanTextBlockHistoryEntities(
      TextRecognitionResult result, String scanHistoryId) {
    return result.blocks.map((block) {
      return ScanTextBlockHistoryEntity(
        text: block.text,
        boundingBox: block.boundingBox,
        scanHistoryId: scanHistoryId,
      );
    }).toList();
  }
}

class TextBlock extends Equatable {
  final String text;
  final List<double> boundingBox;

  const TextBlock({
    required this.text,
    this.boundingBox = const [],
  });

  @override
  List<Object?> get props => [text, boundingBox];
}
