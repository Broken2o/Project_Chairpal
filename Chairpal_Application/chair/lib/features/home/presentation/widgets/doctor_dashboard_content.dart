import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../core/constants/assets.dart';
import '../../data/models/doctor_dashboard_model.dart';
import '../../../../l10n/l10n.dart';
import '../screens/patient_details_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DoctorDashboardContent extends StatelessWidget {
  final DoctorDashboardModel dashboard;

  const DoctorDashboardContent({super.key, required this.dashboard});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(l10n.overview, null, l10n),
        SizedBox(height: 16.h),
        _buildStatistics(l10n),
        SizedBox(height: 32.h),
        _buildSectionHeader(l10n.patients, () {}, l10n),
        SizedBox(height: 16.h),
        _buildPatientsList(l10n, context),
        SizedBox(height: 32.h),
        _buildSectionHeader(l10n.recentAlerts, () {}, l10n),
        SizedBox(height: 16.h),
        _buildRecentAlerts(l10n),
      ],
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback? onViewAll, S l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppStyles.h3.copyWith(
            color: const Color(0xFF1A2B3C),
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (onViewAll != null)
          TextButton(
            onPressed: onViewAll,
            child: Text(
              l10n.viewAll,
              style: AppStyles.bodySmall.copyWith(
                color: Colors.grey,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildStatistics(S l10n) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildStatItem(l10n.totalPatients, dashboard.statistics.total, Assets.svgTotalPatients)),
            SizedBox(width: 16.w),
            Expanded(child: _buildStatItem(l10n.normal, dashboard.statistics.normal, Assets.svgNormal)),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(child: _buildStatItem(l10n.warningLabel, dashboard.statistics.medium, Assets.svgWarning)),
            SizedBox(width: 16.w),
            Expanded(child: _buildStatItem(l10n.critical, dashboard.statistics.critical, Assets.svgCritical)),
          ],
        ),
      ],
    );
  }

  Widget _buildStatItem(String title, int count, String svgPath) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 8.w),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            svgPath,
            width: 48.sp,
            height: 48.sp,
          ),
          SizedBox(height: 12.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppStyles.bodyMedium.copyWith(
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 8.h),
          Text(
            count.toString(),
            style: AppStyles.h3Bold.copyWith(
              color: const Color(0xFF1A2B3C),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientsList(S l10n, BuildContext context) {
    if (dashboard.patients.isEmpty) {
      return Center(
        child: Column(
          children: [
            Image.asset(Assets.imagesNoPatients, height: 120.w),
            Text(l10n.noPatientsAssigned, style: AppStyles.h3),
            SizedBox(height: 8.h),
            Text(
              l10n.youDontHaveAnyConnectedPatients,
              textAlign: TextAlign.center,
              style: AppStyles.bodySmall.copyWith(color: Colors.grey),
            ),
          ],
        ),
      );
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: dashboard.patients.length,
      separatorBuilder: (context, index) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final patient = dashboard.patients[index];
        return Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundColor: const Color(0xFFF2FAF8),
                backgroundImage: const AssetImage(Assets.imagesUser),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patient.name,
                      style: AppStyles.bodyMedium.copyWith(color: const Color(0xFF1A2B3C), fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '\${l10n.lastUpdate}${patient.lastUpdate ?? 'N/A'}',
                      style: AppStyles.bodySmall.copyWith(color: Colors.grey, fontSize: 11.sp),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PatientDetailsScreen(
                        patientId: patient.id,
                        patientName: patient.name,
                        wheelchairId: patient.wheelchairId ?? 9, // fallback to 9 for testing based on provided API
                      ),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFFF2FAF8),
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
                ),
                child: Text(
                  'View',
                  style: AppStyles.bodySmallBold.copyWith(color: const Color(0xFF169C89)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRecentAlerts(S l10n) {
    if (dashboard.alerts.isEmpty) {
      return Center(
        child: Column(
          children: [
            SizedBox(height: 16.h),
            Image.asset(Assets.imagesNoAlerts, width: 120.w, height: 120.w),
            SizedBox(height: 16.h),
            Text(l10n.noRecentAlerts, style: AppStyles.h3),
            SizedBox(height: 8.h),
            Text(
              l10n.systemAlertsNotificationsWillAppearHere,
              textAlign: TextAlign.center,
              style: AppStyles.bodySmall.copyWith(color: Colors.grey),
            ),
          ],
        ),
      );
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: dashboard.alerts.length,
      separatorBuilder: (context, index) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final alert = dashboard.alerts[index];
        final isHigh = alert.severity.toLowerCase() == 'high';
        final iconColor = isHigh ? Colors.red : Colors.orange;
        return Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  Assets.svgWarning,
                  width: 20.sp,
                  height: 20.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${alert.patientName} - ${alert.issue}',
                      style: AppStyles.bodyMedium.copyWith(color: const Color(0xFF1A2B3C), fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      alert.time,
                      style: AppStyles.bodySmall.copyWith(color: Colors.grey, fontSize: 11.sp),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: iconColor),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  alert.severity,
                  style: AppStyles.badge.copyWith(color: iconColor),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
