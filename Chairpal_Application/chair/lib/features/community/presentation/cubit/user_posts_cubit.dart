import 'dart:developer' as developer;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/community_repository.dart';
import '../../data/models/post_model.dart';

abstract class UserPostsState {}
class UserPostsInitial extends UserPostsState {}
class UserPostsLoading extends UserPostsState {}
class UserPostsLoaded extends UserPostsState {
  final List<PostModel> posts;
  UserPostsLoaded(this.posts);
}
class UserPostsError extends UserPostsState {
  final String message;
  UserPostsError(this.message);
}

class UserPostsCubit extends Cubit<UserPostsState> {
  final CommunityRepository repository;
  
  UserPostsCubit({required this.repository}) : super(UserPostsInitial());

  String? _nextCursor;
  bool _hasReachedMax = false;
  bool _isFetchingMore = false;

  bool get hasReachedMax => _hasReachedMax;
  bool get isFetchingMore => _isFetchingMore;

  Future<void> fetchUserPosts(int userId, {String? cursor}) async {
    developer.log('UserPostsCubit: Fetching posts for userId: $userId', name: 'CUBIT_ACTION');
    _nextCursor = cursor;
    _hasReachedMax = false;
    _isFetchingMore = false;
    emit(UserPostsLoading());
    try {
      final result = await repository.getAllPosts(userId: userId, cursor: _nextCursor);
      final posts = result['posts'] as List<PostModel>;
      _nextCursor = result['next_cursor'] as String?;
      if (posts.isEmpty || _nextCursor == null) {
        _hasReachedMax = true;
      }
      emit(UserPostsLoaded(posts));
    } catch (e) {
      emit(UserPostsError(e.toString()));
    }
  }

  Future<void> fetchMoreUserPosts(int userId) async {
    if (_hasReachedMax || _isFetchingMore || state is! UserPostsLoaded || _nextCursor == null) return;

    _isFetchingMore = true;
    final currentState = state as UserPostsLoaded;
    emit(UserPostsLoaded(List.from(currentState.posts))); // trigger spinner

    try {
      final result = await repository.getAllPosts(userId: userId, cursor: _nextCursor);
      final posts = result['posts'] as List<PostModel>;
      _nextCursor = result['next_cursor'] as String?;
      
      if (posts.isEmpty || _nextCursor == null) {
        _hasReachedMax = true;
      }
      if (posts.isNotEmpty) {
        emit(UserPostsLoaded(List.of(currentState.posts)..addAll(posts)));
      } else {
        emit(UserPostsLoaded(List.from(currentState.posts))); // hide spinner
      }
    } catch (e) {
      // Keep old cursor on error
    } finally {
      _isFetchingMore = false;
      if (state is UserPostsLoaded) {
        emit(UserPostsLoaded(List.from((state as UserPostsLoaded).posts))); // hide spinner
      }
    }
  }

  Future<String?> sharePost(int postId, {String? content}) async {
    try {
      final result = await repository.sharePost(postId, content: content);
      final sharedPost = result['post'] as PostModel;
      final message = result['message'] as String;
      
      if (state is UserPostsLoaded) {
        final currentState = state as UserPostsLoaded;
        final updatedPosts = List<PostModel>.from(currentState.posts)..insert(0, sharedPost);
        emit(UserPostsLoaded(updatedPosts));
      }
      return message;
    } catch (e) {
      developer.log('Error sharing post: $e', name: 'UserPostsCubit');
      rethrow;
    }
  }
}
