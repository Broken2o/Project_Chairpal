import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../data/models/review_model.dart';

class ReviewItem extends StatelessWidget {
  final ReviewModel review;

  const ReviewItem({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(review.user?.image ?? 'https://via.placeholder.com/150'),
                onBackgroundImageError: (exception, stackTrace) =>
                    const Icon(Icons.person),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review.user?.name ?? 'Unknown',
                    style: AppStyles.h4,
                  ),
                  Row(
                    children: [
                      ...List.generate(5, (index) {
                        return Icon(
                          Icons.star,
                          size: 14,
                          color: index < review.rating
                              ? AppColors.primary
                              : Colors.grey[300],
                        );
                      }),
                      SizedBox(width: 8.w),
                      Text(
                        '${review.createdAt != null ? DateTime.now().difference(DateTime.tryParse(review.createdAt!) ?? DateTime.now()).inDays : 0} days ago',
                        style: AppStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            review.comment,
            style: AppStyles.bodySmall.copyWith(
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
