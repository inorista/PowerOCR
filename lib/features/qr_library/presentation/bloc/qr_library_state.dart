import 'package:powerocr/features/qr_library/domain/entities/user_qr.dart';

abstract class QrLibraryState {}

class QrLibraryInitial extends QrLibraryState {}

class QrLibraryLoading extends QrLibraryState {}

class QrLibraryLoaded extends QrLibraryState {
  final List<UserQr> userQrs;
  QrLibraryLoaded({required this.userQrs});
}

class QrLibraryError extends QrLibraryState {
  final String message;
  QrLibraryError({required this.message});
}
