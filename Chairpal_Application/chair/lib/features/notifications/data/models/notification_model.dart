class NotificationModel {
  final String id;
  final String name;
  final String message;
  final String timeAgo;
  final String avatarUrl;
  final int unreadCount;
  final bool isRead;
  final String notificationType;
  final int? senderId;
  final int? connectionId;
  final DateTime createdAt;

  const NotificationModel({
    required this.id,
    required this.name,
    required this.message,
    required this.timeAgo,
    required this.avatarUrl,
    required this.notificationType,
    this.senderId,
    this.connectionId,
    required this.createdAt,
    this.unreadCount = 0,
    this.isRead = false,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final createdAtStr = json['created_at'] as String?;
    final createdAt = createdAtStr != null ? DateTime.parse(createdAtStr) : DateTime.now();

    final userMap = data['user'] as Map<String, dynamic>?;

    return NotificationModel(
      id: json['id'] as String? ?? '',
      name: userMap?['name'] as String? ?? data['sender_name'] as String? ?? 'System',
      message: data['message'] as String? ?? '',
      timeAgo: _formatTimeAgo(createdAt),
      avatarUrl: userMap?['image'] as String? ?? '',
      notificationType: data['type'] as String? ?? '',
      senderId: data['sender_id'] as int? ?? userMap?['id'] as int?,
      connectionId: data['connection_id'] as int?,
      createdAt: createdAt,
      unreadCount: 0, 
      isRead: json['read_at'] != null,
    );
  }

  static String _formatTimeAgo(DateTime date) {
    final difference = DateTime.now().difference(date);
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago.';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago.';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago.';
    } else {
      return 'Just now';
    }
  }
}

