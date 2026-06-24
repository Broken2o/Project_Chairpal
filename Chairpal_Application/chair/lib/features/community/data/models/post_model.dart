class PostUser {
  final int id;
  final String name;
  final String? image;

  PostUser({required this.id, required this.name, this.image});

  factory PostUser.fromJson(Map<String, dynamic> json) {
    String? image = json['image'] ?? json['profile_image'] ?? json['avatar'] ?? json['profile_picture'];
    if (image == 'null' || image == '') {
      image = null;
    } else if (image != null && !image.startsWith('http')) {
      final String path = image.startsWith('/') ? image.substring(1) : image;
      // Assume storage path if relative
      image = 'https://chairpal-api.duckdns.org/storage/$path';
    }
    return PostUser(
      id: json['id'],
      name: json['name'] ?? 'Unknown User',
      image: image,
    );
  }
}

class PostModel {
  final int id;
  final PostUser user;
  final String content;
  final List<String> images;
  final int likesCount;
  final bool isLiked;
  final int commentsCount;
  final int sharesCount;
  final PostModel? sharedPost;
  final String createdAt;

  PostModel({
    required this.id,
    required this.user,
    required this.content,
    required this.images,
    required this.likesCount,
    required this.isLiked,
    required this.commentsCount,
    required this.sharesCount,
    this.sharedPost,
    required this.createdAt,
  });

  PostModel copyWith({
    int? id,
    PostUser? user,
    String? content,
    List<String>? images,
    int? likesCount,
    bool? isLiked,
    int? commentsCount,
    int? sharesCount,
    PostModel? sharedPost,
    String? createdAt,
  }) {
    return PostModel(
      id: id ?? this.id,
      user: user ?? this.user,
      content: content ?? this.content,
      images: images ?? this.images,
      likesCount: likesCount ?? this.likesCount,
      isLiked: isLiked ?? this.isLiked,
      commentsCount: commentsCount ?? this.commentsCount,
      sharesCount: sharesCount ?? this.sharesCount,
      sharedPost: sharedPost ?? this.sharedPost,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      user: PostUser.fromJson(json['user']),
      content: json['content'] ?? '',
      images: (json['images'] as List?)
          ?.where((e) => e != null && e.toString().isNotEmpty && e.toString() != 'null')
          .map((e) => e.toString())
          .toList() ??
          [],
      likesCount: json['likes_count'] ?? 0,
      isLiked: json['is_liked'] ?? false,
      commentsCount: json['comments_count'] ?? 0,
      sharesCount: json['shares_count'] ?? 0,
      sharedPost: json['shared_post'] != null ? PostModel.fromJson(json['shared_post']) : null,
      createdAt: json['created_at'] ?? '',
    );
  }
}

class CommentModel {
  final int id;
  final PostUser user;
  final String content;
  final int repliesCount;
  final int likesCount;
  final String createdAt;
  final String updatedAt;

  CommentModel({
    required this.id,
    required this.user,
    required this.content,
    required this.repliesCount,
    required this.likesCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'],
      user: PostUser.fromJson(json['user']),
      content: json['content'] ?? '',
      repliesCount: json['replies_count'] ?? 0,
      likesCount: json['likes_count'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}
