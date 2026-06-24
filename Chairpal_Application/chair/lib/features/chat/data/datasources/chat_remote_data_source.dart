import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/api_constants.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';

abstract class ChatRemoteDataSource {
  Future<List<ChatModel>> getChats();
  Future<List<MessageModel>> getChatMessages(int userId);
  Future<MessageModel> sendMessage(int userId, String content, {File? attachment});
  Future<void> deleteMessage(int messageId);
  Future<void> deleteChat(int chatId);
  Future<MessageModel> updateMessage(int messageId, String content, {File? attachment});
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final DioClient _dioClient;

  ChatRemoteDataSourceImpl({DioClient? dioClient})
      : _dioClient = dioClient ?? DioClient();

  @override
  Future<List<ChatModel>> getChats() async {
    try {
      final response = await _dioClient.dio.get('${ApiConstants.baseUrl}chats');
      if (response.statusCode == 200) {
        final dataField = response.data['data'];
        List<dynamic> data = [];
        if (dataField is Map) {
          data = dataField['chats'] ?? [];
        } else if (dataField is List) {
          data = dataField;
        }
        return data.map((json) => ChatModel.fromJson(json)).toList();
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
  Future<List<MessageModel>> getChatMessages(int userId) async {
    try {
      final response = await _dioClient.dio.get('${ApiConstants.baseUrl}chats/$userId');
      if (response.statusCode == 200) {
        final dataField = response.data['data'];
        List<dynamic> data = [];
        if (dataField is Map) {
          data = dataField['messages'] ?? [];
        } else if (dataField is List) {
          data = dataField;
        }
        return data.map((json) => MessageModel.fromJson(json)).toList();
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
  Future<MessageModel> sendMessage(int userId, String content, {File? attachment}) async {
    try {
      FormData formData = FormData.fromMap({
        'content': content,
      });
      if (attachment != null) {
        formData.files.add(MapEntry(
          'attachment',
          await MultipartFile.fromFile(attachment.path),
        ));
      }
      final response = await _dioClient.dio.post('${ApiConstants.baseUrl}chats/$userId', data: formData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return MessageModel.fromJson(response.data['data']);
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
  Future<MessageModel> updateMessage(int messageId, String content, {File? attachment}) async {
    try {
      FormData formData = FormData.fromMap({
        'content': content,
        '_method': 'PUT',
      });
      if (attachment != null) {
        formData.files.add(MapEntry(
          'attachment',
          await MultipartFile.fromFile(attachment.path),
        ));
      }
      final response = await _dioClient.dio.post('${ApiConstants.baseUrl}messages/$messageId', data: formData);
      if (response.statusCode == 200) {
        return MessageModel.fromJson(response.data['data']);
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
  Future<void> deleteMessage(int messageId) async {
    try {
      await _dioClient.dio.delete('${ApiConstants.baseUrl}messages/$messageId');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteChat(int chatId) async {
    try {
      await _dioClient.dio.delete('${ApiConstants.baseUrl}chats/$chatId');
    } catch (e) {
      rethrow;
    }
  }
}
