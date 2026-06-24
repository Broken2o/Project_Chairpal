import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../l10n/l10n.dart';
import '../cubit/home_dashboard_cubit/home_dashboard_cubit.dart';
import '../cubit/home_dashboard_cubit/home_dashboard_state.dart';

class OverviewChartSection extends StatefulWidget {
  const OverviewChartSection({super.key});

  @override
  State<OverviewChartSection> createState() => _OverviewChartSectionState();
}

class _OverviewChartSectionState extends State<OverviewChartSection> {
  int _selectedTab = 0; // 0: Heart Rate, 1: Temperature, 2: Movement

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.overview,
          style: AppStyles.h3.copyWith(
            color: AppColors.primaryDark,
            fontSize: 20.sp,
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Tabs
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildTab(
                      index: 0,
                      label: l10n.heartRate,
                      icon: Icons.favorite,
                      color: Colors.redAccent,
                      isSelected: _selectedTab == 0,
                    ),
                    SizedBox(width: 8.w),
                    _buildTab(
                      index: 1,
                      label: l10n.temperature,
                      icon: Icons.thermostat,
                      color: Colors.blueAccent,
                      isSelected: _selectedTab == 1,
                    ),
                    SizedBox(width: 8.w),
                    _buildTab(
                      index: 2,
                      label: l10n.movement,
                      icon: Icons.directions_run,
                      color: Colors.purpleAccent,
                      isSelected: _selectedTab == 2,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              // Dropdown
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      children: [
                        Text(
                          l10n.today,
                          style: AppStyles.bodySmall.copyWith(
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Icon(Icons.keyboard_arrow_down, size: 16.w, color: AppColors.primaryDark),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              // Chart
              SizedBox(
                height: 180.h,
                child: BlocBuilder<HomeDashboardCubit, HomeDashboardState>(
                  builder: (context, state) {
                    List<FlSpot> spots = [];
                    List<String> xLabels = [];
                    double maxY = 150;
                    
                    if (state is HomeDashboardLoaded || state is CompanionDashboardLoaded) {
                      final overviews = state is HomeDashboardLoaded ? state.dashboard.overviews : (state as CompanionDashboardLoaded).dashboard.overviews;
                      
                      String key = 'health_rate'; // default for heart rate
                      // We don't have endpoints for temp/movement charts yet, so we'll just use health_rate as an example or use empty
                      
                      final points = overviews[key] ?? [];
                      double currentMaxY = 0;
                      for (int i = 0; i < points.length; i++) {
                        final y = points[i].yAxis.toDouble();
                        if (y > currentMaxY) currentMaxY = y;
                        spots.add(FlSpot(i.toDouble(), y));
                        xLabels.add(points[i].xAxis);
                      }
                      if (currentMaxY > 0) maxY = currentMaxY + (currentMaxY * 0.2); // Add 20% padding
                    }

                    if (spots.isEmpty) {
                      return Center(
                        child: Text(
                          l10n.noChartData,
                          style: AppStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                        ),
                      );
                    }

                    return _buildChart(spots, xLabels, maxY);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTab({
    required int index,
    required String label,
    required IconData icon,
    required Color color,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? color.withValues(alpha: 0.5) : Colors.grey.shade200,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? color : Colors.grey.shade400, size: 16.w),
            SizedBox(width: 6.w),
            Text(
              label,
              style: AppStyles.bodySmall.copyWith(
                color: isSelected ? color : Colors.grey.shade500,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChart(List<FlSpot> spots, List<String> xLabels, double maxY) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxY / 5 > 0 ? maxY / 5 : 30,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.shade200,
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              interval: (spots.length / 5).ceilToDouble() > 0 ? (spots.length / 5).ceilToDouble() : 3,
              getTitlesWidget: (value, meta) {
                const style = TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.w500);
                int index = value.toInt();
                if (index < 0 || index >= xLabels.length) return const SizedBox.shrink();
                
                return SideTitleWidget(
                  meta: meta,
                  child: Text(xLabels[index], style: style),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: maxY / 5 > 0 ? maxY / 5 : 30,
              reservedSize: 32,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.left,
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: spots.length.toDouble() - 1 < 0 ? 0 : spots.length.toDouble() - 1,
        minY: 0,
        maxY: maxY,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.redAccent,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              checkToShowDot: (spot, barData) {
                return spot.x == 4; // Show dot at 09:30 AM (approx index 4)
              },
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 5,
                  color: Colors.white,
                  strokeWidth: 3,
                  strokeColor: Colors.redAccent,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  Colors.redAccent.withValues(alpha: 0.3),
                  Colors.redAccent.withValues(alpha: 0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          enabled: false,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) => Colors.white,
            tooltipRoundedRadius: 12,
            tooltipBorder: const BorderSide(color: Colors.grey, width: 0.2),
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((LineBarSpot touchedSpot) {
                return LineTooltipItem(
                  '78 BPM\n',
                  const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.bold, fontSize: 12),
                  children: [
                    const TextSpan(
                      text: '09:30 AM',
                      style: TextStyle(color: Colors.grey, fontWeight: FontWeight.normal, fontSize: 10),
                    ),
                  ],
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }
}
