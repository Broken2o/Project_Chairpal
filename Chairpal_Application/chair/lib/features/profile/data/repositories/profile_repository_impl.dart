import '../../domain/repositories/profile_repository.dart';
import '../../data/datasources/profile_remote_data_source.dart';
import '../../../home/domain/entities/place.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Place>> getFavorites() async {
    return await remoteDataSource.getFavorites();
  }

  @override
  Future<void> sendSupportMessage(String message) async {
    return await remoteDataSource.sendSupportMessage(message);
  }

  @override
  Future<void> updateLanguage(String languageCode) async {
    return await remoteDataSource.updateLanguage(languageCode);
  }

  @override
  Future<String> updateProfile({
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
    return await remoteDataSource.updateProfile(
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
