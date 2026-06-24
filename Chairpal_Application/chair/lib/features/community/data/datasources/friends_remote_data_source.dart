import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/api_constants.dart';
import '../../../auth/data/models/user_model.dart';

abstract class FriendsRemoteDataSource {
  Future<List<UserModel>> getFriends();
  Future<List<UserModel>> getFriendRequests();
  Future<String> sendFriendRequest(int targetUserId);
  Future<String> handleFriendRequest(int targetUserId, String action);
  Future<String> removeFriend(int targetUserId);
}

class FriendsRemoteDataSourceImpl implements FriendsRemoteDataSource {
  final DioClient _dioClient;

  FriendsRemoteDataSourceImpl({DioClient? dioClient})
      : _dioClient = dioClient ?? DioClient();

  @override
  Future<List<UserModel>> getFriends() async {
    try {
      final response = await _dioClient.dio.get('${ApiConstants.baseUrl}community/friends');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => UserModel.fromJson(json)).toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<UserModel>> getFriendRequests() async {
    try {
      final response = await _dioClient.dio.get('${ApiConstants.baseUrl}community/friends/requests');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => UserModel.fromJson(json)).toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> sendFriendRequest(int targetUserId) async {
    try {
      final response = await _dioClient.dio.post('${ApiConstants.baseUrl}community/friends/send', data: {
        'user_id': targetUserId,
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data['message'] ?? 'Friend request sent successfully.';
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> handleFriendRequest(int targetUserId, String action) async {
    try {
      final response = await _dioClient.dio.post(
        '${ApiConstants.baseUrl}community/friends/$targetUserId/handle',
        queryParameters: {'action': action},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data['message'] ?? 'Friend request handled.';
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> removeFriend(int targetUserId) async {
    try {
      final response = await _dioClient.dio.delete('${ApiConstants.baseUrl}community/friends/$targetUserId/remove');
      if (response.statusCode == 200) {
        return response.data['message'] ?? 'Friend removed successfully.';
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
