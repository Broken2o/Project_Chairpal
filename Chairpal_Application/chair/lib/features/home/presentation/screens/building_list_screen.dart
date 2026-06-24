import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../core/widgets/entity_card_large.dart';
import '../../domain/entities/place.dart';
import '../cubit/building_list_cubit/building_list_cubit.dart';
import '../cubit/building_list_cubit/building_list_state.dart';
import '../cubit/favorite_cubit/favorite_cubit.dart';
import 'add_building_screen.dart';
import 'building_details_screen.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../l10n/l10n.dart';
import 'package:chair_pal/core/widgets/custom_back_button.dart';

class BuildingListScreen extends StatefulWidget {
  final Place organization;

  const BuildingListScreen({super.key, required this.organization});

  @override
  State<BuildingListScreen> createState() => _BuildingListScreenState();
}

class _BuildingListScreenState extends State<BuildingListScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context)!;
    return BlocProvider(
      create: (context) => sl<BuildingListCubit>()..fetchBuildings(int.parse(widget.organization.id)),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          centerTitle: true,
          leadingWidth: 100.w,
          leading: const CustomBackButton(),
          title: Text(
            l10n.buildings,
            style: AppStyles.h3PrimaryDark.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        body: BlocBuilder<BuildingListCubit, BuildingListState>(
          builder: (context, state) {
            if (state is BuildingListLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is BuildingListError) {
              return Center(child: Text(state.message, style: TextStyle(color: Colors.red, fontSize: 14.sp)));
            } else if (state is BuildingListLoaded) {
              final buildings = state.buildings;

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

                    // Add new building
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: context.read<BuildingListCubit>(),
                              child: AddBuildingScreen(organization: widget.organization),
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
                          Text(l10n.addNewBuilding, style: AppStyles.bodyMedium.copyWith(color: AppColors.primaryDark)),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Expanded(
                      child: buildings.isEmpty
                          ? Center(
                              child: Text(
                                l10n.noBuildingsFound,
                                style: AppStyles.bodyMediumSecondary,
                              ),
                            )
                          : ListView.builder(
                              itemCount: buildings.length,
                              itemBuilder: (context, index) {
                                final building = buildings[index];
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 16.h),
                                  child: EntityCardLarge(
                                    title: building.name,
                                    imageUrl: building.imagePaths?.isNotEmpty == true ? building.imagePaths!.first : null,
                                    distance: 'N/A',
                                    isFavorite: building.isFavorite,
                                    onFavoriteToggle: () {
                                      context.read<FavoriteCubit>().toggleFavorite('building', building.id);
                                      building.isFavorite = !building.isFavorite;
                                    },
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => BuildingDetailsScreen(building: building),
                                        ),
                                      );
                                    },
                                  ),
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
