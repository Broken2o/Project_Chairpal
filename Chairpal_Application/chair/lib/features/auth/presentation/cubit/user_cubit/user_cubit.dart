import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/network/api_result.dart';
import '../../../domain/usecases/auth_usecases.dart';
import '../../../../../core/network/reverb_service.dart';
import 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final GetLocalUserUseCase _getLocalUserUseCase;
  final GetProfileUseCase _getProfileUseCase;
  final LogoutUseCase _logoutUseCase;
  final DeleteAccountUseCase _deleteAccountUseCase;
  final ClearLocalTokensUseCase _clearLocalTokensUseCase;

  UserCubit({
    required GetLocalUserUseCase getLocalUserUseCase,
    required GetProfileUseCase getProfileUseCase,
    required LogoutUseCase logoutUseCase,
    required DeleteAccountUseCase deleteAccountUseCase,
    required ClearLocalTokensUseCase clearLocalTokensUseCase,
  }) : _getLocalUserUseCase = getLocalUserUseCase,
       _getProfileUseCase = getProfileUseCase,
       _logoutUseCase = logoutUseCase,
       _deleteAccountUseCase = deleteAccountUseCase,
       _clearLocalTokensUseCase = clearLocalTokensUseCase,
       super(UserInitial());

  Future<void> loadUser() async {
    emit(UserLoading());
    try {
      final user = await _getLocalUserUseCase();

      if (user != null) {
        emit(UserLoaded(user));
        if (user.accessToken != null) {
          ReverbService().connectToReverb(user.accessToken!, user.id);
        }
        // Fetch fresh profile in background
        final result = await _getProfileUseCase();
        if (result is ApiSuccess) {
          emit(UserLoaded((result as ApiSuccess).data));
        }
      } else {
        await fetchProfile();
      }
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> fetchProfile() async {
    if (state is! UserLoaded) {
      emit(UserLoading());
    }
    final result = await _getProfileUseCase();
    if (result is ApiSuccess) {
      final user = (result as ApiSuccess).data;
      emit(UserLoaded(user));
      if (user.accessToken != null) {
        ReverbService().connectToReverb(user.accessToken!, user.id);
      }
    } else if (result is ApiError) {
      emit(UserError((result as ApiError).failure.message));
    }
  }

  Future<void> logout() async {
    emit(UserLoading());
    // Best effort remote logout
    await _logoutUseCase();
    // Clear local auth tokens & user
    await _clearLocalTokensUseCase();
    await ReverbService().disconnect();
    emit(UserInitial());
  }

  Future<void> deleteAccount() async {
    emit(UserLoading());
    final result = await _deleteAccountUseCase();
    if (result is ApiSuccess) {
      await _clearLocalTokensUseCase();
      emit(UserInitial());
    } else if (result is ApiError) {
      emit(UserError((result).failure.message));
    }
  }
}
