import '../../../../../core/network/api_result.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;
  LoginUseCase(this.repository);

  Future<ApiResult<User>> call({
    required String email,
    required String password,
    bool remember = false,
  }) {
    return repository.login(email: email, password: password, remember: remember);
  }
}

class SignupUseCase {
  final AuthRepository repository;
  SignupUseCase(this.repository);

  Future<ApiResult<String>> call({
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
  }) {
    return repository.signup(
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
  }
}

class VerifyEmailUseCase {
  final AuthRepository repository;
  VerifyEmailUseCase(this.repository);

  Future<ApiResult<void>> call({required String email, required String code}) {
    return repository.verifyEmail(email: email, code: code);
  }
}

class ResendVerificationCodeUseCase {
  final AuthRepository repository;
  ResendVerificationCodeUseCase(this.repository);

  Future<ApiResult<void>> call({required String email}) {
    return repository.resendVerificationCode(email: email);
  }
}

class ForgotPasswordUseCase {
  final AuthRepository repository;
  ForgotPasswordUseCase(this.repository);

  Future<ApiResult<void>> call({required String email}) {
    return repository.forgotPassword(email: email);
  }
}

class VerifyOtpUseCase {
  final AuthRepository repository;
  VerifyOtpUseCase(this.repository);

  Future<ApiResult<void>> call({required String email, required String otp}) {
    return repository.verifyOtp(email: email, otp: otp);
  }
}

class ResetPasswordUseCase {
  final AuthRepository repository;
  ResetPasswordUseCase(this.repository);

  Future<ApiResult<void>> call({
    required String email,
    required String otp,
    required String newPassword,
    required String newPasswordConfirmation,
  }) {
    return repository.resetPassword(
      email: email,
      otp: otp,
      newPassword: newPassword,
      newPasswordConfirmation: newPasswordConfirmation,
    );
  }
}

class GetProfileUseCase {
  final AuthRepository repository;
  GetProfileUseCase(this.repository);

  Future<ApiResult<User>> call() {
    return repository.getProfile();
  }
}

class ChangePasswordUseCase {
  final AuthRepository repository;
  ChangePasswordUseCase(this.repository);

  Future<ApiResult<void>> call({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) {
    return repository.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
      newPasswordConfirmation: newPasswordConfirmation,
    );
  }
}

class LogoutUseCase {
  final AuthRepository repository;
  LogoutUseCase(this.repository);

  Future<ApiResult<void>> call() {
    return repository.logout();
  }
}

class DeleteAccountUseCase {
  final AuthRepository repository;
  DeleteAccountUseCase(this.repository);

  Future<ApiResult<void>> call() {
    return repository.deleteAccount();
  }
}

class GetLocalUserUseCase {
  final AuthRepository repository;
  GetLocalUserUseCase(this.repository);

  Future<User?> call() {
    return repository.getLocalUser();
  }
}

class ClearLocalTokensUseCase {
  final AuthRepository repository;
  ClearLocalTokensUseCase(this.repository);

  Future<void> call() {
    return repository.clearLocalTokens();
  }
}
