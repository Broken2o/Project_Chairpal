import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/post_comments_cubit.dart';
import '../../../../l10n/l10n.dart';
import '../../../../core/utils/date_formatter.dart';

class CommentsSheet extends StatefulWidget {
  final int postId;

  const CommentsSheet({super.key, required this.postId});

  @override
  State<CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<CommentsSheet> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<PostCommentsCubit>().fetchComments(widget.postId);
  }

  void _submitComment() {
    final content = _commentController.text.trim();
    if (content.isNotEmpty) {
      context.read<PostCommentsCubit>().addComment(widget.postId, content);
      _commentController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.scaffoldBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 12.h),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            S.of(context)!.comment,
            style: AppStyles.h3PrimaryDark,
          ),
          const Divider(height: 32),
          Expanded(
            child: BlocBuilder<PostCommentsCubit, PostCommentsState>(
              builder: (context, state) {
                if (state is PostCommentsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is PostCommentsError) {
                  return Center(child: Text(state.message));
                } else if (state is PostCommentsLoaded) {
                  if (state.comments.isEmpty) {
                    return Center(
                      child: Text(
                        S.of(context)!.noCommentsYet,
                        style: AppStyles.bodyMediumHint,
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: state.comments.length,
                    separatorBuilder: (context, index) => SizedBox(height: 16.h),
                    itemBuilder: (context, index) {
                      final comment = state.comments[index];
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: AppColors.shimmer,
                            child: ClipOval(
                              child: comment.user.image != null
                                  ? Image.network(
                                      comment.user.image!,
                                      width: 36,
                                      height: 36,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                          const Icon(Icons.person, size: 18, color: Colors.grey),
                                    )
                                  : const Icon(Icons.person, size: 18, color: Colors.grey),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(12.r),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(16.r),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        comment.user.name,
                                        style: AppStyles.bodyMediumBold,
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        comment.content,
                                        style: AppStyles.bodyMedium,
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 12.w, top: 4.h),
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () => context.read<PostCommentsCubit>().toggleLike(comment.id),
                                        child: Text(
                                          S.of(context)!.love,
                                            style: AppStyles.bodySmallBold,
                                        ),
                                      ),
                                      SizedBox(width: 16.w),
                                      Text(
                                        DateFormatter.timeAgo(comment.createdAt),
                                        style: AppStyles.bodySmallHint,
                                      ),
                                      if (comment.likesCount > 0) ...[
                                        const Spacer(),
                                        const Icon(Icons.thumb_up, size: 12, color: AppColors.primary),
                                        SizedBox(width: 4.w),
                                        Text(
                                          '${comment.likesCount}',
                                          style: AppStyles.bodySmall,
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }
                return SizedBox();
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    style: AppStyles.bodyMedium,
                    decoration: InputDecoration(
                      hintText: S.of(context)!.writeAComment,
                      hintStyle: AppStyles.bodyMediumHint,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24.r),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                IconButton(
                  onPressed: _submitComment,
                  icon: const Icon(Icons.send, color: AppColors.primary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}