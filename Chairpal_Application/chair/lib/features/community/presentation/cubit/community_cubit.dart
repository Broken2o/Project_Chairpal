import 'dart:developer' as developer;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/community_repository.dart';
import '../../data/models/post_model.dart';

abstract class CommunityState {}
class CommunityInitial extends CommunityState {}
class CommunityLoading extends CommunityState {}
class CommunityLoaded extends CommunityState {
  final List<PostModel> posts;
  CommunityLoaded(this.posts);
}
class CommunityError extends CommunityState {
  final String message;
  CommunityError(this.message);
}

class CommunityCubit extends Cubit<CommunityState> {
  final CommunityRepository repository;
  
  CommunityCubit({required this.repository}) : super(CommunityInitial());

  String? _nextCursor;
  bool _hasReachedMax = false;
  bool _isFetchingMore = false;

  bool get hasReachedMax => _hasReachedMax;
  bool get isFetchingMore => _isFetchingMore;

  Future<void> fetchPosts() async {
    developer.log('CommunityCubit: Fetching initial posts', name: 'CUBIT_ACTION');
    _nextCursor = null;
    _hasReachedMax = false;
    _isFetchingMore = false;
    emit(CommunityLoading());
    try {
      final result = await repository.getAllPosts();
      final posts = result['posts'] as List<PostModel>;
      _nextCursor = result['next_cursor'] as String?;
      if (posts.isEmpty || _nextCursor == null) {
        _hasReachedMax = true;
      }
      emit(CommunityLoaded(posts));
    } catch (e) {
      developer.log('CommunityCubit: Error fetching posts: $e', name: 'CUBIT_ERROR');
      emit(CommunityError(e.toString()));
    }
  }

  Future<void> fetchMorePosts() async {
    if (_hasReachedMax || _isFetchingMore || state is! CommunityLoaded || _nextCursor == null) return;

    _isFetchingMore = true;
    final currentState = state as CommunityLoaded;
    emit(CommunityLoaded(List.from(currentState.posts))); // trigger spinner

    try {
      final result = await repository.getAllPosts(cursor: _nextCursor);
      final posts = result['posts'] as List<PostModel>;
      _nextCursor = result['next_cursor'] as String?;
      
      if (posts.isEmpty || _nextCursor == null) {
        _hasReachedMax = true;
      }
      if (posts.isNotEmpty) {
        emit(CommunityLoaded(List.of(currentState.posts)..addAll(posts)));
      } else {
        emit(CommunityLoaded(List.from(currentState.posts))); // hide spinner
      }
    } catch (e) {
      // Keep old cursor on error
    } finally {
      _isFetchingMore = false;
      if (state is CommunityLoaded) {
        emit(CommunityLoaded(List.from((state as CommunityLoaded).posts)));
      }
    }
  }

  Future<void> hidePost(PostModel post) async {
    final currentState = state;
    if (currentState is CommunityLoaded) {
      final updatedPosts = List<PostModel>.from(currentState.posts)
        ..removeWhere((p) => p.id == post.id);
      emit(CommunityLoaded(updatedPosts));

      try {
        await repository.hidePost(post.id);
      } catch (e) {
        // If error, we might want to restore the post or show an error
        // For now, let's just keep it hidden or restore if it failed
        emit(CommunityLoaded(currentState.posts));
      }
    }
  }

  Future<void> undoHidePost(PostModel post, int originalIndex) async {
    final currentState = state;
    if (currentState is CommunityLoaded) {
      final updatedPosts = List<PostModel>.from(currentState.posts);
      if (originalIndex <= updatedPosts.length) {
        updatedPosts.insert(originalIndex, post);
      } else {
        updatedPosts.add(post);
      }
      emit(CommunityLoaded(updatedPosts));

      try {
        await repository.hidePost(post.id); // Toggle back
      } catch (e) {
        // Handle error
      }
    }
  }

  Future<String?> sharePost(int postId, {String? content}) async {
    try {
      final result = await repository.sharePost(postId, content: content);
      final sharedPost = result['post'] as PostModel;
      final message = result['message'] as String;
      
      if (state is CommunityLoaded) {
        final currentState = state as CommunityLoaded;
        final updatedPosts = List<PostModel>.from(currentState.posts)..insert(0, sharedPost);
        emit(CommunityLoaded(updatedPosts));
      }
      return message;
    } catch (e) {
      developer.log('Error sharing post: $e', name: 'CommunityCubit');
      rethrow;
    }
  }
}
