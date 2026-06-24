import 'package:equatable/equatable.dart';

enum LoginStatus { initial, loading, success, error }

class LoginState extends Equatable {
  final LoginStatus status;
  final bool isPasswordVisible;
  final String? errorMessage;
  final String? email;
  final String? role;

  const LoginState({
    this.status = LoginStatus.initial,
    this.isPasswordVisible = true,
    this.errorMessage,
    this.email,
    this.role,
  });

  LoginState copyWith({
    LoginStatus? status,
    bool? isPasswordVisible,
    String? errorMessage,
    String? email,
    String? role,
  }) {
    return LoginState(
      status: status ?? this.status,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      errorMessage: errorMessage,
      email: email ?? this.email,
      role: role ?? this.role,
    );
  }

  @override
  List<Object?> get props => [
    status,
    isPasswordVisible,
    errorMessage,
    email,
    role,
  ];
}
