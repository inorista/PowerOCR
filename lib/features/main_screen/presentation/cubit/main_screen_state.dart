part of 'main_screen_cubit.dart';

abstract class MainScreenState extends Equatable {
  final int screenIndex;
  const MainScreenState({required this.screenIndex});

  @override
  List<Object> get props => [screenIndex];
}

final class MainScreenInitial extends MainScreenState {
  const MainScreenInitial({required super.screenIndex});

  @override
  List<Object> get props => [screenIndex];
}
