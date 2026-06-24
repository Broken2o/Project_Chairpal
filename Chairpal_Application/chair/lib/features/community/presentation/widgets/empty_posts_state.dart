import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/l10n.dart';
import '../../../../core/theme/app_styles.dart';

class EmptyPostsState extends StatelessWidget {
  const EmptyPostsState({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          Assets.imagesImg, // Note: This represents no_posts.png based on assets.dart
          height: 250,
          fit: BoxFit.contain,
        ),
        SizedBox(height: 24.h),
        Text(
          S.of(context)!.noPostsYetTitle,
          style: AppStyles.h3.copyWith(color: AppColors.primaryDark),
        ),
        SizedBox(height: 8.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: Text(
            S.of(context)!.noPostsYetDesc,
            style: AppStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
