import '../../../../../core/network/api_result.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<ApiResult<User>> login({
    required String email,
    required String password,
    bool remember = false,
  });

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
    int? followDoctor, // 1 or 0
    String? location,
    double? latitude,
    double? longitude,
    String? countryName,
    String? cityName,
    dynamic image, // File or XFile
  });

  Future<ApiResult<void>> verifyEmail({
    required String email,
    required String code,
  });

  Future<ApiResult<void>> resendVerificationCode({
    required String email,
  });

  Future<ApiResult<void>> forgotPassword({
    required String email,
  });

  Future<ApiResult<void>> verifyOtp({
    required String email,
    required String otp,
  });

  Future<ApiResult<void>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
    required String newPasswordConfirmation,
  });

  Future<ApiResult<User>> getProfile();

  Future<ApiResult<void>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  });

  Future<ApiResult<void>> logout();
  Future<ApiResult<void>> deleteAccount();

  Future<User?> getLocalUser();
  Future<void> clearLocalTokens();
}
