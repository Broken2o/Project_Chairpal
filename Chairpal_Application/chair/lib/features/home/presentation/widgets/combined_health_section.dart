import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../core/constants/assets.dart';
import '../../../../core/widgets/custom_error_state.dart';
import '../../../../l10n/l10n.dart';
import '../cubit/home_dashboard_cubit/home_dashboard_cubit.dart';
import '../cubit/home_dashboard_cubit/home_dashboard_state.dart';
import 'overview_chart_section.dart';
import 'live_health_monitoring_section.dart';

class CombinedHealthSection extends StatelessWidget {
  const CombinedHealthSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context)!;
    
    return BlocBuilder<HomeDashboardCubit, HomeDashboardState>(
      builder: (context, state) {
        bool isEmpty = false;
        
        if (state is HomeDashboardLoaded) {
          final vitals = state.dashboard.currentVitals;
          bool noVitals = vitals.heart == null && vitals.temperature == null && vitals.obstacle == null;
          
          bool noOverview = (state.dashboard.overviews['health_rate']?.isEmpty ?? true) &&
                            (state.dashboard.overviews['temperature']?.isEmpty ?? true) &&
                            (state.dashboard.overviews['movement']?.isEmpty ?? true);

          if (noVitals && noOverview) {
            isEmpty = true;
          }
        } else if (state is CompanionDashboardLoaded) {
          final vitals = state.dashboard.currentVitals;
          bool noVitals = vitals.heart == null && vitals.temperature == null && vitals.obstacle == null;
          
          bool noOverview = (state.dashboard.overviews['health_rate']?.isEmpty ?? true) &&
                            (state.dashboard.overviews['temperature']?.isEmpty ?? true) &&
                            (state.dashboard.overviews['movement']?.isEmpty ?? true);

          if (noVitals && noOverview) {
            isEmpty = true;
          }
        } else if (state is HomeDashboardError) {
          isEmpty = true;
        }

        if (isEmpty) {
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
              _buildEmptyState(context, l10n),
            ],
          );
        }

        return Column(
          children: [
            const OverviewChartSection(),
            SizedBox(height: 32.h),
            const LiveHealthMonitoringSection(),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, S l10n) {
    return CustomErrorState(
      title: l10n.sensorsDisconnected,
      message: l10n.sensorsDisconnectedDesc,
      imagePath: Assets.imagesSensorsError,
    );
  }
}
