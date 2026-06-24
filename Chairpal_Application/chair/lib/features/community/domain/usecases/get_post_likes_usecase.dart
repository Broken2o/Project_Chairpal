import '../repositories/community_repository.dart';
import '../../data/models/post_model.dart';

class GetPostLikesUseCase {
  final CommunityRepository repository;

  GetPostLikesUseCase(this.repository);

  Future<List<PostUser>> call(int postId, {int? page}) {
    return repository.getPostLikes(postId, page: page);
  }
}
