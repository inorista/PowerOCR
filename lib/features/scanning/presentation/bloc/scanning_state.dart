import 'package:equatable/equatable.dart';
import 'package:powerocr/features/scanning/domain/entities/text_recognition_result.dart';

abstract class ScanningState extends Equatable {
  const ScanningState();
  
  @override
  List<Object> get props => [];
}

class ScanningInitial extends ScanningState {}

class ScanningLoading extends ScanningState {}

class ScanningSuccess extends ScanningState {
  final TextRecognitionResult result;
  final String imagePath;

  const ScanningSuccess(this.result, this.imagePath);

  @override
  List<Object> get props => [result, imagePath];
}

class ScanningFailure extends ScanningState {
  final String message;

  const ScanningFailure(this.message);

  @override
  List<Object> get props => [message];
}
