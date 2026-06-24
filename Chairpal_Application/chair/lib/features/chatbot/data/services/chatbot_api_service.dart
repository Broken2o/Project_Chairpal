import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';

class ChatBotApiService {
  final DioClient _dioClient;

  ChatBotApiService(this._dioClient);

  Future<int> createSession(String title) async {
    final response = await _dioClient.dio.post(
      '/chatbot/sessions',
      data: FormData.fromMap({
        'title': title,
      }),
    );
    return response.data['data']['id'];
  }

  Future<Map<String, dynamic>> getSessionMessages(int sessionId) async {
    final response = await _dioClient.dio.get(
      '/chatbot/sessions/$sessionId',
    );
    return response.data['data'];
  }

  Future<Map<String, dynamic>> chatWithBot(int sessionId, String message) async {
    final response = await _dioClient.dio.post(
      '/chatbot/sessions/$sessionId/chat',
      data: FormData.fromMap({'message': message}),
    );
    return response.data;
  }

  Future<List<dynamic>> getSessions() async {
    final response = await _dioClient.dio.get('/chatbot/sessions');
    return response.data['data'];
  }

  Future<void> reactToMessage(int messageId, String reaction) async {
    await _dioClient.dio.post(
      '/chatbot/messages/$messageId/reaction',
      data: FormData.fromMap({'reaction': reaction}),
    );
  }

  Future<void> deleteSession(int sessionId) async {
    await _dioClient.dio.delete('/chatbot/sessions/$sessionId');
  }
}
