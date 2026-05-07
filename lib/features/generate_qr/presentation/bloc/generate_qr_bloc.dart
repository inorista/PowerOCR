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

    on<QrEyeStyleChanged>((event, emit) {
      emit(state.copyWith(eyeStyle: event.style));
    });

    on<QrModuleStyleChanged>((event, emit) {
      emit(state.copyWith(moduleStyle: event.style));
    });

    on<QrBackgroundChanged>((event, emit) {
      emit(state.copyWith(isDarkBackground: event.isDark));
    });

    on<QrShareStatusChanged>((event, emit) {
      emit(state.copyWith(isSharing: event.isSharing));
    });
  }
}
