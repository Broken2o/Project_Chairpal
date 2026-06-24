import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/community_repository.dart';
import '../../data/models/post_model.dart';

abstract class PostCommentsState {}
class PostCommentsInitial extends PostCommentsState {}
class PostCommentsLoading extends PostCommentsState {}
class PostCommentsLoaded extends PostCommentsState {
  final List<CommentModel> comments;
  PostCommentsLoaded(this.comments);
}
class PostCommentsError extends PostCommentsState {
  final String message;
  PostCommentsError(this.message);
}

class PostCommentsCubit extends Cubit<PostCommentsState> {
  final CommunityRepository repository;
  
  PostCommentsCubit({required this.repository}) : super(PostCommentsInitial());

  Future<void> fetchComments(int postId) async {
    emit(PostCommentsLoading());
    try {
      final comments = await repository.getPostComments(postId);
      emit(PostCommentsLoaded(comments));
    } catch (e) {
      emit(PostCommentsError(e.toString()));
    }
  }

  Future<void> addComment(int postId, String content) async {
    if (state is PostCommentsLoaded) {
      final currentState = state as PostCommentsLoaded;
      try {
        final newComment = await repository.createComment(postId, content);
        emit(PostCommentsLoaded([newComment, ...currentState.comments]));
      } catch (e) {
        // handle error
      }
    }
  }

  Future<void> toggleLike(int commentId) async {
    // Optimistic UI update can go here
    try {
      await repository.toggleCommentLike(commentId);
    } catch (e) {
      // handle error
    }
  }
}
