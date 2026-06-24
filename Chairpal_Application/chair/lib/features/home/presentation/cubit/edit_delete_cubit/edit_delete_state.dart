abstract class EditDeleteState {}
class EditDeleteInitial extends EditDeleteState {}
class EditDeleteLoading extends EditDeleteState {}
class EditDeleteSuccess extends EditDeleteState {}
class EditDeleteError extends EditDeleteState {
  final String message;
  EditDeleteError(this.message);
}
