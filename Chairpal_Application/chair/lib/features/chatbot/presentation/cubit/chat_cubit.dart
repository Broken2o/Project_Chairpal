import 'dart:developer' as dev;

import 'package:flutter/foundation.dart';

import '../../data/models/chat_message_model.dart';
import '../../data/models/chat_session_model.dart';
import '../../data/services/chatbot_api_service.dart';
import '../../../../core/di/injection_container.dart';

/// Manages the chat message list and API interaction.
class ChatCubit extends ChangeNotifier {
  final List<ChatMessage> _messages = [];
  bool _welcomeInitialized = false;

  bool _isLoading = false;
  String? _error;
  int? _sessionId;
  List<ChatSession> _sessions = [];
  late final ChatBotApiService _apiService;

  ChatCubit() {
    _apiService = ChatBotApiService(sl());
  }

  List<ChatMessage> get messages => List.unmodifiable(_messages);
  List<ChatSession> get sessions => List.unmodifiable(_sessions);
  bool get isLoading => _isLoading;
  String? get error => _error;
  int? get sessionId => _sessionId;

  void initWelcomeMessage(String welcomeText) {
    if (!_welcomeInitialized && _messages.isEmpty) {
      _messages.add(
        ChatMessage(
          text: welcomeText,
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
      _welcomeInitialized = true;
    }
  }

  /// Sends [text] from the user, calls the API, and appends the reply.
  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    dev.log('User sent: "$trimmed"', name: 'ChatCubit');

    // Add user bubble immediately.
    _messages.add(
      ChatMessage(
        text: trimmed,
        isUser: true,
        timestamp: DateTime.now(),
      ),
    );
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _sessionId ??= await _apiService.createSession('New Chat');

      final data = await _apiService.chatWithBot(_sessionId!, trimmed);
      
      final userMsg = data['user_message'];
      if (userMsg != null) {
        final index = _messages.lastIndexWhere((m) => m.isUser && m.id == null);
        if (index != -1) {
          _messages[index] = _messages[index].copyWith(id: userMsg['id']);
        }
      }

      final botMsg = data['bot_message'];
      
      if (botMsg != null) {
        _messages.add(
          ChatMessage(
            id: botMsg['id'],
            text: botMsg['content'],
            isUser: false,
            timestamp: DateTime.parse(botMsg['created_at']),
            reaction: botMsg['reaction'],
          ),
        );
      }
    } catch (e, s) {
      dev.log(
        'ChatCubit error: $e',
        name: 'ChatCubit',
        level: 1000,
        error: e,
        stackTrace: s,
      );
      _error = e.toString();
      // Add an error bubble so the user sees it inline.
      _messages.add(
        ChatMessage(
          text: '⚠️ $_error',
          isUser: false,
          timestamp: DateTime.now(),
          isError: true,
        ),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> reactToMessage(int messageId, String reaction) async {
    try {
      await _apiService.reactToMessage(messageId, reaction);
      
      // Update the message in the list
      final index = _messages.indexWhere((m) => m.id == messageId);
      if (index != -1) {
        _messages[index] = _messages[index].copyWith(reaction: reaction);
        notifyListeners();
      }
    } catch (e) {
      dev.log('Error reacting to message: $e');
    }
  }

  Future<void> clearHistory(String clearedText) async {
    if (_sessionId != null) {
      try {
        await _apiService.deleteSession(_sessionId!);
      } catch (e) {
        dev.log('Error deleting session: $e');
      }
    }
    _sessionId = null;
    _messages.clear();
    _messages.add(
      ChatMessage(
        text: clearedText,
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  Future<void> fetchSessions() async {
    try {
      final data = await _apiService.getSessions();
      _sessions = data.map((e) => ChatSession.fromJson(e)).toList();
      notifyListeners();
    } catch (e) {
      dev.log('Error fetching sessions: $e');
    }
  }

  Future<void> loadSession(int sessionId) async {
    _sessionId = sessionId;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _apiService.getSessionMessages(sessionId);
      final messagesData = data['messages'] as List;

      _messages.clear();
      for (var msg in messagesData) {
        _messages.add(
          ChatMessage(
            id: msg['id'],
            text: msg['content'],
            isUser: msg['sender_type'] == 'user',
            timestamp: DateTime.parse(msg['created_at']),
            reaction: msg['reaction'],
          ),
        );
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
