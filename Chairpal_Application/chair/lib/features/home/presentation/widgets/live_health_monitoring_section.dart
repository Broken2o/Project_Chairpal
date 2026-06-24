import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../l10n/l10n.dart';
import '../cubit/home_dashboard_cubit/home_dashboard_cubit.dart';
import '../cubit/home_dashboard_cubit/home_dashboard_state.dart';

class LiveHealthMonitoringSection extends StatelessWidget {
  const LiveHealthMonitoringSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context)!;
    return BlocBuilder<HomeDashboardCubit, HomeDashboardState>(
      builder: (context, state) {
        String heartValue = '--';
        String tempValue = '--';
        String moveValue = '--';
        if (state is HomeDashboardLoaded || state is CompanionDashboardLoaded) {
          final vitals = state is HomeDashboardLoaded ? state.dashboard.currentVitals : (state as CompanionDashboardLoaded).dashboard.currentVitals;
          if (vitals.heart != null) heartValue = vitals.heart!.value.toString();
          if (vitals.temperature != null) tempValue = vitals.temperature!.value.toString();
          if (vitals.obstacle != null) moveValue = vitals.obstacle!.mpuAngle.toString();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.liveHealthMonitoring,
              style: AppStyles.h2.copyWith(color: AppColors.primaryDark),
            ),
            SizedBox(height: 16.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          child: Row(
            children: [
              _buildVitalCard(
                title: l10n.heartRate,
                icon: Icons.favorite,
                iconColor: Colors.redAccent,
                value: heartValue,
                unit: l10n.bpm,
                chartColor: Colors.redAccent,
                badgeText: l10n.normalRangeHeartRate,
                badgeColor: const Color(0xFFE8F5E9),
                badgeTextColor: Colors.green.shade600,
                spots: const [],
              ),
              SizedBox(width: 16.w),
              _buildVitalCard(
                title: l10n.temperature,
                icon: Icons.thermostat,
                iconColor: Colors.blueAccent,
                value: tempValue,
                unit: l10n.celsius,
                chartColor: Colors.blueAccent,
                badgeText: l10n.normalRangeTemperature,
                badgeColor: const Color(0xFFE8F5E9),
                badgeTextColor: Colors.orange.shade800,
                spots: const [],
              ),
              SizedBox(width: 16.w),
              _buildVitalCard(
                title: l10n.movement,
                icon: Icons.directions_run,
                iconColor: Colors.purpleAccent,
                value: moveValue,
                unit: l10n.steps,
                chartColor: Colors.purpleAccent,
                badgeText: l10n.normalActivity,
                badgeColor: const Color(0xFFFFF3E0),
                badgeTextColor: Colors.orange.shade700,
                spots: const [],
              ),
            ],
          ),
        ),
      ],
    );
      },
    );
  }

  Widget _buildVitalCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required String value,
    required String unit,
    required Color chartColor,
    required String badgeText,
    required Color badgeColor,
    required Color badgeTextColor,
    required List<FlSpot> spots,
    double? minY,
    double? maxY,
  }) {
    return Container(
      width: 160.w,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 16.w),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  title,
                  style: AppStyles.bodySmall.copyWith(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: AppStyles.h2.copyWith(
                  color: AppColors.primaryDark,
                  fontSize: 24.sp,
                ),
              ),
              if (unit.isNotEmpty) ...[
                SizedBox(width: 4.w),
                Text(
                  unit,
                  style: AppStyles.bodySmall.copyWith(
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 12.h),
          SizedBox(
            height: 40.h,
            child: spots.isEmpty 
              ? const SizedBox()
              : LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: false),
                    titlesData: const FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    minX: 0,
                    maxX: 7,
                    minY: minY,
                    maxY: maxY,
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        color: chartColor,
                        barWidth: 2,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                    lineTouchData: const LineTouchData(enabled: false),
                  ),
                ),
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Center(
              child: Text(
                badgeText,
                style: TextStyle(
                  color: badgeTextColor,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
