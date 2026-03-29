import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:powerocr/features/home_screen/domain/usecases/get_scan_history.dart';
import 'package:powerocr/features/home_screen/presentation/bloc/home_event.dart';
import 'package:powerocr/features/home_screen/presentation/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetScanHistory getScanHistory;

  HomeBloc({required this.getScanHistory}) : super(const HomeState()) {
    on<LoadHomeData>(_onLoadHomeData);
  }

  Future<void> _onLoadHomeData(
    LoadHomeData event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: HomeStatus.loading));
    try {
      final history = await getScanHistory.call();
      emit(state.copyWith(status: HomeStatus.success, history: history));
    } catch (e) {
      emit(
        state.copyWith(status: HomeStatus.failure, errorMessage: e.toString()),
      );
    }
  }
}
