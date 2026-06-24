import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/network/api_result.dart';
import '../../../domain/usecases/auth_usecases.dart';
import 'verification_state.dart';

class VerificationCubit extends Cubit<VerificationState> {
  final VerifyEmailUseCase _verifyEmailUseCase;
  final ResendVerificationCodeUseCase _resendCodeUseCase;
  final String email;

  VerificationCubit({
    required VerifyEmailUseCase verifyEmailUseCase,
    required ResendVerificationCodeUseCase resendCodeUseCase,
    required this.email,
  }) : _verifyEmailUseCase = verifyEmailUseCase,
       _resendCodeUseCase = resendCodeUseCase,
       super(const VerificationInitial());

  void updateCode(String code) {
    emit(VerificationInitial(code: code));
  }

  void addDigit(String digit) {
    final currentState = state;
    if (currentState is VerificationInitial) {
      final currentCode = currentState.code;
      if (currentCode.length < 6) {
        final newCode = currentCode + digit;
        emit(VerificationInitial(code: newCode));

        // Auto-verify when 6 digits are entered
        if (newCode.length == 6) {
          verify(newCode);
        }
      }
    }
  }

  void removeDigit() {
    final currentState = state;
    if (currentState is VerificationInitial) {
      final currentCode = currentState.code;
      if (currentCode.isNotEmpty) {
        final newCode = currentCode.substring(0, currentCode.length - 1);
        emit(VerificationInitial(code: newCode));
      }
    }
  }

  Future<void> verify(String code) async {
    if (code.length != 6) {
      emit(const VerificationError('Please enter a 6-digit code'));
      emit(VerificationInitial(code: code));
      return;
    }

    emit(VerificationLoading());

    final result = await _verifyEmailUseCase(email: email, code: code);

    if (result is ApiSuccess) {
      emit(VerificationSuccess());
    } else if (result is ApiError) {
      final failure = (result).failure;
      emit(VerificationError(failure.message));
      emit(VerificationInitial(code: code));
    }
  }

  Future<void> resendCode() async {
    emit(VerificationLoading());

    final result = await _resendCodeUseCase(email: email);

    if (result is ApiSuccess) {
      emit(VerificationCodeResent());
      emit(const VerificationInitial());
    } else if (result is ApiError) {
      final failure = (result).failure;
      emit(VerificationError(failure.message));
      emit(const VerificationInitial());
    }
  }

  void resetState() {
    emit(const VerificationInitial());
  }
}
