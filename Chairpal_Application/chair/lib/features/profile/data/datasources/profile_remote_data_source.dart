import 'package:dio/dio.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../../home/data/models/place_model.dart';
import '../../../home/domain/entities/place.dart';

abstract class ProfileRemoteDataSource {
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

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final DioClient dioClient;

  ProfileRemoteDataSourceImpl({DioClient? dioClient}) : dioClient = dioClient ?? DioClient();

  @override
  Future<List<Place>> getFavorites() async {
    try {
      final response = await dioClient.dio.get(ApiConstants.getFavoritesEndpoint);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map<Place>((json) => PlaceModel.fromJson(json)).toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> sendSupportMessage(String message) async {
    try {
      final response = await dioClient.dio.post(
        ApiConstants.supportEndpoint,
        data: {'message': message},
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateLanguage(String languageCode) async {
    try {
      final response = await dioClient.dio.put(
        ApiConstants.updateLanguageEndpoint,
        data: {'language': languageCode},
      );

      if (response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
        );
      }
    } catch (e) {
      rethrow;
    }
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
    try {
      final formData = FormData.fromMap({
        if (name != null) 'name': name,
        if (username != null) 'username': username,
        if (phone != null) 'phone': phone,
        if (gender != null) 'gender': gender,
        if (birthDate != null) 'birth_date': birthDate,
        if (weight != null) 'weight': weight,
        if (height != null) 'height': height,
        if (logoutOtherDevices != null) 'logout_other_devices': logoutOtherDevices ? 1 : 0,
      });

      if (medicalConditionIds != null) {
        for (var i = 0; i < medicalConditionIds.length; i++) {
          formData.fields.add(MapEntry('medical_condition_ids[$i]', medicalConditionIds[i].toString()));
        }
      }

      if (imagePath != null) {
        formData.files.add(
          MapEntry(
            'image',
            await MultipartFile.fromFile(imagePath),
          ),
        );
      }

      final response = await dioClient.dio.put(
        ApiConstants.updateProfileEndpoint,
        data: formData,
      );

      if (response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
        );
      }

      return response.data['message']?.toString() ?? 'Profile updated successfully';
    } catch (e) {
      rethrow;
    }
  }
}
