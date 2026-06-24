import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../l10n/l10n.dart';
import '../../data/models/admin_dashboard_model.dart';

class AdminDashboardContent extends StatelessWidget {
  final AdminDashboardModel dashboard;

  const AdminDashboardContent({super.key, required this.dashboard});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildOverviewCards(l10n),
        SizedBox(height: 32.h),
        Text(
          l10n.recentActivity,
          style: AppStyles.h3.copyWith(
            color: AppColors.primaryDark,
            fontSize: 20.sp,
          ),
        ),
        SizedBox(height: 16.h),
        _buildActivityLogs(l10n),
      ],
    );
  }

  Widget _buildOverviewCards(S l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _buildOverviewCard(
            l10n.totalPlaces,
            dashboard.organizations.length.toString(),
            Icons.location_city_outlined, 
            Colors.teal,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: _buildOverviewCard(
            l10n.categories,
            '8', // Hardcoded or fetch from somewhere
            Icons.category_outlined, 
            Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewCard(String title, String count, IconData iconData, Color iconColor) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(iconData, color: iconColor, size: 24.w),
          ),
          SizedBox(height: 16.h),
          Text(
            count,
            style: AppStyles.h2.copyWith(color: AppColors.primaryDark),
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            style: AppStyles.bodySmall.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityLogs(S l10n) {
    if (dashboard.recentActivityLogs.isEmpty) {
      return Center(
        child: Text(l10n.noRecentActivity, style: AppStyles.bodyMedium),
      );
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: dashboard.recentActivityLogs.length,
      separatorBuilder: (context, index) => SizedBox(height: 16.h),
      itemBuilder: (context, index) {
        final log = dashboard.recentActivityLogs[index];
        return Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.notifications_outlined, color: AppColors.primary),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    log.message,
                    style: AppStyles.bodyMedium.copyWith(color: AppColors.primaryDark),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    log.createdAt,
                    style: AppStyles.bodySmall.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
