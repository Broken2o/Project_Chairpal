import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../models/connection_model.dart';
import '../../../auth/data/models/user_model.dart';

abstract class ConnectionsRemoteDataSource {
  Future<List<ConnectionModel>> getPendingConnections();
  Future<List<UserModel>> getConnectedCompanions();
  Future<UserModel?> getConnectedDoctor();
  Future<void> handleConnection(int connectionId, String action);
  Future<void> removeConnection(int userId);
  Future<String> sendConnectionRequest(String targetUsername);
}

class ConnectionsRemoteDataSourceImpl implements ConnectionsRemoteDataSource {
  final DioClient _dioClient;

  ConnectionsRemoteDataSourceImpl({DioClient? dioClient})
      : _dioClient = dioClient ?? DioClient();

  @override
  Future<List<ConnectionModel>> getPendingConnections() async {
    try {
      final response = await _dioClient.dio.get('${ApiConstants.connectionsEndpoint}/pending');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => ConnectionModel.fromJson(json)).toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: response.data['message'] ?? 'Failed to get pending connections',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<UserModel>> getConnectedCompanions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userStr = prefs.getString('user_data');
      String endpoint = 'dashboard';
      if (userStr != null) {
        final Map<String, dynamic> userJson = jsonDecode(userStr);
        if (userJson['role'] == 'companion') {
          endpoint = ApiConstants.dashboardCompanionEndpoint;
        }
      }

      final response = await _dioClient.dio.get(endpoint);
      if (response.statusCode == 200) {
        final data = response.data['data'] ?? {};
        final List<dynamic> list = data['companions'] ?? data['patients'] ?? [];
        return list.map((json) => UserModel.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      // If there is an error, return empty to not block pending connections
      return [];
    }
  }

  @override
  Future<UserModel?> getConnectedDoctor() async {
    try {
      final response = await _dioClient.dio.get('${ApiConstants.connectionsEndpoint}/doctor');
      if (response.statusCode == 200) {
        final data = response.data['data'];
        if (data == null || (data is List && data.isEmpty)) return null;
        return UserModel.fromJson(data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: response.data['message'] ?? 'Failed to get connected doctor',
        );
      }
    } catch (e) {
      // If 404 or no doctor, just return null
      if (e is DioException && e.response?.statusCode == 404) {
        return null;
      }
      rethrow;
    }
  }

  @override
  Future<void> handleConnection(int connectionId, String action) async {
    try {
      final response = await _dioClient.dio.post(
        '${ApiConstants.connectionsEndpoint}/$connectionId/handle',
        queryParameters: {'action': action},
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: response.data['message'] ?? 'Failed to handle connection',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> removeConnection(int userId) async {
    try {
      final response = await _dioClient.dio.delete('${ApiConstants.connectionsEndpoint}/$userId/remove');
      if (response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: response.data['message'] ?? 'Failed to remove connection',
        );
      }
    } catch (e) {
      rethrow;
    }
  }
  @override
  Future<String> sendConnectionRequest(String targetUsername) async {
    try {
      final response = await _dioClient.dio.post(
        '${ApiConstants.connectionsEndpoint}/send',
        data: {
          'username': targetUsername,
          'connection_type': 'companion',
        },
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: response.data['message'] ?? 'Failed to send connection request',
        );
      }
      return response.data['message'] ?? 'Request Sent Successfully';
    } catch (e) {
      rethrow;
    }
  }
}
