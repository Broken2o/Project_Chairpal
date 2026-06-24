import '../entities/review.dart';
import '../repositories/home_repository.dart';

class GetReviewsUseCase {
  final HomeRepository repository;
  GetReviewsUseCase(this.repository);

  Future<List<Review>> call(int placeId) {
    return repository.getReviews(placeId);
  }
}
