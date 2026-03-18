import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:powerocr/core/di/locator.dart';
import 'package:powerocr/core/services/interfaces/iscan_history_service.dart'
    show IScanHistoryService;
import 'package:powerocr/features/scanning/domain/repositories/scanning_repository.dart';
import 'package:powerocr/features/scanning/domain/usecases/recognize_text.dart';
import 'package:powerocr/features/scanning/presentation/bloc/scanning_event.dart';
import 'package:powerocr/features/scanning/presentation/bloc/scanning_state.dart';

@injectable
class ScanningBloc extends Bloc<ScanningEvent, ScanningState> {
  final RecognizeText recognizeText = locator<RecognizeText>();
  final scanHistoryService = locator<IScanHistoryService>();

  ScanningBloc() : super(const ScanningState()) {
    on<ScanImage>(_onScanImage);
    on<ResetScan>(_onResetScan);
    on<ToggleFlash>(_onToggleFlash);
    on<CameraReady>(_onCameraReady);
    on<CameraNotReady>(_onCameraNotReady);
  }

  Future<void> _onScanImage(
      ScanImage event, Emitter<ScanningState> emit) async {
    emit(state.copyWith(status: ScanningStatus.loading));
    try {
      final result = await recognizeText(event.imagePath);
      await locator<ScanningRepository>().saveScanHistory(result);
      emit(state.copyWith(
        status: ScanningStatus.success,
        result: result,
        imagePath: event.imagePath,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ScanningStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onResetScan(ResetScan event, Emitter<ScanningState> emit) {
    emit(ScanningState(
      flashMode: state.flashMode,
      isCameraInitialized: state.isCameraInitialized,
    ));
  }

  void _onToggleFlash(ToggleFlash event, Emitter<ScanningState> emit) {
    final next = switch (state.flashMode) {
      FlashMode.auto => FlashMode.always,
      FlashMode.always => FlashMode.off,
      _ => FlashMode.auto,
    };
    emit(state.copyWith(flashMode: next));
  }

  void _onCameraReady(CameraReady event, Emitter<ScanningState> emit) {
    emit(state.copyWith(isCameraInitialized: true));
  }

  void _onCameraNotReady(CameraNotReady event, Emitter<ScanningState> emit) {
    emit(state.copyWith(isCameraInitialized: false));
  }
}
