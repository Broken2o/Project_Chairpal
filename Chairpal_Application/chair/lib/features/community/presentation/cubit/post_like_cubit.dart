import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/toggle_like_usecase.dart';

class PostLikeState {
  final bool isLiked;
  final int likesCount;
  final bool hasError;

  PostLikeState({required this.isLiked, required this.likesCount, this.hasError = false});

  PostLikeState copyWith({bool? isLiked, int? likesCount, bool? hasError}) {
    return PostLikeState(
      isLiked: isLiked ?? this.isLiked,
      likesCount: likesCount ?? this.likesCount,
      hasError: hasError ?? this.hasError,
    );
  }
}

class PostLikeCubit extends Cubit<PostLikeState> {
  final ToggleLikeUseCase toggleLikeUseCase;
  final int postId;

  PostLikeCubit({
    required this.toggleLikeUseCase,
    required this.postId,
    required bool initialIsLiked,
    required int initialLikesCount,
  }) : super(PostLikeState(isLiked: initialIsLiked, likesCount: initialLikesCount));

  Future<void> toggleLike() async {
    final previousIsLiked = state.isLiked;
    final previousLikesCount = state.likesCount;

    // Optimistic Update
    emit(state.copyWith(
      isLiked: !previousIsLiked,
      likesCount: previousIsLiked ? previousLikesCount - 1 : previousLikesCount + 1,
      hasError: false,
    ));

    try {
      await toggleLikeUseCase(postId);
    } catch (e) {
      // Revert on failure
      emit(state.copyWith(
        isLiked: previousIsLiked,
        likesCount: previousLikesCount,
        hasError: true,
      ));
    }
  }
}
