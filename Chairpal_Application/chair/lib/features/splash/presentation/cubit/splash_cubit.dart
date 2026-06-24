import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../auth/data/datasources/auth_local_data_source.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  Future<void> startSplash() async {
    // Wait for 4 seconds before navigating
    await Future.delayed(const Duration(seconds: 4));

    final prefs = await SharedPreferences.getInstance();
    final String? savedLocaleCode = prefs.getString('app_locale');
    
    // Check if remember token exists for auto-login
    final localDataSource = AuthLocalDataSourceImpl(sharedPreferences: prefs);
    final String? rememberToken = await localDataSource.getRememberToken();

    if (savedLocaleCode == null) {
      // First time: navigate to language selection
      emit(SplashNavigateToLanguageSelection());
    } else {
      if (rememberToken != null && rememberToken.isNotEmpty) {
        // Logged in with remember token: navigate to home
        final user = await localDataSource.getUser();
        if (user != null && user.role == 'organization') {
          emit(SplashNavigateToAdminHome());
        } else {
          emit(SplashNavigateToHome());
        }
      } else {
        // Not logged in: navigate to login
        emit(SplashNavigateToLogin());
      }
    }
  }
}
