import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:powerocr/features/scanning/domain/entities/text_recognition_result.dart';

enum ScanningStatus { initial, loading, success, failure, batchAdded, batchFinished }

class ScanningState extends Equatable {
  final ScanningStatus status;
  final TextRecognitionResult? result;
  final String? imagePath;
  final String? errorMessage;
  final FlashMode flashMode;

  final bool isCameraInitialized;
  final List<String> batchImagePaths;

  const ScanningState({
    this.status = ScanningStatus.initial,
    this.result,
    this.imagePath,
    this.errorMessage,
    this.flashMode = FlashMode.auto,
    this.isCameraInitialized = false,
    this.batchImagePaths = const [],
  });

  ScanningState copyWith({
    ScanningStatus? status,
    TextRecognitionResult? result,
    String? imagePath,
    String? errorMessage,
    FlashMode? flashMode,
    bool? isCameraInitialized,
    List<String>? batchImagePaths,
  }) {
    return ScanningState(
      status: status ?? this.status,
      result: result ?? this.result,
      imagePath: imagePath ?? this.imagePath,
      errorMessage: errorMessage ?? this.errorMessage,
      flashMode: flashMode ?? this.flashMode,
      isCameraInitialized: isCameraInitialized ?? this.isCameraInitialized,
      batchImagePaths: batchImagePaths ?? this.batchImagePaths,
    );
  }

  @override
  List<Object?> get props =>
      [status, result, imagePath, errorMessage, flashMode, isCameraInitialized, batchImagePaths];
}
