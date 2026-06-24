import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';

class HealthOverviewSection extends StatefulWidget {
  const HealthOverviewSection({super.key});

  @override
  State<HealthOverviewSection> createState() => _HealthOverviewSectionState();
}

class _HealthOverviewSectionState extends State<HealthOverviewSection> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Overview'),
        SizedBox(height: 16.h),
        _buildOverviewCard(),
        SizedBox(height: 32.h),
        _buildMetricCards(),
        SizedBox(height: 24.h),
        _buildAIInsightCard(),
        SizedBox(height: 32.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionHeader('Recent Alerts'),
            Text(
              'View all',
              style: AppStyles.bodySmall.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        _buildAlertsList(),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppStyles.h3.copyWith(
        color: const Color(0xFF2D5050),
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildOverviewCard() {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetricTab(0, Icons.favorite, 'Heart Rate', const Color(0xFFFF5959)),
              _buildMetricTab(1, Icons.thermostat, 'Temperature', const Color(0xFF32A8FF)),
              _buildMetricTab(2, Icons.directions_run, 'Movement', const Color(0xFFA259FF)),
            ],
          ),
          SizedBox(height: 24.h),
          SizedBox(
            height: 200,
            child: Stack(
              children: [
                LineChart(_getMainChartData()),
                Positioned(
                  left: 60.w,
                  top: 20.h,
                  child: _buildTooltip(),
                ),
                Positioned(
                  right: 0.w,
                  top: 0.h,
                  child: _buildTimeDropdown(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTab(int index, IconData icon, String label, Color color) {
    final isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => selectedIndex = index),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.05) : Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? color.withValues(alpha: 0.2) : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: isSelected ? color : AppColors.textSecondary),
            SizedBox(width: 4.w),
            Text(
              label,
              style: AppStyles.bodySmall.copyWith(
                color: isSelected ? color : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTooltip() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('78 BPM', style: AppStyles.bodyMediumBold.copyWith(fontSize: 14)),
          Text('09:30 AM', style: AppStyles.bodySmall.copyWith(fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildTimeDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F7F7),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Today', style: AppStyles.bodySmall.copyWith(color: const Color(0xFF6B9C9C))),
          const Icon(Icons.keyboard_arrow_down, size: 16, color: Color(0xFF6B9C9C)),
        ],
      ),
    );
  }

  LineChartData _getMainChartData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 30,
        getDrawingHorizontalLine: (value) => FlLine(
          color: Colors.grey.withValues(alpha: 0.1),
          strokeWidth: 1,
        ),
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 4,
            getTitlesWidget: (value, meta) {
              String text = '';
              switch (value.toInt()) {
                case 0: text = '00:00'; break;
                case 4: text = '04:00'; break;
                case 8: text = '08:00'; break;
                case 12: text = '12:00'; break;
                case 16: text = '16:00'; break;
                case 20: text = '20:00'; break;
                case 24: text = '24:00'; break;
              }
              return SideTitleWidget(
                meta: meta,
                child: Text(text, style: AppStyles.bodySmall.copyWith(fontSize: 10)),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 30,
            getTitlesWidget: (value, meta) => Text(
              value.toInt().toString(),
              style: AppStyles.bodySmall.copyWith(fontSize: 10),
            ),
            reservedSize: 30,
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      minX: 0, maxX: 24, minY: 0, maxY: 150,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 70), FlSpot(2, 110), FlSpot(4, 125), FlSpot(6, 110),
            FlSpot(8, 90), FlSpot(10, 80), FlSpot(12, 120), FlSpot(14, 110),
            FlSpot(16, 115), FlSpot(18, 100), FlSpot(20, 80), FlSpot(22, 75), FlSpot(24, 70),
          ],
          isCurved: true,
          color: const Color(0xFFFF5959),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                const Color(0xFFFF5959).withValues(alpha: 0.3),
                const Color(0xFFFF5959).withValues(alpha: 0.0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCards() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildMetricCard(
            'Heart Rate', '78', 'BPM', 'Normal range: 60-100',
            const Color(0xFFFF5959), Icons.favorite,
            const [70, 80, 75, 85, 80, 90, 85],
          ),
          SizedBox(width: 16.w),
          _buildMetricCard(
            'Temperature', '36.7', '°C', 'Normal range: 36.1-37.2',
            const Color(0xFF32A8FF), Icons.thermostat,
            const [36.5, 36.6, 36.7, 36.5, 36.8, 36.7, 36.9],
          ),
          SizedBox(width: 16.w),
          _buildMetricCard(
            'Movement', 'Normal', '', 'No abnormal activity',
            const Color(0xFFA259FF), Icons.directions_run,
            const [10, 20, 15, 25, 10, 30, 20],
            isBar: true,
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
    String title, String value, String unit, String range,
    Color color, IconData icon, List<double> data, {bool isBar = false}
  ) {
    return Container(
      width: 160,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
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
                padding: EdgeInsets.all(6.r),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
                child: Icon(icon, size: 14, color: color),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  title,
                  style: AppStyles.bodySmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: AppStyles.h3Bold.copyWith(fontSize: 22)),
              if (unit.isNotEmpty) ...[
                SizedBox(width: 4.w),
                Text(unit, style: AppStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
              ],
            ],
          ),
          SizedBox(height: 12.h),
          SizedBox(height: 40, child: isBar ? _buildSparkBar(data, color) : _buildSparkLine(data, color)),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(color: const Color(0xFFF0FFF4), borderRadius: BorderRadius.circular(8.r)),
            child: Text(
              range,
              style: AppStyles.bodySmall.copyWith(color: const Color(0xFF38A169), fontSize: 9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIInsightCard() {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFFF5FAF9),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFFE0ECEA)),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              color: Color(0xFFD9EFED),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Image.network(
                'https://cdn-icons-png.flaticon.com/512/4712/4712035.png', // Robot/AI icon
                width: 30,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.smart_toy, color: AppColors.primary),
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Health Insight',
                  style: AppStyles.bodyMediumBold.copyWith(color: const Color(0xFF14908E)),
                ),
                SizedBox(height: 4.h),
                RichText(
                  text: TextSpan(
                    style: AppStyles.bodySmall.copyWith(color: const Color(0xFF4A6967)),
                    children: [
                      const TextSpan(text: 'Your health status is '),
                      TextSpan(
                        text: 'stable',
                        style: AppStyles.bodySmallBold.copyWith(color: const Color(0xFF14908E)),
                      ),
                      const TextSpan(text: '.\nAll vital sign are within normal ranges.'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertsList() {
    return Column(
      children: [
        _buildAlertItem(
          'High heart rate',
          'Today, 08:47 AM',
          'Medium',
          const Color(0xFFFFF4E5),
          const Color(0xFFED8936),
          Icons.favorite,
          const Color(0xFFFF5959),
        ),
        _buildAlertItem(
          'Fall Detected',
          'Yesterday, 06:15 PM',
          'High',
          const Color(0xFFFFF5F5),
          const Color(0xFFE53E3E),
          Icons.directions_run,
          const Color(0xFFA259FF),
        ),
        _buildAlertItem(
          'SOS button pressed',
          '2 days ago, 11:32 AM',
          'Low',
          const Color(0xFFF0FFF4),
          const Color(0xFF38A169),
          Icons.sos,
          const Color(0xFF718096),
        ),
      ],
    );
  }

  Widget _buildAlertItem(
    String title, String time, String priority,
    Color priorityBg, Color priorityText, IconData icon, Color iconBg
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFFF1F4F4)),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(color: iconBg.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: Icon(icon, size: 20, color: iconBg),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppStyles.bodyMediumBold.copyWith(color: const Color(0xFF2D5050))),
                  Text(time, style: AppStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              decoration: BoxDecoration(color: priorityBg, borderRadius: BorderRadius.circular(12.r)),
              child: Text(
                priority,
                style: AppStyles.bodySmallBold.copyWith(color: priorityText, fontSize: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSparkLine(List<double> data, Color color) {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
            isCurved: true,
            color: color,
            barWidth: 2,
            dotData: const FlDotData(show: false),
          ),
        ],
      ),
    );
  }

  Widget _buildSparkBar(List<double> data, Color color) {
    return BarChart(
      BarChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: data.asMap().entries.map((e) => BarChartGroupData(
          x: e.key,
          barRods: [BarChartRodData(toY: e.value, color: color.withValues(alpha: 0.5), width: 4, borderRadius: BorderRadius.circular(2.r))],
        )).toList(),
      ),
    );
  }
}
