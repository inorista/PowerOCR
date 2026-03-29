import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class LoadHomeData extends HomeEvent {}

class DeleteHomeScan extends HomeEvent {
  final String id;
  const DeleteHomeScan(this.id);

  @override
  List<Object?> get props => [id];
}

class ClearHomeHistory extends HomeEvent {}
