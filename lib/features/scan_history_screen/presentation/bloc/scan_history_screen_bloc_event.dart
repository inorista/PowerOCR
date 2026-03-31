part of 'scan_history_screen_bloc_bloc.dart';

sealed class ScanHistoryScreenBlocEvent extends Equatable {
  const ScanHistoryScreenBlocEvent();

  @override
  List<Object> get props => [];
}

class LoadScanHistory extends ScanHistoryScreenBlocEvent {}
