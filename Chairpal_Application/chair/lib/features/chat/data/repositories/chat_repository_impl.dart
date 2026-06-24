import 'dart:io';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_data_source.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ChatModel>> getChats() {
    return remoteDataSource.getChats();
  }

  @override
  Future<List<MessageModel>> getChatMessages(int userId) {
    return remoteDataSource.getChatMessages(userId);
  }

  @override
  Future<MessageModel> sendMessage(int userId, String content, {File? attachment}) {
    return remoteDataSource.sendMessage(userId, content, attachment: attachment);
  }

  @override
  Future<void> deleteMessage(int messageId) {
    return remoteDataSource.deleteMessage(messageId);
  }

  @override
  Future<void> deleteChat(int chatId) {
    return remoteDataSource.deleteChat(chatId);
  }

  @override
  Future<MessageModel> updateMessage(int messageId, String content, {File? attachment}) {
    return remoteDataSource.updateMessage(messageId, content, attachment: attachment);
  }
}
