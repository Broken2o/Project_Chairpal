import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/network/api_result.dart';
import '../../../domain/usecases/auth_usecases.dart';
import 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final SignupUseCase _signupUseCase;

  SignupCubit({required SignupUseCase signupUseCase})
    : _signupUseCase = signupUseCase,
      super(const SignupState());

  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  Future<void> signup({
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
    bool? isFollowDoctor,
    String? location,
    double? latitude,
    double? longitude,
    String? countryName,
    String? cityName,
    dynamic image,
  }) async {
    emit(state.copyWith(status: SignupStatus.loading));

    final result = await _signupUseCase(
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
      followDoctor: isFollowDoctor == true ? 1 : 0,
      location: location,
      latitude: latitude,
      longitude: longitude,
      countryName: countryName,
      cityName: cityName,
      image: image,
    );

    if (result is ApiSuccess<String>) {
      emit(state.copyWith(status: SignupStatus.success, email: email, successMessage: result.data));
    } else if (result is ApiError<String>) {
      final failure = result.failure;
      emit(
        state.copyWith(
          status: SignupStatus.error,
          errorMessage: failure.message,
        ),
      );
    }
  }

  void resetState() {
    emit(const SignupState());
  }
}
