import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../data/models/chat_model.dart';

abstract class ChatsState {}

class ChatsInitial extends ChatsState {}
class ChatsLoading extends ChatsState {}
class ChatsLoaded extends ChatsState {
  final List<ChatModel> chats;
  ChatsLoaded(this.chats);
}
class ChatsError extends ChatsState {
  final String message;
  ChatsError(this.message);
}

class ChatsCubit extends Cubit<ChatsState> {
  final ChatRepository repository;

  ChatsCubit({required this.repository}) : super(ChatsInitial());

  Future<void> fetchChats() async {
    emit(ChatsLoading());
    try {
      final chats = await repository.getChats();
      emit(ChatsLoaded(chats));
    } catch (e) {
      emit(ChatsError(e.toString()));
    }
  }

  Future<void> deleteChat(int chatId) async {
    try {
      await repository.deleteChat(chatId);
      if (state is ChatsLoaded) {
        final chats = (state as ChatsLoaded).chats;
        chats.removeWhere((chat) => chat.id == chatId);
        emit(ChatsLoaded(List.from(chats)));
      }
    } catch (e) {
      // Show error or ignore
    }
  }
}
