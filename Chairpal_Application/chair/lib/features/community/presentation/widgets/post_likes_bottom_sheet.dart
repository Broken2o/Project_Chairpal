import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../domain/repositories/community_repository.dart';
import '../cubit/post_likes_list_cubit.dart';
import '../../domain/usecases/get_post_likes_usecase.dart';

class PostLikesBottomSheet extends StatelessWidget {
  final int postId;

  const PostLikesBottomSheet({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostLikesListCubit(
        getPostLikesUseCase: GetPostLikesUseCase(context.read<CommunityRepository>()),
        postId: postId,
      )..fetchLikes(),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          children: [
            SizedBox(height: 12.h),
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 12.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  Icon(Icons.volunteer_activism, color: Colors.blue, size: 24.sp),
                  SizedBox(width: 8.w),
                  Text(
                    'Likes',
                    style: AppStyles.h3.copyWith(fontWeight: FontWeight.bold, color: AppColors.primaryDark),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.grey[600]),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: BlocBuilder<PostLikesListCubit, PostLikesListState>(
                builder: (context, state) {
                  if (state is PostLikesListInitial || state is PostLikesListLoading) {
                    return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                  } else if (state is PostLikesListError) {
                    return Center(child: Text(state.message));
                  } else if (state is PostLikesListLoaded) {
                    if (state.likes.isEmpty) {
                      return const Center(child: Text('No likes yet.'));
                    }
                    return NotificationListener<ScrollNotification>(
                      onNotification: (scrollInfo) {
                        if (!state.hasReachedMax &&
                            scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 200) {
                          context.read<PostLikesListCubit>().fetchLikes();
                        }
                        return false;
                      },
                      child: ListView.separated(
                        itemCount: state.likes.length + (state.hasReachedMax ? 0 : 1),
                        separatorBuilder: (context, index) => SizedBox(height: 16.h),
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                        itemBuilder: (context, index) {
                          if (index >= state.likes.length) {
                            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                          }
                          final user = state.likes[index];
                          return Row(
                            children: [
                              CircleAvatar(
                                radius: 24.r,
                                backgroundImage: user.image != null ? NetworkImage(user.image!) : null,
                                backgroundColor: Colors.grey[200],
                                child: user.image == null ? Icon(Icons.person, color: Colors.grey[400]) : null,
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Text(
                                  user.name,
                                  style: AppStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600, color: AppColors.primaryDark),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
