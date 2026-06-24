import 'package:flutter_bloc/flutter_bloc.dart';
import 'review_state.dart';
import '../../../../home/domain/usecases/get_reviews_usecase.dart';
import '../../../../home/domain/usecases/add_review_usecase.dart';
import '../../../../home/domain/usecases/delete_review_usecase.dart';

class ReviewCubit extends Cubit<ReviewState> {
  final GetReviewsUseCase getReviewsUseCase;
  final AddReviewUseCase addReviewUseCase;
  final DeleteReviewUseCase deleteReviewUseCase;

  ReviewCubit({
    required this.getReviewsUseCase,
    required this.addReviewUseCase,
    required this.deleteReviewUseCase,
  }) : super(ReviewInitial());

  Future<void> fetchReviews(String type, int id) async {
    emit(ReviewLoading());
    try {
      final reviews = await getReviewsUseCase(id);
      emit(ReviewLoaded(reviews.cast()));
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }

  Future<void> addReview(String type, int id, double rating, String comment) async {
    try {
      await addReviewUseCase(type, id, rating, comment);
      emit(ReviewActionSuccess());
      fetchReviews(type, id);
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }

  Future<void> deleteReview(String type, int id, int reviewId) async {
    try {
      await deleteReviewUseCase(reviewId);
      emit(ReviewActionSuccess());
      fetchReviews(type, id);
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }
}
