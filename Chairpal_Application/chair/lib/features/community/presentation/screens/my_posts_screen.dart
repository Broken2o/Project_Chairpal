import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/l10n.dart';
import '../../../../core/theme/app_styles.dart';
import '../widgets/create_post_input.dart';
import '../widgets/empty_posts_state.dart';
import 'package:chair_pal/core/widgets/custom_back_button.dart';
import '../../../chat/presentation/screens/chats_list_screen.dart';

class MyPostsScreen extends StatelessWidget {
  const MyPostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackground,
        elevation: 0,
        centerTitle: true,
        leading: const CustomBackButton(),
        leadingWidth: 100,
        title: Text(
          S.of(context)!.myPosts,
          style: AppStyles.h3.copyWith(color: AppColors.primaryDark),
        ),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.forum_outlined, color: AppColors.primaryDark, size: 28),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChatsListScreen(),
                    ),
                  );
                },
              ),
              Positioned(
                right: 8.w,
                top: 12.h,
                child: Container(
                  padding: EdgeInsets.all(4.r),
                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                  child: const Text('1', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.0.r),
        child: Column(
          children: [
            CreatePostInput(),
            SizedBox(height: 64.h),
            EmptyPostsState(),
          ],
        ),
      ),
    );
  }
}
