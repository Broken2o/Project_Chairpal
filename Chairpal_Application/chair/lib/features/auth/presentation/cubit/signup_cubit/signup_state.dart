import 'package:equatable/equatable.dart';

enum SignupStatus { initial, loading, success, error }

class SignupState extends Equatable {
  final SignupStatus status;
  final String? errorMessage;
  final bool isPasswordVisible;
  final String? email;
  final String? successMessage;

  const SignupState({
    this.status = SignupStatus.initial,
    this.errorMessage,
    this.isPasswordVisible = true,
    this.email,
    this.successMessage,
  });

  SignupState copyWith({
    SignupStatus? status,
    String? errorMessage,
    bool? isPasswordVisible,
    String? email,
    String? successMessage,
  }) {
    return SignupState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      email: email ?? this.email,
      successMessage: successMessage ?? this.successMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, isPasswordVisible, email, successMessage];
}
