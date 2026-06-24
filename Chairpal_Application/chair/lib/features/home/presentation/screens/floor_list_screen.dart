import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../domain/entities/place.dart';
import '../cubit/floor_list_cubit/floor_list_cubit.dart';
import '../cubit/floor_list_cubit/floor_list_state.dart';
import 'add_floor_screen.dart';
import 'floor_details_screen.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../l10n/l10n.dart';
import 'package:chair_pal/core/widgets/custom_back_button.dart';

class FloorListScreen extends StatefulWidget {
  final Place building;

  const FloorListScreen({super.key, required this.building});

  @override
  State<FloorListScreen> createState() => _FloorListScreenState();
}

class _FloorListScreenState extends State<FloorListScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context)!;
    return BlocProvider(
      create: (context) => sl<FloorListCubit>()..fetchFloors(int.parse(widget.building.id)),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          centerTitle: true,
          leadingWidth: 100.w,
          leading: const CustomBackButton(),
          title: Text(
            l10n.floors,
            style: AppStyles.h3PrimaryDark.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        body: BlocBuilder<FloorListCubit, FloorListState>(
          builder: (context, state) {
            if (state is FloorListLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is FloorListError) {
              return Center(child: Text(state.message, style: TextStyle(color: Colors.red, fontSize: 14.sp)));
            } else if (state is FloorListLoaded) {
              final floors = state.floors;

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    // Search Bar
                    CustomTextField(
                      controller: TextEditingController(),
                      hintText: l10n.search,
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                    ),
                    SizedBox(height: 24.h),

                    // Add new floor
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: context.read<FloorListCubit>(),
                              child: AddFloorScreen(building: widget.building),
                            ),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Container(
                            width: 32.w,
                            height: 32.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary,
                            ),
                            child: Icon(Icons.add, color: Colors.white, size: 20.sp),
                          ),
                          SizedBox(width: 12.w),
                          Text(l10n.addNewFloor, style: AppStyles.bodyMedium.copyWith(color: AppColors.primaryDark)),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Expanded(
                      child: floors.isEmpty
                          ? Center(
                              child: Text(
                                l10n.noFloorsFound,
                                style: AppStyles.bodyMediumSecondary,
                              ),
                            )
                          : ListView.separated(
                              itemCount: floors.length,
                              separatorBuilder: (context, index) => SizedBox(height: 8.h),
                              itemBuilder: (context, index) {
                                final floor = floors[index];
                                return ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: Container(
                                    width: 48.w,
                                    height: 48.h,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFF0FAFA),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.stairs_outlined, color: AppColors.primary),
                                  ),
                                  title: Text(floor.name, style: AppStyles.bodyMedium),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => FloorDetailsScreen(floor: floor),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                    ),
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
}
