import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:powerocr/core/di/locator.dart';
import 'package:powerocr/features/qr_library/domain/usecases/delete_user_qr.dart';
import 'package:powerocr/features/qr_library/domain/usecases/get_user_qrs.dart';
import 'package:powerocr/features/qr_library/presentation/bloc/qr_library_event.dart';
import 'package:powerocr/features/qr_library/presentation/bloc/qr_library_state.dart';

class QrLibraryBloc extends Bloc<QrLibraryEvent, QrLibraryState> {
  final GetUserQrs getUserQrs = locator<GetUserQrs>();
  final DeleteUserQr deleteUserQr = locator<DeleteUserQr>();

  QrLibraryBloc() : super(QrLibraryInitial()) {
    on<LoadUserQrsEvent>(_onLoadUserQrs, transformer: droppable());
    on<DeleteUserQrEvent>(_onDeleteUserQr);
  }

  Future<void> _onLoadUserQrs(
    LoadUserQrsEvent event,
    Emitter<QrLibraryState> emit,
  ) async {
    emit(QrLibraryLoading());
    try {
      final userQrs = await getUserQrs.call();
      emit(QrLibraryLoaded(userQrs: userQrs));
    } catch (e) {
      emit(QrLibraryError(message: e.toString()));
    }
  }

  Future<void> _onDeleteUserQr(
    DeleteUserQrEvent event,
    Emitter<QrLibraryState> emit,
  ) async {
    try {
      await deleteUserQr.call(event.id);
      add(LoadUserQrsEvent()); // Reload after deleting
    } catch (e) {
      emit(QrLibraryError(message: e.toString()));
    }
  }
}
