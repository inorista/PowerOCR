import 'package:json_annotation/json_annotation.dart';

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
