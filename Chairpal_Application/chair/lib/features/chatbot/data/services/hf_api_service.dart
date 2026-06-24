import 'dart:developer' as dev;

import 'package:dio/dio.dart';

/// Service that wraps the ChairPal AI chatbot REST API.
class HFApiService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://chatbot-api-ie8h.onrender.com',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  /// Sends [message] to the chatbot and returns the reply text.
  static Future<String> sendChatMessage({
    required String message,
    String systemMessage =
        'You are a friendly travel assistant chatbot for the ChairPal app. '
            'Help users discover places, plan trips, and answer travel questions.',
    int maxTokens = 200,
    double temperature = 0.7,
    double topP = 0.95,
  }) async {
    dev.log(
      'Sending chat message: "$message"',
      name: 'HFApiService',
    );
    try {
      final response = await _dio.post(
        '/chat',
        data: {
          'message': message,
          'system_message': systemMessage,
          'max_tokens': maxTokens,
          'temperature': temperature,
          'top_p': topP,
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      dev.log(
        'Response received: ${response.data}',
        name: 'HFApiService',
      );

      return response.data['response'] as String? ??
          response.data.toString();
    } on DioException catch (e) {
      dev.log(
        'DioException:\n'
        '  type    : ${e.type}\n'
        '  status  : ${e.response?.statusCode}\n'
        '  body    : ${e.response?.data}\n'
        '  message : ${e.message}',
        name: 'HFApiService',
        level: 1000,
        error: e,
        stackTrace: e.stackTrace,
      );
      throw _handleDioError(e);
    } catch (e, s) {
      dev.log(
        'Unexpected error: $e',
        name: 'HFApiService',
        level: 1000,
        error: e,
        stackTrace: s,
      );
      throw 'An unexpected error occurred: $e';
    }
  }

  static String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout. Please check your internet.';
      case DioExceptionType.receiveTimeout:
        return 'The server took too long to respond.';
      case DioExceptionType.sendTimeout:
        return 'Failed to send the message. Try again.';
      case DioExceptionType.badResponse:
        return 'Server error ${e.response?.statusCode}. Please try later.';
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      default:
        return 'Network error: ${e.message}';
    }
  }
}
