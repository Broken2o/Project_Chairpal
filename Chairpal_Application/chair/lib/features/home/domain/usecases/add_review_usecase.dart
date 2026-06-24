import '../repositories/home_repository.dart';

class AddReviewUseCase {
  final HomeRepository repository;
  AddReviewUseCase(this.repository);

  Future<void> call(String type, int placeId, double rating, String comment) {
    return repository.addReview(type, placeId, rating, comment);
  }
}
