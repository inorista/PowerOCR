import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:powerocr/features/home/domain/usecases/get_scan_history.dart';
import 'package:powerocr/features/home/presentation/bloc/home_event.dart';
import 'package:powerocr/features/home/presentation/bloc/home_state.dart';

@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetScanHistory getScanHistory;

  HomeBloc({
    required this.getScanHistory,
  }) : super(const HomeState()) {
    on<LoadHomeData>(_onLoadHomeData);
  }

  Future<void> _onLoadHomeData(
      LoadHomeData event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: HomeStatus.loading));
    try {
      final history = await getScanHistory();
      emit(state.copyWith(status: HomeStatus.success, history: history));
    } catch (e) {
      emit(state.copyWith(
          status: HomeStatus.failure, errorMessage: e.toString()));
    }
  }
}
