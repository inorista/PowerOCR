import 'package:equatable/equatable.dart';
import 'package:powerocr/core/constants/enum.dart';

abstract class ScanningEvent extends Equatable {
  const ScanningEvent();

  @override
  List<Object> get props => [];
}

class ScanImage extends ScanningEvent {
  final String imagePath;
  final FeatureOption featureOption;

  const ScanImage(this.imagePath, this.featureOption);

  @override
  List<Object> get props => [imagePath, featureOption];
}

class ResetScan extends ScanningEvent {}

class ToggleFlash extends ScanningEvent {}

class CameraReady extends ScanningEvent {}

class CameraNotReady extends ScanningEvent {}

class FinishBatchScan extends ScanningEvent {}
