import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:powerocr/core/di/locator.dart';
import 'package:powerocr/features/scanning/domain/usecases/recognize_text.dart';
import 'package:powerocr/features/scanning/presentation/bloc/scanning_event.dart';
import 'package:powerocr/features/scanning/presentation/bloc/scanning_state.dart';

@injectable
class ScanningBloc extends Bloc<ScanningEvent, ScanningState> {
  final RecognizeText recognizeText = locator<RecognizeText>();

  ScanningBloc() : super(const ScanningState()) {
    on<ScanImage>(_onScanImage);
    on<ResetScan>(_onResetScan);
  }

  Future<void> _onScanImage(
      ScanImage event, Emitter<ScanningState> emit) async {
    emit(state.copyWith(status: ScanningStatus.loading));
    try {
      final result = await recognizeText(event.imagePath);
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
    emit(const ScanningState());
  }
}
