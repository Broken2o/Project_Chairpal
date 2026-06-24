import 'package:equatable/equatable.dart';
import '../../../../home/data/models/review_model.dart';

abstract class ReviewState extends Equatable {
  const ReviewState();
  @override
  List<Object?> get props => [];
}

class ReviewInitial extends ReviewState {}

class ReviewLoading extends ReviewState {}

class ReviewLoaded extends ReviewState {
  final List<ReviewModel> reviews;
  const ReviewLoaded(this.reviews);
  @override
  List<Object?> get props => [reviews];
}

class ReviewActionSuccess extends ReviewState {}

class ReviewError extends ReviewState {
  final String message;
  const ReviewError(this.message);
  @override
  List<Object?> get props => [message];
}
