import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/undo_snack_bar.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../l10n/l10n.dart';
import '../../data/models/post_model.dart';
import '../cubit/community_cubit.dart';
import 'post_action_button.dart';
import '../../domain/repositories/community_repository.dart';
import '../cubit/post_comments_cubit.dart';
import '../cubit/user_posts_cubit.dart';
import 'comments_sheet.dart';
import '../screens/user_posts_screen.dart';
import 'post_stats_row.dart';
import 'post_image_grid.dart';
import '../../../../core/utils/date_formatter.dart';
import '../cubit/post_like_cubit.dart';
import '../../domain/usecases/toggle_like_usecase.dart';
import 'post_likes_bottom_sheet.dart';
import 'share_post_sheet.dart';

class PostCard extends StatefulWidget {
  final PostModel post;
  
  const PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostLikeCubit(
        toggleLikeUseCase: ToggleLikeUseCase(context.read<CommunityRepository>()),
        postId: widget.post.id,
        initialIsLiked: widget.post.isLiked,
        initialLikesCount: widget.post.likesCount,
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: 24.h),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserPostsScreen(user: widget.post.user),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.shimmer,
                        child: ClipOval(
                          child: widget.post.user.image != null
                              ? Image.network(
                                  widget.post.user.image!,
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.person, color: Colors.grey),
                                )
                              : const Icon(Icons.person, color: Colors.grey),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.post.user.name,
                            style: AppStyles.bodyMediumBoldPrimaryDark,
                          ),
                          Text(
                            DateFormatter.timeAgo(widget.post.createdAt),
                            style: AppStyles.bodySmall.copyWith(
                              color: AppColors.textHint,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.primary, size: 20),
                  onPressed: () {
                    final cubit = context.read<CommunityCubit>();
                    final currentState = cubit.state;
                    if (currentState is CommunityLoaded) {
                      final originalIndex = currentState.posts.indexOf(widget.post);
                      cubit.hidePost(widget.post);

                      UndoSnackBar.show(
                        context,
                        message: S.of(context)!.postHidden,
                        undoLabel: S.of(context)!.undo,
                        onUndo: () {
                          cubit.undoHidePost(widget.post, originalIndex);
                        },
                      );
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 12.h),
            
            // Content
            _buildContentText(),
            
            // Image Attachment
            if (widget.post.images.isNotEmpty) ...[
              SizedBox(height: 12.h),
              PostImageGrid(images: widget.post.images),
            ],

            // Shared Post
            if (widget.post.sharedPost != null) ...[
              SizedBox(height: 12.h),
              _buildSharedPost(widget.post.sharedPost!),
            ],
            
            SizedBox(height: 12.h),

            // Stats
            BlocBuilder<PostLikeCubit, PostLikeState>(
              builder: (context, state) {
                return PostStatsRow(
                  likesCount: state.likesCount,
                  sharesCount: widget.post.sharesCount,
                  onLikesTap: () {
                    if (state.likesCount > 0) {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => PostLikesBottomSheet(postId: widget.post.id),
                      );
                    }
                  },
                );
              },
            ),
            
            SizedBox(height: 12.h),
            const Divider(height: 1, color: AppColors.border),
            SizedBox(height: 8.h),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BlocBuilder<PostLikeCubit, PostLikeState>(
                  builder: (context, state) {
                    return TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 1.0, end: state.isLiked ? 1.2 : 1.0),
                      duration: const Duration(milliseconds: 150),
                      curve: Curves.elasticOut,
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: PostActionButton(
                            icon: state.isLiked ? Icons.volunteer_activism : Icons.volunteer_activism_outlined,
                            color: state.isLiked ? Colors.blue : null,
                            label: S.of(context)!.love,
                            onTap: () {
                              context.read<PostLikeCubit>().toggleLike();
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
                PostActionButton(
                  icon: Icons.chat_bubble_outline,
                  label: S.of(context)!.comment,
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => BlocProvider(
                        create: (context) => PostCommentsCubit(repository: context.read<CommunityRepository>()),
                        child: FractionallySizedBox(
                          heightFactor: 0.8,
                          child: CommentsSheet(postId: widget.post.id),
                        ),
                      ),
                    );
                  },
                ),
                PostActionButton(
                  icon: Icons.share_outlined,
                  label: S.of(context)!.share,
                  onTap: () {
                    CommunityCubit? communityCubit;
                    UserPostsCubit? userPostsCubit;
                    try {
                      communityCubit = context.read<CommunityCubit>();
                    } catch (_) {}
                    try {
                      userPostsCubit = context.read<UserPostsCubit>();
                    } catch (_) {}
                    
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (sheetContext) {
                        Widget sheet = SharePostSheet(post: widget.post);
                        if (userPostsCubit != null) {
                          sheet = BlocProvider.value(value: userPostsCubit, child: sheet);
                        }
                        if (communityCubit != null) {
                          sheet = BlocProvider.value(value: communityCubit, child: sheet);
                        }
                        return sheet;
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentText() {
    final text = widget.post.content;
    final isLong = text.length > 100;
    
    if (!isLong) {
      return Text(
        text,
        style: AppStyles.bodyMediumSecondary,
      );
    }

    final displayText = _isExpanded ? text : '...';
    
    return InkWell(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: RichText(
        text: TextSpan(
          text: displayText,
          style: AppStyles.bodyMediumSecondary,
          children: [
            TextSpan(
              text: _isExpanded ? ' ' : ' ',
              style: AppStyles.bodyMediumPrimary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSharedPost(PostModel sharedPost) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.shimmer,
                child: ClipOval(
                  child: sharedPost.user.image != null
                      ? Image.network(
                          sharedPost.user.image!,
                          width: 32,
                          height: 32,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.person, color: Colors.grey, size: 20),
                        )
                      : const Icon(Icons.person, color: Colors.grey, size: 20),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sharedPost.user.name,
                      style: AppStyles.bodyMediumBoldPrimaryDark,
                    ),
                    Text(
                      DateFormatter.timeAgo(sharedPost.createdAt),
                      style: AppStyles.bodySmall.copyWith(
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (sharedPost.content.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Text(
              sharedPost.content,
              style: AppStyles.bodyMediumSecondary,
            ),
          ],
          if (sharedPost.images.isNotEmpty) ...[
            SizedBox(height: 8.h),
            PostImageGrid(images: sharedPost.images),
          ],
        ],
      ),
    );
  }
}
