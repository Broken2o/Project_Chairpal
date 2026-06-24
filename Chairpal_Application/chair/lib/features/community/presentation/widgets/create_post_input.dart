import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/l10n.dart';
import '../../../../core/theme/app_styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/community_repository.dart';
import '../cubit/create_post_cubit.dart';
import '../cubit/community_cubit.dart';
import '../screens/create_post_screen.dart';
import '../../../auth/presentation/cubit/user_cubit/user_cubit.dart';
import '../../../auth/presentation/cubit/user_cubit/user_state.dart';
import '../../data/models/post_model.dart';
import '../screens/user_posts_screen.dart';

class CreatePostInput extends StatelessWidget {
  const CreatePostInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            final String? imageUrl = state is UserLoaded ? state.user.image : null;
            
            return GestureDetector(
              onTap: () {
                if (state is UserLoaded) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserPostsScreen(
                        user: PostUser(
                          id: state.user.id,
                          name: state.user.name,
                          image: state.user.image,
                        ),
                      ),
                    ),
                  );
                }
              },
              child: CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.shimmer,
                child: ClipOval(
                  child: imageUrl != null 
                      ? Image.network(
                          imageUrl,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => 
                              const Icon(Icons.person, color: Colors.grey),
                        )
                      : Image.asset(
                          Assets.imagesUser,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            );
          },
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: GestureDetector(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => CreatePostCubit(repository: context.read<CommunityRepository>()),
                    child: const CreatePostScreen(),
                  ),
                ),
              );
              if (result == true && context.mounted) {
                try {
                  context.read<CommunityCubit>().fetchPosts();
                } catch (_) {}
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      S.of(context)!.addNewPostPrompt,
                      style: AppStyles.bodyMediumHint,
                    ),
                  ),
                  const Icon(
                    Icons.image_outlined,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
