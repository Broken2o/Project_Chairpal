import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';

class PostStatsRow extends StatelessWidget {
  final int likesCount;
  final int sharesCount;
  final VoidCallback? onLikesTap;

  const PostStatsRow({
    super.key,
    required this.likesCount,
    required this.sharesCount,
    this.onLikesTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: onLikesTap,
          child: Row(
            children: [
              Text(
                '',
                style: AppStyles.bodySmall,
              ),
              SizedBox(width: 4.w),
              const Icon(Icons.volunteer_activism_outlined, size: 14, color: AppColors.textSecondary),
            ],
          ),
        ),
        Text(
          ' ',
          style: AppStyles.bodySmall,
        ),
      ],
    );
  }
}
