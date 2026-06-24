import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/post_model.dart';
import '../../domain/usecases/get_post_likes_usecase.dart';

abstract class PostLikesListState {}

class PostLikesListInitial extends PostLikesListState {}
class PostLikesListLoading extends PostLikesListState {}
class PostLikesListLoaded extends PostLikesListState {
  final List<PostUser> likes;
  final bool hasReachedMax;
  PostLikesListLoaded(this.likes, {this.hasReachedMax = false});
}
class PostLikesListError extends PostLikesListState {
  final String message;
  PostLikesListError(this.message);
}

class PostLikesListCubit extends Cubit<PostLikesListState> {
  final GetPostLikesUseCase getPostLikesUseCase;
  final int postId;
  int _currentPage = 1;
  bool _isFetching = false;

  PostLikesListCubit({required this.getPostLikesUseCase, required this.postId}) : super(PostLikesListInitial());

  Future<void> fetchLikes({bool refresh = false}) async {
    if (_isFetching) return;
    if (refresh) {
      _currentPage = 1;
    }
    if (state is PostLikesListLoaded && (state as PostLikesListLoaded).hasReachedMax && !refresh) return;

    _isFetching = true;
    if (_currentPage == 1) emit(PostLikesListLoading());

    try {
      final newLikes = await getPostLikesUseCase(postId, page: _currentPage);
      if (state is PostLikesListLoaded && !refresh) {
        final currentLikes = (state as PostLikesListLoaded).likes;
        emit(PostLikesListLoaded([...currentLikes, ...newLikes], hasReachedMax: newLikes.length < 10));
      } else {
        emit(PostLikesListLoaded(newLikes, hasReachedMax: newLikes.length < 10));
      }
      if (newLikes.isNotEmpty) _currentPage++;
    } catch (e) {
      if (_currentPage == 1) emit(PostLikesListError(e.toString()));
    } finally {
      _isFetching = false;
    }
  }
}
