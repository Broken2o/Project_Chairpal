import '../../../home/domain/entities/place.dart';

abstract class ProfileRepository {
  Future<List<Place>> getFavorites();
  Future<void> sendSupportMessage(String message);
  Future<void> updateLanguage(String languageCode);
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
  });
}
