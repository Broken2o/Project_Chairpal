/// A single chat message in the conversation.
class ChatMessage {
  final int? id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final String? reaction; // 'like' or 'dislike'

  /// When `true`, the bubble is rendered with an error style.
  final bool isError;

  const ChatMessage({
    this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.reaction,
    this.isError = false,
  });

  ChatMessage copyWith({
    int? id,
    String? text,
    bool? isUser,
    DateTime? timestamp,
    String? reaction,
    bool? isError,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      reaction: reaction ?? this.reaction,
      isError: isError ?? this.isError,
    );
  }
}
