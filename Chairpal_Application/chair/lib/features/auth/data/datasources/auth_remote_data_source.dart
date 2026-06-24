import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../datasources/auth_local_data_source.dart';
import '../models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password, bool remember);
  Future<String> signup({
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
  });

  Future<void> verifyEmail({required String email, required String code});

  Future<void> resendVerificationCode({required String email});

  Future<void> forgotPassword({required String email});

  Future<void> verifyOtp({required String email, required String otp});

  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
    required String newPasswordConfirmation,
  });

  Future<UserModel> getProfile();
  Future<String?> refreshToken();
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  });
  Future<void> logout();
  Future<void> deleteAccount();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient _dioClient;

  AuthRemoteDataSourceImpl({DioClient? dioClient})
    : _dioClient = dioClient ?? DioClient();

  @override
  Future<UserModel> login(String email, String password, bool remember) async {
    try {
      final response = await _dioClient.dio.post(
        ApiConstants.loginEndpoint,
        data: {'email': email, 'password': password, 'remember': remember},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data['data'];
        final userModel = UserModel.fromJson(data);

        // Save tokens
        final prefs = await SharedPreferences.getInstance();
        final localDataSource = AuthLocalDataSourceImpl(
          sharedPreferences: prefs,
        );
        if (userModel.accessToken != null) {
          await localDataSource.saveToken(userModel.accessToken!);
        }
        if (userModel.rememberToken != null) {
          await localDataSource.saveRememberToken(userModel.rememberToken!);
        }
        await localDataSource.saveUser(userModel);

        return userModel;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: response.data['message'] ?? 'Login failed',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> signup({
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
      final Map<String, dynamic> dataMap = {
        'name': name,
        'username': username,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'policies': policies,
        'role': role,
        if (phone != null) 'phone': phone,
        if (gender != null) 'gender': gender,
        if (birthDate != null) 'birth_date': birthDate,
        if (weight != null) 'weight': weight,
        if (height != null) 'height': height,
        if (medicalConditionIds != null && medicalConditionIds.isNotEmpty)
          for (int i = 0; i < medicalConditionIds.length; i++)
            'medical_condition_ids[$i]': medicalConditionIds[i],
        if (doctorUsername != null) 'doctor_username': doctorUsername,
        if (targetUsername != null) 'target_username': targetUsername,
        if (categoryName != null) 'category_name': categoryName,
        if (description != null) 'description': description,
        if (followDoctor != null) 'follow_doctor': followDoctor,
        if (location != null) 'location': location,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
        if (countryName != null) 'country_name': countryName,
        if (cityName != null) 'city_name': cityName,
      };

      if (image != null) {
        if (image is XFile) {
          final String path = image.path;
          final String extension = path.split('.').last.toLowerCase();
          final String mimeType = (extension == 'jpg' || extension == 'jpeg')
              ? 'image/jpeg'
              : 'image/$extension';

          dataMap['image'] = await MultipartFile.fromFile(
            path,
            filename: 'image.$extension',
            contentType: MediaType.parse(mimeType),
          );
        }
      }

      final formData = FormData.fromMap(dataMap);

      final response = await _dioClient.dio.post(
        ApiConstants.signupEndpoint,
        data: formData,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Success
        return response.data['message'] ?? 'Account created successfully.';
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: response.data['message'] ?? 'Signup failed',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> verifyEmail({
    required String email,
    required String code,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        ApiConstants.verifyEmailEndpoint,
        data: FormData.fromMap({'email': email, 'otp': code}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: response.data['message'] ?? 'Verification failed',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> resendVerificationCode({required String email}) async {
    try {
      final response = await _dioClient.dio.post(
        ApiConstants.resendVerificationCodeEndpoint,
        data: FormData.fromMap({'email': email}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: response.data['message'] ?? 'Resend failed',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    try {
      final response = await _dioClient.dio.post(
        ApiConstants.forgotPasswordEndpoint,
        data: {'email': email},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: response.data['message'] ?? 'Failed to send OTP',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> verifyOtp({required String email, required String otp}) async {
    try {
      final response = await _dioClient.dio.post(
        ApiConstants.verifyOtpEndpoint,
        data: FormData.fromMap({'email': email, 'otp': otp}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: response.data['message'] ?? 'Invalid OTP',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        ApiConstants.resetPasswordEndpoint,
        data: {
          'email': email,
          'otp': otp,
          'password': newPassword,
          'password_confirmation': newPasswordConfirmation,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: response.data['message'] ?? 'Failed to reset password',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserModel> getProfile() async {
    try {
      final response = await _dioClient.dio.get(
        ApiConstants.getProfileEndpoint,
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        return UserModel.fromJson(data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: response.data['message'] ?? 'Failed to get profile',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String?> refreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final localDataSource = AuthLocalDataSourceImpl(sharedPreferences: prefs);
      final rememberToken = await localDataSource.getRememberToken();

      if (rememberToken == null) {
        throw Exception('No remember token found');
      }

      final response = await _dioClient.dio.post(
        ApiConstants.refreshTokenEndpoint,
        options: Options(headers: {'Authorization': 'Bearer $rememberToken'}),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];

        final accessToken = data['access_token'];
        final newRememberToken = data['remember_token'];

        // Update stored tokens
        if (accessToken != null) {
          await localDataSource.saveToken(accessToken);
        }
        if (newRememberToken != null) {
          await localDataSource.saveRememberToken(newRememberToken);
        }

        return accessToken;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: response.data['message'] ?? 'Token refresh failed',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    try {
      final formData = FormData.fromMap({
        'current_password': currentPassword,
        'new_password': newPassword,
        'new_password_confirmation': newPasswordConfirmation,
      });

      final response = await _dioClient.dio.post(
        ApiConstants.changePasswordEndpoint,
        queryParameters: {'_method': 'PUT'},
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: response.data['message'] ?? 'Failed to change password',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      final response = await _dioClient.dio.post(ApiConstants.logoutEndpoint);
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Successful logout from backend
        // We will clear tokens in UserCubit or AuthRepository
        return;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: response.data['message'] ?? 'Failed to logout',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      final response = await _dioClient.dio.delete(
        ApiConstants.deleteAccountEndpoint,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: response.data['message'] ?? 'Failed to delete account',
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
