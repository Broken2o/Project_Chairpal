import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/assets.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../l10n/l10n.dart';

class AdminOverviewCard extends StatelessWidget {
  /// Total number of places.
  final int totalPlaces;

  /// Total number of categories.
  final int totalCategories;

  const AdminOverviewCard({
    super.key,
    required this.totalPlaces,
    required this.totalCategories,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(24.r),
          decoration: BoxDecoration(
            color: const Color(0xFF14928A), // Teal color from design
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Stats section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context)!.adminOverview,
                      style: AppStyles.bodyMedium.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '$totalPlaces',
                      style: AppStyles.h1.copyWith(
                        color: Colors.white,
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      S.of(context)!.adminTotalPlaces,
                      style: AppStyles.bodyMedium.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          S.of(context)!.adminTotalCategories(totalCategories),
                          style: AppStyles.bodyMedium.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 120.w), // Space for illustration
            ],
          ),
        ),
        
        // Background Circle for illustration
        Positioned(
          right: 0.w,
          top: 0.h,
          bottom: 0.h,
          child: Container(
            width: 150,
            decoration: const BoxDecoration(
              color: Color(0xFF1FB1A8), // Lighter teal circle
              shape: BoxShape.circle,
            ),
          ),
        ),

        // Overflowing Illustration
        Positioned(
          right: -10,
          top: -30, // Pop out of the top
          child: Image.asset(
            Assets.imagesImg,
            height: 150,
            errorBuilder: (context, error, stackTrace) => SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}
