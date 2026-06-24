abstract class SupportState {}

class SupportInitial extends SupportState {}

class SupportLoading extends SupportState {}

class SupportSuccess extends SupportState {}

class SupportError extends SupportState {
  final String message;
  SupportError(this.message);
}
