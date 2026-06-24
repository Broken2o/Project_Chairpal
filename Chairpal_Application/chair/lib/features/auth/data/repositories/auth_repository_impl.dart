import '../../../../core/network/api_result.dart';
import '../../../../core/error/failures.dart';
import 'package:dio/dio.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../datasources/auth_local_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<ApiResult<User>> login({
    required String email,
    required String password,
    bool remember = false,
  }) async {
    try {
      final userModel = await _remoteDataSource.login(email, password, remember);
      return ApiSuccess(userModel);
    } on DioException catch (e) {
      return ApiError(ServerFailure(e.response?.data['message'] ?? e.message ?? 'Unknown Error'));
    } catch (e) {
      return ApiError(ServerFailure(e.toString()));
    }
  }

  @override
  Future<ApiResult<String>> signup({
    required String name,
    required String username,
    required String email,
    required String password,
    required String passwordConfirmation,
    required int policies,
    required String role,
    String? phone,
    String? gender,
    String? birthDate,
    num? weight,
    num? height,
    List<int>? medicalConditionIds,
    String? doctorUsername,
    String? targetUsername,
    String? categoryName,
    String? description,
    int? followDoctor,
    String? location,
    double? latitude,
    double? longitude,
    String? countryName,
    String? cityName,
    dynamic image,
  }) async {
    try {
      final message = await _remoteDataSource.signup(
        name: name,
        username: username,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        policies: policies,
        role: role,
        phone: phone,
        gender: gender,
        birthDate: birthDate,
        weight: weight,
        height: height,
        medicalConditionIds: medicalConditionIds,
        doctorUsername: doctorUsername,
        targetUsername: targetUsername,
        categoryName: categoryName,
        description: description,
        followDoctor: followDoctor,
        location: location,
        latitude: latitude,
        longitude: longitude,
        countryName: countryName,
        cityName: cityName,
        image: image,
      );
      return ApiSuccess(message);
    } on DioException catch (e) {
      return ApiError(ServerFailure(e.response?.data['message'] ?? e.message ?? 'Unknown Error'));
    } catch (e) {
      return ApiError(ServerFailure(e.toString()));
    }
  }

  @override
  Future<ApiResult<void>> verifyEmail({
    required String email,
    required String code,
  }) async {
    try {
      await _remoteDataSource.verifyEmail(email: email, code: code);
      return const ApiSuccess(null);
    } on DioException catch (e) {
      return ApiError(ServerFailure(e.response?.data['message'] ?? e.message ?? 'Unknown Error'));
    } catch (e) {
      return ApiError(ServerFailure(e.toString()));
    }
  }

  @override
  Future<ApiResult<void>> resendVerificationCode({
    required String email,
  }) async {
    try {
      await _remoteDataSource.resendVerificationCode(email: email);
      return const ApiSuccess(null);
    } on DioException catch (e) {
      return ApiError(ServerFailure(e.response?.data['message'] ?? e.message ?? 'Unknown Error'));
    } catch (e) {
      return ApiError(ServerFailure(e.toString()));
    }
  }

  @override
  Future<ApiResult<void>> forgotPassword({
    required String email,
  }) async {
    try {
      await _remoteDataSource.forgotPassword(email: email);
      return const ApiSuccess(null);
    } on DioException catch (e) {
      return ApiError(ServerFailure(e.response?.data['message'] ?? e.message ?? 'Unknown Error'));
    } catch (e) {
      return ApiError(ServerFailure(e.toString()));
    }
  }

  @override
  Future<ApiResult<void>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      await _remoteDataSource.verifyOtp(email: email, otp: otp);
      return const ApiSuccess(null);
    } on DioException catch (e) {
      return ApiError(ServerFailure(e.response?.data['message'] ?? e.message ?? 'Unknown Error'));
    } catch (e) {
      return ApiError(ServerFailure(e.toString()));
    }
  }

  @override
  Future<ApiResult<void>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    try {
      await _remoteDataSource.resetPassword(
        email: email,
        otp: otp,
        newPassword: newPassword,
        newPasswordConfirmation: newPasswordConfirmation,
      );
      return const ApiSuccess(null);
    } on DioException catch (e) {
      return ApiError(ServerFailure(e.response?.data['message'] ?? e.message ?? 'Unknown Error'));
    } catch (e) {
      return ApiError(ServerFailure(e.toString()));
    }
  }

  @override
  Future<ApiResult<User>> getProfile() async {
    try {
      final userModel = await _remoteDataSource.getProfile();
      return ApiSuccess(userModel);
    } on DioException catch (e) {
      return ApiError(ServerFailure(e.response?.data['message'] ?? e.message ?? 'Profile fetch failed'));
    } catch (e) {
      return ApiError(ServerFailure(e.toString()));
    }
  }

  @override
  Future<ApiResult<void>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    try {
      await _remoteDataSource.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        newPasswordConfirmation: newPasswordConfirmation,
      );
      return const ApiSuccess(null);
    } on DioException catch (e) {
      return ApiError(ServerFailure(e.response?.data['message'] ?? e.message ?? 'Unknown Error'));
    } catch (e) {
      return ApiError(ServerFailure(e.toString()));
    }
  }

  @override
  Future<ApiResult<void>> logout() async {
    try {
      await _remoteDataSource.logout();
      await _localDataSource.clearTokens();
      return const ApiSuccess(null);
    } on DioException catch (e) {
      await _localDataSource.clearTokens(); // clear locally anyway
      return ApiError(ServerFailure(e.response?.data['message'] ?? e.message ?? 'Logout failed'));
    } catch (e) {
      await _localDataSource.clearTokens();
      return ApiError(ServerFailure(e.toString()));
    }
  }

  @override
  Future<ApiResult<void>> deleteAccount() async {
    try {
      await _remoteDataSource.deleteAccount();
      await _localDataSource.clearTokens();
      return const ApiSuccess(null);
    } on DioException catch (e) {
      return ApiError(ServerFailure(e.response?.data['message'] ?? e.message ?? 'Delete account failed'));
    } catch (e) {
      return ApiError(ServerFailure(e.toString()));
    }
  }

  @override
  Future<User?> getLocalUser() {
    return _localDataSource.getUser();
  }

  @override
  Future<void> clearLocalTokens() {
    return _localDataSource.clearTokens();
  }
}
