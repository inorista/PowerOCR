import 'package:equatable/equatable.dart';
import 'package:powerocr/core/constants/enum.dart';
import 'package:powerocr/database/hive_entities/scan_history_entity/scan_history_entity.dart';
import 'package:powerocr/database/hive_entities/scan_text_block_history_entity/scan_text_block_history_entity.dart';
import 'package:powerocr/features/scanning/domain/entities/text_block.dart';

class TextRecognitionResult extends Equatable {
  final String text;
  final List<TextBlock> blocks;
  final int imageWidth;
  final int imageHeight;
  final String imagePath;
  final DateTime createdAt;
  final ScanHistoryType type;

  const TextRecognitionResult({
    required this.text,
    this.blocks = const [],
    this.imageWidth = 0,
    this.imageHeight = 0,
    required this.imagePath,
    required this.createdAt,
    this.type = ScanHistoryType.document,
  });

  @override
  List<Object?> get props => [text, blocks, imageWidth, imageHeight];

  static ScanHistoryEntity toScanHistoryEntity(TextRecognitionResult result) {
    return ScanHistoryEntity(
      imagePath: result.imagePath,
      imageHeight: result.imageHeight,
      imageWidth: result.imageWidth,
      text: result.text,
      createdAt: result.createdAt,
      type: result.type,
    );
  }

  static List<ScanTextBlockHistoryEntity> toScanTextBlockHistoryEntities(
    TextRecognitionResult result,
    String scanHistoryId,
  ) {
    return result.blocks.map((block) {
      return ScanTextBlockHistoryEntity(
        text: block.text,
        boundingBox: block.boundingBox,
        scanHistoryId: scanHistoryId,
      );
    }).toList();
  }
}
