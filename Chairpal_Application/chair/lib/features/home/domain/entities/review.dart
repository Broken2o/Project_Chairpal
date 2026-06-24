import 'package:equatable/equatable.dart';
import '../../../auth/domain/entities/user.dart';

class Review extends Equatable {
  final int id;
  final double rating;
  final String comment;
  final User? user;
  final String? createdAt;
  final String? updatedAt;

  const Review({
    required this.id,
    required this.rating,
    required this.comment,
    this.user,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [id, rating, comment, user, createdAt, updatedAt];
}
