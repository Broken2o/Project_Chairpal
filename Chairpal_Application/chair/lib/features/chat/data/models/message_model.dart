class MessageModel {
  final int id;
  final String type;
  final String content;
  final String? attachment;
  final bool isRead;
  final String createdAt;
  final String updatedAt;

  MessageModel({
    required this.id,
    required this.type,
    required this.content,
    this.attachment,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      type: json['type'],
      content: json['content'] ?? '',
      attachment: json['attachment'],
      isRead: json['is_read'] ?? false,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'content': content,
      'attachment': attachment,
      'is_read': isRead,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
