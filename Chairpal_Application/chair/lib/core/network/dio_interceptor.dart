import 'package:dio/dio.dart';
import '../network/api_constants.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../navigation/navigator_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class TokenInterceptor extends Interceptor {
  TokenInterceptor() {
    // We'll initialize it asynchronously if needed, or better, pass it.
    // For simplicity with the existing singleton pattern, we can use a getter.
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final localDataSource = AuthLocalDataSourceImpl(sharedPreferences: prefs);
    final token = await localDataSource.getToken();

    final isInternal =
        !options.path.startsWith('http') ||
        options.path.startsWith(ApiConstants.baseUrl);
    final isRefresh = options.path.contains(ApiConstants.refreshTokenEndpoint);

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    final savedLocaleCode = prefs.getString('app_locale') ?? 'en';
    if (isInternal) {
      options.headers['Accept-Language'] = savedLocaleCode;
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final isInternal =
        !err.requestOptions.path.startsWith('http') ||
        err.requestOptions.path.startsWith(ApiConstants.baseUrl);

    if (err.response?.statusCode == 401 && isInternal) {
      // Don't refresh if the request was for refreshing the token
      if (err.requestOptions.path.contains(ApiConstants.refreshTokenEndpoint)) {
        await _handleLogout();
        return handler.next(err);
      }

      try {
        // Try to refresh the token
        final AuthRemoteDataSource remoteDataSource =
            AuthRemoteDataSourceImpl();
        final newAccessToken = await remoteDataSource.refreshToken();

        if (newAccessToken != null) {
          // Re-try the original request
          final options = err.requestOptions;
          options.headers['Authorization'] = 'Bearer $newAccessToken';

          // Use a new Dio instance to avoid interceptor loops if needed,
          // or just the original one if we are careful.
          final retryDio = Dio();
          final response = await retryDio.fetch(options);
          return handler.resolve(response);
        }
      } catch (e) {
        // Refresh failed, logout
        await _handleLogout();
        return handler.next(err);
      }
    }
    super.onError(err, handler);
  }

  Future<void> _handleLogout() async {
    final prefs = await SharedPreferences.getInstance();
    final localDataSource = AuthLocalDataSourceImpl(sharedPreferences: prefs);
    await localDataSource.clearTokens();

    final state = NavigationService.navigatorKey.currentState;
    if (state != null) {
      state.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }
}
