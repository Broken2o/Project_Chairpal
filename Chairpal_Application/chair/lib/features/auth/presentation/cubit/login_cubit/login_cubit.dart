import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/network/api_result.dart';
import '../../../domain/usecases/auth_usecases.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase _loginUseCase;

  LoginCubit({required LoginUseCase loginUseCase})
    : _loginUseCase = loginUseCase,
      super(const LoginState());

  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  Future<void> login(String email, String password, {bool remember = false}) async {
    emit(state.copyWith(status: LoginStatus.loading, email: email));

    final result = await _loginUseCase(
      email: email,
      password: password,
      remember: remember,
    );

    if (result is ApiSuccess) {
      final user = (result as ApiSuccess).data;
      emit(state.copyWith(status: LoginStatus.success, role: user.role));
    } else if (result is ApiError) {
      final failure = (result as ApiError).failure;
      emit(
        state.copyWith(
          status: LoginStatus.error,
          errorMessage: failure.message,
          email: email,
        ),
      );
    }
  }

  Future<void> socialLogin(String provider) async {
    emit(state.copyWith(status: LoginStatus.loading));

    // Simulate social auth
    await Future.delayed(const Duration(seconds: 1));

    emit(state.copyWith(status: LoginStatus.success));
  }

  void resetState() {
    emit(const LoginState());
  }
}
