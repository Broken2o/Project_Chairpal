import '../repositories/profile_repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<String> call({
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
    return await repository.updateProfile(
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
  }
}
