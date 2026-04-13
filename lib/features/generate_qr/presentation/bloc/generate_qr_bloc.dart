import 'package:flutter_bloc/flutter_bloc.dart';
import 'generate_qr_event.dart';
import 'generate_qr_state.dart';

class GenerateQrBloc extends Bloc<GenerateQrEvent, GenerateQrState> {
  GenerateQrBloc() : super(GenerateQrState.initial()) {
    on<QrDataChanged>((event, emit) {
      emit(state.copyWith(qrData: event.data));
    });

    on<QrColorChanged>((event, emit) {
      emit(state.copyWith(selectedColor: event.color));
    });

    on<QrEyeShapeChanged>((event, emit) {
      emit(state.copyWith(eyeShape: event.shape));
    });

    on<QrDataShapeChanged>((event, emit) {
      emit(state.copyWith(dataShape: event.shape));
    });

    on<QrBackgroundChanged>((event, emit) {
      emit(state.copyWith(isDarkBackground: event.isDark));
    });

    on<QrShareStatusChanged>((event, emit) {
      emit(state.copyWith(isSharing: event.isSharing));
    });
  }
}
