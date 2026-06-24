import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../../../../l10n/l10n.dart';
import '../admin_dashboard_content.dart';
import '../../cubit/home_dashboard_cubit/home_dashboard_cubit.dart';
import '../../cubit/home_dashboard_cubit/home_dashboard_state.dart';
import '../home_teal_header.dart';
import '../category_list.dart';

class AdminDashboardWidget extends StatelessWidget {
  const AdminDashboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          const HomeTealHeader(),
          SizedBox(height: 24.h),
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
                      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                    } else if (state is AdminDashboardLoaded) {
                      return AdminDashboardContent(dashboard: state.dashboard);
                    } else if (state is HomeDashboardError) {
                      return Center(child: Text(state.message, style: AppStyles.bodyMedium.copyWith(color: Colors.red)));
                    }
                    return const SizedBox.shrink();
                  },
                ),
                SizedBox(height: 32.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.categories,
                      style: AppStyles.h3.copyWith(color: AppColors.primaryDark, fontSize: 20.sp),
                    ),
                    TextButton(
                      onPressed: () {
                        // TODO: Navigate to Add Category
                      },
                      child: Text(
                        l10n.addNew,
                        style: AppStyles.bodyMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                const CategoryList(),
                SizedBox(height: 32.h),
                Text(
                  l10n.yourPlaces,
                  style: AppStyles.h3.copyWith(color: AppColors.primaryDark, fontSize: 20.sp),
                ),
                SizedBox(height: 16.h),
                // TODO: Your Places List
                SizedBox(height: 100.h),
              ],
            ),
          ),
          ),
          )],
      );
  }
}
