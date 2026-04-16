import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'main_screen_state.dart';

class MainScreenCubit extends Cubit<MainScreenState> {
  MainScreenCubit() : super(const MainScreenInitial(screenIndex: 0));

  void changeScreen(int index) {
    emit(MainScreenInitial(screenIndex: index));
  }
}
