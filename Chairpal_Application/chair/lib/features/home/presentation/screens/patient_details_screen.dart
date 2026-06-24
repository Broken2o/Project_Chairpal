import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../cubit/patient_details_cubit/patient_details_cubit.dart';
import '../cubit/patient_details_cubit/patient_details_state.dart';
import '../../../../core/constants/assets.dart';
import '../../../../l10n/l10n.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PatientDetailsScreen extends StatelessWidget {
  final int patientId;
  final String patientName;
  final int wheelchairId;

  const PatientDetailsScreen({
    super.key,
    required this.patientId,
    required this.patientName,
    required this.wheelchairId,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context)!;
    return BlocProvider(
      create: (context) => sl<PatientDetailsCubit>()..loadPatientData(wheelchairId),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FB),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leadingWidth: 80.w,
          leading: TextButton(
            onPressed: () => Navigator.pop(context),
            child: Row(
              children: [
                Icon(Icons.chevron_left, color: Colors.grey, size: 24.sp),
                Text(l10n.back, style: AppStyles.bodyMedium.copyWith(color: Colors.grey)),
              ],
            ),
          ),
          centerTitle: true,
          title: Text(patientName, style: AppStyles.h3.copyWith(color: const Color(0xFF1A2B3C))),
          actions: [
            IconButton(
              icon: Image.asset(Assets.imagesDelete, width: 24.sp, height: 24.sp),
              onPressed: () {},
            ),
            IconButton(
              icon: Image.asset(Assets.imagesUser, width: 28.sp, height: 28.sp),
              onPressed: () {},
            ),
            SizedBox(width: 8.w),
          ],
        ),
        body: BlocBuilder<PatientDetailsCubit, PatientDetailsState>(
          builder: (context, state) {
            if (state is PatientDetailsLoading) {
              return const Center(child: CircularProgressIndicator(color: AppColors.primary));
            } else if (state is PatientDetailsError) {
              return _buildErrorState(state.message, l10n);
            } else if (state is PatientDetailsLoaded) {
              return SingleChildScrollView(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.overview, style: AppStyles.h3.copyWith(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                    SizedBox(height: 16.h),
                    _buildLiveHealthMonitoring(state, l10n),
                    SizedBox(height: 24.h),
                    _buildAiHealthInsight(state, l10n),
                    SizedBox(height: 32.h),
                    _buildRecentAlerts(state, l10n),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildErrorState(String message, S l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(Assets.imagesSensorsError, width: 120.w, height: 120.w),
          SizedBox(height: 16.h),
          Text(l10n.sensorsDisconnected, style: AppStyles.h3),
          SizedBox(height: 8.h),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppStyles.bodySmall.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveHealthMonitoring(PatientDetailsLoaded state, S l10n) {
    return Container(
      padding: EdgeInsets.all(16.w),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildChartTab(l10n.heartRate, Icons.favorite, Colors.red, true),
              _buildChartTab(l10n.temperature, Icons.thermostat, Colors.blue, false),
              _buildChartTab(l10n.movement, Icons.directions_run, Colors.purple, false),
            ],
          ),
          SizedBox(height: 24.h),
          SizedBox(
            height: 150.h,
            child: _buildChart(state.sensorReadings, l10n),
          ),
          SizedBox(height: 24.h),
          Row(
            children: [
              Expanded(
                child: _buildStatInfoBox(
                  l10n.heartRate,
                  '${state.healthState.heartRate} ${l10n.bpm}',
                  state.healthState.heartRateStatus,
                  Colors.red,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildStatInfoBox(
                  l10n.temperature,
                  '${state.healthState.temperature} ${l10n.celsius}',
                  state.healthState.temperatureStatus,
                  Colors.blue,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildStatInfoBox(
                  l10n.movement,
                  l10n.normal,
                  'normal',
                  Colors.purple,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartTab(String title, IconData icon, Color color, bool isSelected) {
    return Row(
      children: [
        Icon(icon, color: isSelected ? color : Colors.grey, size: 16.sp),
        SizedBox(width: 4.w),
        Text(
          title,
          style: AppStyles.bodySmall.copyWith(
            color: isSelected ? color : Colors.grey,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildStatInfoBox(String title, String value, String status, Color color) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.circle, color: color, size: 8.sp),
              SizedBox(width: 4.w),
              Text(title, style: AppStyles.badge.copyWith(color: Colors.grey)),
            ],
          ),
          SizedBox(height: 8.h),
          Text(value, style: AppStyles.h3Bold.copyWith(fontSize: 16.sp, color: const Color(0xFF1A2B3C))),
          SizedBox(height: 4.h),
          Text(
            status,
            style: AppStyles.badge.copyWith(color: status.toLowerCase() == 'normal' ? Colors.green : Colors.orange),
          ),
        ],
      ),
    );
  }

  Widget _buildChart(List<dynamic> readings, S l10n) {
    if (readings.isEmpty) return Center(child: Text(l10n.noData));
    
    // Creating some mock points if readings only has 1 point, so the line chart shows a line
    List<FlSpot> spots = [];
    if (readings.length == 1) {
      spots = [
        FlSpot(0, 65),
        FlSpot(1, 70),
        FlSpot(2, 75),
        FlSpot(3, readings.first.heartRateAvg.toDouble()),
      ];
    } else {
      for (int i = 0; i < readings.length; i++) {
        spots.add(FlSpot(i.toDouble(), readings[i].heartRateAvg.toDouble()));
      }
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              getTitlesWidget: (value, meta) {
                return Text('0${value.toInt()}:00', style: AppStyles.badge.copyWith(color: Colors.grey));
              },
            ),
          ),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.red,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.red.withValues(alpha: 0.1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAiHealthInsight(PatientDetailsLoaded state, S l10n) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFEBF8F1),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Image.asset(Assets.aiHealth, width: 48.sp, height: 48.sp),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.aiHealthInsight, style: AppStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF169C89))),
                SizedBox(height: 4.h),
                Text(
                  '${l10n.healthStatusIs}${state.healthState.riskLevel}. ${state.healthState.reason}. ${state.healthState.recommendation}',
                  style: AppStyles.bodySmall.copyWith(color: const Color(0xFF169C89)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentAlerts(PatientDetailsLoaded state, S l10n) {
    // In a real app, this would be fetched from an endpoint or passed down
    // Since the API only gave us health state and sensor readings, we mock 1 alert or show empty.
    bool hasAlerts = state.healthState.riskLevel != 'normal';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l10n.recentAlerts, style: AppStyles.h3.copyWith(fontSize: 18.sp, fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () {},
              child: Text(l10n.viewAll, style: AppStyles.bodySmall.copyWith(color: Colors.grey)),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        if (!hasAlerts)
          Center(
            child: Column(
              children: [
                SizedBox(height: 16.h),
                Image.asset(Assets.imagesNoAlerts, width: 120.w, height: 120.w),
                SizedBox(height: 16.h),
                Text(l10n.noRecentAlerts, style: AppStyles.bodyMedium.copyWith(color: Colors.grey)),
              ],
            ),
          )
        else
          Container(
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
                    color: Colors.red.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(Assets.svgWarning, width: 20.sp, height: 20.sp),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.healthState.reason.isNotEmpty ? state.healthState.reason : l10n.highHeartRate,
                        style: AppStyles.bodyMedium.copyWith(color: const Color(0xFF1A2B3C), fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4.h),
                      Text('Today, Just now', style: AppStyles.bodySmall.copyWith(color: Colors.grey)),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    state.healthState.riskLevel,
                    style: AppStyles.badge.copyWith(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
