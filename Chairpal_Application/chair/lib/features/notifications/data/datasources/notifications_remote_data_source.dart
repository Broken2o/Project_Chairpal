import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../models/notification_model.dart';

abstract class NotificationsRemoteDataSource {
  Future<List<NotificationModel>> getNotifications({int page = 1});
  Future<void> markAsRead(String notificationId);
}

class NotificationsRemoteDataSourceImpl implements NotificationsRemoteDataSource {
  final DioClient _dioClient;

  NotificationsRemoteDataSourceImpl({DioClient? dioClient})
      : _dioClient = dioClient ?? DioClient();

  @override
  Future<List<NotificationModel>> getNotifications({int page = 1}) async {
    try {
      final response = await _dioClient.dio.get(
        'notifications',
        queryParameters: {'page': page},
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data']['data'] ?? [];
        return data.map((json) => NotificationModel.fromJson(json)).toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: response.data['message'] ?? 'Failed to fetch notifications',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    try {
      await _dioClient.dio.post('notifications/$notificationId/read');
    } catch (e) {
      // ignore
    }
  }
}
