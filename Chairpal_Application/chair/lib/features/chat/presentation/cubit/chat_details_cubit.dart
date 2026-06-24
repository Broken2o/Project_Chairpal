import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../data/models/message_model.dart';

abstract class ChatDetailsState {}

class ChatDetailsInitial extends ChatDetailsState {}
class ChatDetailsLoading extends ChatDetailsState {}
class ChatDetailsLoaded extends ChatDetailsState {
  final List<MessageModel> messages;
  ChatDetailsLoaded(this.messages);
}
class ChatDetailsError extends ChatDetailsState {
  final String message;
  ChatDetailsError(this.message);
}

class ChatDetailsCubit extends Cubit<ChatDetailsState> {
  final ChatRepository repository;

  ChatDetailsCubit({required this.repository}) : super(ChatDetailsInitial());

  Future<void> fetchMessages(int userId) async {
    emit(ChatDetailsLoading());
    try {
      final messages = await repository.getChatMessages(userId);
      emit(ChatDetailsLoaded(messages));
    } catch (e) {
      emit(ChatDetailsError(e.toString()));
    }
  }

  Future<void> sendMessage(int userId, String content, {File? attachment}) async {
    try {
      final newMessage = await repository.sendMessage(userId, content, attachment: attachment);
      if (state is ChatDetailsLoaded) {
        final messages = List<MessageModel>.from((state as ChatDetailsLoaded).messages);
        messages.insert(0, newMessage); // Assuming new messages at top or bottom depending on UI design
        emit(ChatDetailsLoaded(messages));
      } else {
        // If it wasn't loaded, just refetch
        fetchMessages(userId);
      }
    } catch (e) {
      // Handle error
    }
  }
}
