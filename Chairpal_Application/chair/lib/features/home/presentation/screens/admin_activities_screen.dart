import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../core/widgets/custom_back_button.dart';
import '../../../../core/widgets/custom_empty_state.dart';
import '../../../../l10n/l10n.dart';
import '../../data/models/admin_dashboard_model.dart';
import '../../../../core/constants/assets.dart';

class AdminActivitiesScreen extends StatelessWidget {
  final List<ActivityLogModel> activities;

  const AdminActivitiesScreen({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leadingWidth: 100,
        leading: const CustomBackButton(),
        title: Text(
          l10n.recentActivity,
          style: AppStyles.h3.copyWith(color: AppColors.primaryDark),
        ),
      ),
      body: activities.isEmpty
          ? CustomEmptyState(
              title: l10n.noRecentActivity,
              subtitle: '',
              icon: Icons.history,
              imagePath: Assets.adminChar,
            )
          : ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              itemCount: activities.length,
              separatorBuilder: (context, index) => SizedBox(height: 16.h),
              itemBuilder: (context, index) {
                final log = activities[index];
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check, color: AppColors.primary),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            log.message,
                            style: AppStyles.bodyMedium.copyWith(
                              color: AppColors.primaryDark,
                              fontWeight: FontWeight.w600,
                            ),
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
            ),
    );
  }
}
