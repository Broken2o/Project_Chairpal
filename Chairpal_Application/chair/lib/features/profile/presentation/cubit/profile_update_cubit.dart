import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import '../../../../features/connections/domain/usecases/get_connected_doctor_usecase.dart';
import '../../../../features/connections/domain/usecases/remove_connection_usecase.dart';
import '../../../../features/auth/domain/entities/user.dart';

abstract class ProfileUpdateState {}

class ProfileUpdateInitial extends ProfileUpdateState {}
class ProfileUpdateLoading extends ProfileUpdateState {}
class ProfileUpdateSuccess extends ProfileUpdateState {
  final String message;
  ProfileUpdateSuccess(this.message);
}
class ProfileUpdateFailure extends ProfileUpdateState {
  final String error;
  ProfileUpdateFailure(this.error);
}

class DoctorStatusLoaded extends ProfileUpdateState {
  final User? connectedDoctor;
  DoctorStatusLoaded(this.connectedDoctor);
}

class ProfileUpdateCubit extends Cubit<ProfileUpdateState> {
  final UpdateProfileUseCase updateProfileUseCase;
  final GetConnectedDoctorUseCase getConnectedDoctorUseCase;
  final RemoveConnectionUseCase removeConnectionUseCase;

  User? currentConnectedDoctor;

  ProfileUpdateCubit({
    required this.updateProfileUseCase,
    required this.getConnectedDoctorUseCase,
    required this.removeConnectionUseCase,
  }) : super(ProfileUpdateInitial());

  Future<void> fetchConnectedDoctor() async {
    final result = await getConnectedDoctorUseCase();
    result.fold(
      (failure) => null,
      (doctor) {
        currentConnectedDoctor = doctor;
        emit(DoctorStatusLoaded(doctor));
      },
    );
  }

  Future<void> removeDoctor() async {
    if (currentConnectedDoctor == null) return;
    
    // Optimistic update or set loading
    final previousDoctor = currentConnectedDoctor;
    currentConnectedDoctor = null;
    emit(DoctorStatusLoaded(null));

    final result = await removeConnectionUseCase(previousDoctor!.id);
    result.fold(
      (failure) {
        // Revert
        currentConnectedDoctor = previousDoctor;
        emit(DoctorStatusLoaded(previousDoctor));
        emit(ProfileUpdateFailure(failure.message));
      },
      (_) {
        // Success
      },
    );
  }

  Future<void> updateProfile({
    String? name,
    String? username,
    String? phone,
    String? gender,
    String? birthDate,
    num? weight,
    num? height,
    List<int>? medicalConditionIds,
    bool? logoutOtherDevices,
    String? imagePath,
  }) async {
    emit(ProfileUpdateLoading());
    try {
      final message = await updateProfileUseCase(
        name: name,
        username: username,
        phone: phone,
        gender: gender,
        birthDate: birthDate,
        weight: weight,
        height: height,
        medicalConditionIds: medicalConditionIds,
        logoutOtherDevices: logoutOtherDevices,
        imagePath: imagePath,
      );
      emit(ProfileUpdateSuccess(message));
    } catch (e) {
      // Extract readable message from DioException API response
      String errorMessage = e.toString();
      if (e is Exception) {
        try {
          final dynamic dio = e;
          final responseData = dio.response?.data;
          if (responseData is Map && responseData['message'] != null) {
            errorMessage = responseData['message'].toString();
          }
        } catch (_) {}
      }
      emit(ProfileUpdateFailure(errorMessage));
    }
  }
}
