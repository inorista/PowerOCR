import 'package:equatable/equatable.dart';
import 'package:powerocr/features/home/domain/entities/scan_history.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  final HomeStatus status;
  final List<ScanHistory> history;
  final String? errorMessage;

  const HomeState({
    this.status = HomeStatus.initial,
    this.history = const [],
    this.errorMessage,
  });

  HomeState copyWith({
    HomeStatus? status,
    List<ScanHistory>? history,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      history: history ?? this.history,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, history, errorMessage];
}
