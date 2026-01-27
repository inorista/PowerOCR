import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:powerocr/features/scanning/domain/usecases/recognize_text.dart';
import 'package:powerocr/features/scanning/presentation/bloc/scanning_event.dart';
import 'package:powerocr/features/scanning/presentation/bloc/scanning_state.dart';

@injectable
class ScanningBloc extends Bloc<ScanningEvent, ScanningState> {
  final RecognizeText recognizeText;

  ScanningBloc(this.recognizeText) : super(ScanningInitial()) {
    on<ScanImage>(_onScanImage);
    on<ResetScan>(_onResetScan);
  }

  Future<void> _onScanImage(ScanImage event, Emitter<ScanningState> emit) async {
    emit(ScanningLoading());
    try {
      final result = await recognizeText(event.imagePath);
      emit(ScanningSuccess(result, event.imagePath));
    } catch (e) {
      emit(ScanningFailure(e.toString()));
    }
  }

  void _onResetScan(ResetScan event, Emitter<ScanningState> emit) {
    emit(ScanningInitial());
  }
}
