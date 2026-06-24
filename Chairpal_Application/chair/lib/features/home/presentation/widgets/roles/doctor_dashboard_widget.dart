import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../cubit/home_dashboard_cubit/home_dashboard_cubit.dart';
import '../../cubit/home_dashboard_cubit/home_dashboard_state.dart';
import '../home_teal_header.dart';
import '../home_search_bar.dart';
import '../doctor_dashboard_content.dart';

class DoctorDashboardWidget extends StatelessWidget {
  const DoctorDashboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFEBFAFB),
      child: Column(
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
                    BlocBuilder<HomeDashboardCubit, HomeDashboardState>(
                      builder: (context, state) {
                        if (state is HomeDashboardLoading) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          );
                        } else if (state is DoctorDashboardLoaded) {
                          return DoctorDashboardContent(
                            dashboard: state.dashboard,
                          );
                        } else if (state is HomeDashboardError) {
                          return Center(
                            child: Text(
                              state.message,
                              style: AppStyles.bodyMedium.copyWith(
                                color: Colors.red,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    SizedBox(height: 100.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
