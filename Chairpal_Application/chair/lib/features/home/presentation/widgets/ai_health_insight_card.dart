import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../core/constants/assets.dart';
import '../../../../l10n/l10n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/home_dashboard_cubit/home_dashboard_cubit.dart';
import '../cubit/home_dashboard_cubit/home_dashboard_state.dart';

class AiHealthInsightCard extends StatelessWidget {
  const AiHealthInsightCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context)!;
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon placeholder
          Container(
            width: 70.w,
            height: 70.w,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Image.asset(
                Assets.aiHealth, 
                width: 65.w,
                height: 65.w,
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.aiHealthInsight,
                  style: AppStyles.bodyLarge.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8.h),
              BlocBuilder<HomeDashboardCubit, HomeDashboardState>(
                builder: (context, state) {
                  String insightText = l10n.noAiInsights;
                  Color statusColor = AppColors.primaryDark;

                  if (state is HomeDashboardLoaded || state is CompanionDashboardLoaded) {
                    final dashboard = state is HomeDashboardLoaded ? state.dashboard : (state as CompanionDashboardLoaded).dashboard;
                    if (dashboard.aiRecommendation == null) {
                      return Text('No AI Insights available at the moment.', style: AppStyles.bodySmall);
                    }
                    final aiRec = dashboard.aiRecommendation!;
                    if (aiRec.recommendation.isNotEmpty && aiRec.recommendation != 'None') {
                      insightText = aiRec.recommendation;
                      
                      if (aiRec.riskLevel.toLowerCase() == 'critical' || aiRec.riskLevel.toLowerCase() == 'high') {
                        statusColor = Colors.red.shade700;
                      } else if (aiRec.riskLevel.toLowerCase() == 'medium') {
                        statusColor = Colors.orange.shade700;
                      }
                    }
                  }

                  return Text.rich(
                    TextSpan(
                      text: insightText,
                    ),
                    style: AppStyles.bodyMedium.copyWith(
                      color: insightText == l10n.noAiInsights 
                          ? AppColors.textSecondary 
                          : statusColor,
                      height: 1.5,
                      fontWeight: insightText == l10n.noAiInsights
                          ? FontWeight.normal
                          : FontWeight.w600,
                    ),
                  );
                },
              ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
