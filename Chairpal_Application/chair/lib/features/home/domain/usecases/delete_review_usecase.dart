import '../repositories/home_repository.dart';

class DeleteReviewUseCase {
  final HomeRepository repository;
  DeleteReviewUseCase(this.repository);

  Future<void> call(int id) {
    return repository.deleteReview(id);
  }
}
