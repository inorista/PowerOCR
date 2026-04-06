part of 'scan_history_screen_bloc.dart';

enum ScanHistoryScreenBlocStatus { initial, loading, loaded, error }

class ScanHistoryScreenBlocState extends Equatable {
  final ScanHistoryScreenBlocStatus status;
  final List<ScanHistory> scanHistory;
  final String? errorMessage;

  const ScanHistoryScreenBlocState({
    this.status = ScanHistoryScreenBlocStatus.initial,
    this.scanHistory = const [],
    this.errorMessage,
  });

  ScanHistoryScreenBlocState copyWith({
    ScanHistoryScreenBlocStatus? status,
    List<ScanHistory>? scanHistory,
    String? errorMessage,
  }) {
    return ScanHistoryScreenBlocState(
      status: status ?? this.status,
      scanHistory: scanHistory ?? this.scanHistory,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, scanHistory, errorMessage];
}
