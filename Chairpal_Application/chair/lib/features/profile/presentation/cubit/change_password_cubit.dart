import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../features/auth/domain/repositories/auth_repository.dart';
import 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final AuthRepository _authRepository;

  ChangePasswordCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(ChangePasswordInitial());

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    if (newPassword != confirmPassword) {
      emit(const ChangePasswordFailure('Passwords do not match'));
      return;
    }

    emit(ChangePasswordLoading());
    try {
      await _authRepository.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        newPasswordConfirmation: confirmPassword,
      );
      emit(ChangePasswordSuccess());
    } catch (e) {
      // Remove Exception prefix if exists
      String errorMessage = e.toString();
      if (errorMessage.startsWith('Exception: ')) {
        errorMessage = errorMessage.substring('Exception: '.length);
      }
      emit(ChangePasswordFailure(errorMessage));
    }
  }
}
