import 'package:json_annotation/json_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:powerocr/database/hive_database.dart';

part 'enum.g.dart';

enum VisionFeatureType {
  @JsonValue('TYPE_UNSPECIFIED')
  typeUnspecified,
  @JsonValue('FACE_DETECTION')
  faceDetection,
  @JsonValue('LANDMARK_DETECTION')
  landmarkDetection,
  @JsonValue('LOGO_DETECTION')
  logoDetection,
  @JsonValue('LABEL_DETECTION')
  labelDetection,
  @JsonValue('TEXT_DETECTION')
  textDetection,
  @JsonValue('DOCUMENT_TEXT_DETECTION')
  documentTextDetection,
  @JsonValue('SAFE_SEARCH_DETECTION')
  safeSearchDetection,
  @JsonValue('IMAGE_PROPERTIES')
  imageProperties,
  @JsonValue('CROP_HINTS')
  cropHints,
  @JsonValue('WEB_DETECTION')
  webDetection,
}

@HiveType(typeId: HiveBoxNums.themeMode)
enum ThemeModeOption {
  @HiveField(0)
  system,
  @HiveField(1)
  light,
  @HiveField(2)
  dark,
}
