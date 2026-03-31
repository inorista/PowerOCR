import 'package:powerocr/core/constants/enum.dart';

class ScanHistory {
  final String id;
  final String imagePath;
  final String text;
  final DateTime createdAt;
  final ScanHistoryType? type;
  final int? imageWidth;
  final int? imageHeight;

  ScanHistory({
    required this.id,
    required this.imagePath,
    required this.text,
    required this.createdAt,
    this.type = ScanHistoryType.document,
    this.imageWidth,
    this.imageHeight,
  });
}
