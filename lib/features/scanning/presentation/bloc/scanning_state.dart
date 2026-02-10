import 'package:equatable/equatable.dart';
import 'package:powerocr/features/scanning/domain/entities/text_recognition_result.dart';

enum ScanningStatus { initial, loading, success, failure }

class ScanningState extends Equatable {
  final ScanningStatus status;
  final TextRecognitionResult? result;
  final String? imagePath;
  final String? errorMessage;

  const ScanningState({
    this.status = ScanningStatus.initial,
    this.result,
    this.imagePath,
    this.errorMessage,
  });

  ScanningState copyWith({
    ScanningStatus? status,
    TextRecognitionResult? result,
    String? imagePath,
    String? errorMessage,
  }) {
    return ScanningState(
      status: status ?? this.status,
      result: result ?? this.result,
      imagePath: imagePath ?? this.imagePath,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, result, imagePath, errorMessage];
}
