import 'dart:io';
import '../../data/models/chat_model.dart';
import '../../data/models/message_model.dart';

abstract class ChatRepository {
  Future<List<ChatModel>> getChats();
  Future<List<MessageModel>> getChatMessages(int userId);
  Future<MessageModel> sendMessage(int userId, String content, {File? attachment});
  Future<void> deleteMessage(int messageId);
  Future<void> deleteChat(int chatId);
  Future<MessageModel> updateMessage(int messageId, String content, {File? attachment});
}
