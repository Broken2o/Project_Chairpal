import '../../../auth/domain/entities/user.dart';
import '../../domain/entities/review.dart';
import '../../../auth/data/models/user_model.dart';

class ReviewModel extends Review {
  const ReviewModel({
    required super.id,
    required super.rating,
    required super.comment,
    super.user,
    super.createdAt,
    super.updatedAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] ?? 0,
      rating: double.tryParse(json['rating']?.toString() ?? '') ?? 0.0,
      comment: json['comment'] ?? '',
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rating': rating,
      'comment': comment,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
