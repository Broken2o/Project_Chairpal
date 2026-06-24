import '../../../auth/data/models/user_model.dart';

class ChatLastMessage {
  final String content;
  final String type;
  final String createdAt;

  ChatLastMessage({
    required this.content,
    required this.type,
    required this.createdAt,
  });

  factory ChatLastMessage.fromJson(Map<String, dynamic> json) {
    return ChatLastMessage(
      content: json['content'] ?? '',
      type: json['type'] ?? 'text',
      createdAt: json['created_at'] ?? '',
    );
  }
}

class ChatModel {
  final int id;
  final UserModel partner;
  final int unreadCount;
  final ChatLastMessage? lastMessage;
  final String updatedAt;

  ChatModel({
    required this.id,
    required this.partner,
    required this.unreadCount,
    this.lastMessage,
    required this.updatedAt,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'],
      partner: UserModel.fromJson(json['partner'] ?? {}),
      unreadCount: json['unread_count'] ?? 0,
      lastMessage: json['last_message'] != null ? ChatLastMessage.fromJson(json['last_message']) : null,
      updatedAt: json['updated_at'] ?? '',
    );
  }
}
