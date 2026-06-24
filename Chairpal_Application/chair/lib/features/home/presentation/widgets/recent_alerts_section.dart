import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../l10n/l10n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/home_dashboard_cubit/home_dashboard_cubit.dart';
import '../cubit/home_dashboard_cubit/home_dashboard_state.dart';
import '../../../../core/widgets/custom_empty_state.dart';
import '../../../../core/constants/assets.dart';

class RecentAlertsSection extends StatelessWidget {
  const RecentAlertsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.recentAlerts,
              style: AppStyles.h3.copyWith(
                color: AppColors.primaryDark,
                fontSize: 20.sp,
              ),
            ),
            Text(
              l10n.viewAll,
              style: AppStyles.bodySmall.copyWith(
                color: Colors.grey.shade400,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: Colors.grey.shade100),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: BlocBuilder<HomeDashboardCubit, HomeDashboardState>(
            builder: (context, state) {
              bool isEmpty = true;
              List<Widget> alertWidgets = [];

              if (state is HomeDashboardLoaded || state is CompanionDashboardLoaded) {
                final alerts = state is HomeDashboardLoaded 
                    ? state.dashboard.recentAlerts 
                    : (state as CompanionDashboardLoaded).dashboard.recentAlerts;
                
                if (alerts.isNotEmpty) {
                  isEmpty = false;
                  for (int i = 0; i < alerts.length; i++) {
                    final alert = alerts[i];
                    
                    // Simple logic for colors and icons based on severity or icon name
                    IconData iconData = Icons.notifications;
                    Color iconColor = Colors.blueAccent;
                    Color badgeColor = const Color(0xFFE3F2FD);
                    Color badgeTextColor = Colors.blue.shade700;

                    if (alert.severity.toLowerCase() == 'high' || alert.severity.toLowerCase() == 'critical') {
                      iconColor = Colors.redAccent;
                      badgeColor = const Color(0xFFFFEBEE);
                      badgeTextColor = Colors.red.shade700;
                    } else if (alert.severity.toLowerCase() == 'medium') {
                      iconColor = Colors.orangeAccent;
                      badgeColor = const Color(0xFFFFF3E0);
                      badgeTextColor = Colors.orange.shade700;
                    } else if (alert.severity.toLowerCase() == 'low') {
                      iconColor = Colors.green;
                      badgeColor = const Color(0xFFE8F5E9);
                      badgeTextColor = Colors.green.shade600;
                    }

                    if (alert.icon == 'favorite') iconData = Icons.favorite;
                    if (alert.icon == 'directions_run') iconData = Icons.directions_run;
                    if (alert.icon == 'sos') iconData = Icons.sos;

                    alertWidgets.add(
                      _buildAlertItem(
                        title: alert.title,
                        time: alert.time,
                        icon: iconData,
                        iconColor: iconColor,
                        badgeText: alert.severity,
                        badgeColor: badgeColor,
                        badgeTextColor: badgeTextColor,
                      ),
                    );

                    if (i < alerts.length - 1) {
                      alertWidgets.add(Divider(color: Colors.grey.shade100, height: 24.h));
                    }
                  }
                }
              }

              if (isEmpty) {
                return CustomEmptyState(
                  title: l10n.noRecentAlerts,
                  subtitle: l10n.systemAlertsNotificationsWillAppearHere,
                  imagePath: Assets.imagesNoAlerts,
                );
              }

              return Column(
                children: alertWidgets,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAlertItem({
    required String title,
    required String time,
    required IconData icon,
    required Color iconColor,
    required String badgeText,
    required Color badgeColor,
    required Color badgeTextColor,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 20.w),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppStyles.bodyMedium.copyWith(
                  color: AppColors.primaryDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                time,
                style: AppStyles.bodySmall.copyWith(
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: badgeColor,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            badgeText,
            style: TextStyle(
              color: badgeTextColor,
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
