import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ExampleEvent {}

abstract class ExampleState {}

class ExampleInitial extends ExampleState {}

class ExampleBloc extends Bloc<ExampleEvent, ExampleState> {
  ExampleBloc() : super(ExampleInitial()) {
    // on<ExampleEvent>((event, emit) {});
  }
}
