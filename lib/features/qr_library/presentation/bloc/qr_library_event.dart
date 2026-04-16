abstract class QrLibraryEvent {}

class LoadUserQrsEvent extends QrLibraryEvent {}

class DeleteUserQrEvent extends QrLibraryEvent {
  final String id;
  DeleteUserQrEvent(this.id);
}
