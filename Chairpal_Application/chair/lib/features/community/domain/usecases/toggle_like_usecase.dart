import '../repositories/community_repository.dart';

class ToggleLikeUseCase {
  final CommunityRepository repository;

  ToggleLikeUseCase(this.repository);

  Future<void> call(int postId) {
    return repository.toggleLike(postId);
  }
}
