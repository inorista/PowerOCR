import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:powerocr/core/di/locator.dart';
import 'package:powerocr/core/domain/entities/scan_history.dart';
import 'package:powerocr/features/scan_history_screen/domain/repositories/scan_history_screen_repository.dart';

part 'scan_history_screen_bloc_event.dart';
part 'scan_history_screen_bloc_state.dart';

class ScanHistoryScreenBloc
    extends Bloc<ScanHistoryScreenBlocEvent, ScanHistoryScreenBlocState> {
  final ScanHistoryScreenRepository _scanHistoryScreenRepository =
      locator<ScanHistoryScreenRepository>();
  ScanHistoryScreenBloc() : super(const ScanHistoryScreenBlocState()) {
    on<LoadScanHistory>(_onLoadScanHistory);
  }

  Future<void> _onLoadScanHistory(
    LoadScanHistory event,
    Emitter<ScanHistoryScreenBlocState> emit,
  ) async {
    emit(state.copyWith(status: ScanHistoryScreenBlocStatus.loading));
    try {
      final scanHistory = await _scanHistoryScreenRepository.getScanHistory();
      emit(
        state.copyWith(
          status: ScanHistoryScreenBlocStatus.loaded,
          scanHistory: scanHistory,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ScanHistoryScreenBlocStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
