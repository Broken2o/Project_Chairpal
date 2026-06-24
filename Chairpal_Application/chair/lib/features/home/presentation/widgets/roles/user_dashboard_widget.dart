import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';

import '../../cubit/home_dashboard_cubit/home_dashboard_cubit.dart';
import '../../cubit/home_dashboard_cubit/home_dashboard_state.dart';
import '../home_teal_header.dart';
import '../home_search_bar.dart';
import '../category_list.dart';
import '../combined_health_section.dart';
import '../ai_health_insight_card.dart';
import '../recent_alerts_section.dart';
import '../last_visited_places_list.dart';
import '../popular_places_list.dart';

class UserDashboardWidget extends StatelessWidget {
  const UserDashboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              const HomeTealHeader(),
              Positioned(
                bottom: -24.h,
                left: 24.w,
                right: 24.w,
                child: const HomeSearchBar(),
              ),
            ],
          ),
          SizedBox(height: 48.h),
          Expanded(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CategoryList(),
                SizedBox(height: 32.h),
                const LastVisitedPlacesList(),
                SizedBox(height: 32.h),
                BlocBuilder<HomeDashboardCubit, HomeDashboardState>(
                  builder: (context, state) {
                    if (state is HomeDashboardLoading) {
                      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                    } else if (state is HomeDashboardLoaded || state is HomeDashboardError) {
                      return Column(
                        children: [
                          const CombinedHealthSection(),
                          SizedBox(height: 32.h),
                          const AiHealthInsightCard(),
                          SizedBox(height: 32.h),
                          const RecentAlertsSection(),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                SizedBox(height: 32.h),
                //const PopularPlacesList(),
                SizedBox(height: 100.h),
              ],
            ),
          ),
          ),
          )],
      );
  }
}
