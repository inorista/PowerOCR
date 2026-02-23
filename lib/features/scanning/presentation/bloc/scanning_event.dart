import 'package:equatable/equatable.dart';

abstract class ScanningEvent extends Equatable {
  const ScanningEvent();

  @override
  List<Object> get props => [];
}

class ScanImage extends ScanningEvent {
  final String imagePath;

  const ScanImage(this.imagePath);

  @override
  List<Object> get props => [imagePath];
}

class ResetScan extends ScanningEvent {}

class ToggleFlash extends ScanningEvent {}

class CameraReady extends ScanningEvent {}

class CameraNotReady extends ScanningEvent {}
