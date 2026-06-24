import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/network/api_result.dart';
import '../../../domain/usecases/auth_usecases.dart';
import 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final ForgotPasswordUseCase _forgotPasswordUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;

  ForgotPasswordCubit({
    required ForgotPasswordUseCase forgotPasswordUseCase,
    required VerifyOtpUseCase verifyOtpUseCase,
    required ResetPasswordUseCase resetPasswordUseCase,
  }) : _forgotPasswordUseCase = forgotPasswordUseCase,
       _verifyOtpUseCase = verifyOtpUseCase,
       _resetPasswordUseCase = resetPasswordUseCase,
       super(const ForgotPasswordState());

  Future<void> sendOtp(String email) async {
    emit(state.copyWith(status: ForgotPasswordStatus.loading));

    final result = await _forgotPasswordUseCase(email: email);

    if (result is ApiSuccess) {
      emit(state.copyWith(status: ForgotPasswordStatus.otpSent, email: email));
    } else if (result is ApiError) {
      final failure = (result).failure;
      emit(
        state.copyWith(
          status: ForgotPasswordStatus.error,
          errorMessage: failure.message,
        ),
      );
    }
  }

  Future<void> verifyOtp(String email, String otp) async {
    emit(state.copyWith(status: ForgotPasswordStatus.loading));

    final result = await _verifyOtpUseCase(email: email, otp: otp);

    if (result is ApiSuccess) {
      emit(
        state.copyWith(status: ForgotPasswordStatus.otpVerified, email: email),
      );
    } else if (result is ApiError) {
      final failure = (result).failure;
      emit(
        state.copyWith(
          status: ForgotPasswordStatus.error,
          errorMessage: failure.message,
        ),
      );
    }
  }

  Future<void> resetPassword(
    String email,
    String otp,
    String newPassword,
    String newPasswordConfirmation,
  ) async {
    emit(state.copyWith(status: ForgotPasswordStatus.loading));

    final result = await _resetPasswordUseCase(
      email: email,
      otp: otp,
      newPassword: newPassword,
      newPasswordConfirmation: newPasswordConfirmation,
    );

    if (result is ApiSuccess) {
      emit(state.copyWith(status: ForgotPasswordStatus.passwordReset));
    } else if (result is ApiError) {
      final failure = (result).failure;
      emit(
        state.copyWith(
          status: ForgotPasswordStatus.error,
          errorMessage: failure.message,
        ),
      );
    }
  }

  void resetState() {
    emit(const ForgotPasswordState());
  }
}
