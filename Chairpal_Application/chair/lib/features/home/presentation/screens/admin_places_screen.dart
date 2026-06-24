import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../core/widgets/custom_back_button.dart';
import '../../../../core/widgets/custom_empty_state.dart';
import '../../../../core/widgets/custom_error_state.dart';
import '../../../../l10n/l10n.dart';
import '../cubit/admin_places_cubit/admin_places_cubit.dart';
import '../cubit/admin_places_cubit/admin_places_state.dart';
import '../cubit/category_cubit/category_cubit.dart';
import '../cubit/category_cubit/category_state.dart';
import 'organization_details_screen.dart';

class AdminPlacesScreen extends StatefulWidget {
  const AdminPlacesScreen({super.key});

  @override
  State<AdminPlacesScreen> createState() => _AdminPlacesScreenState();
}

class _AdminPlacesScreenState extends State<AdminPlacesScreen> {
  int? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    context.read<AdminPlacesCubit>().fetchOrganizations();
    context.read<CategoryCubit>().fetchCategories(mainOnly: true);
  }

  void _onCategorySelected(int? categoryId) {
    setState(() {
      _selectedCategoryId = categoryId;
    });
    context.read<AdminPlacesCubit>().fetchOrganizations(categoryId: categoryId);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leadingWidth: 100,
        leading: const CustomBackButton(),
        title: Text(
          l10n.places,
          style: AppStyles.h3.copyWith(color: AppColors.primaryDark),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 16.h),
          _buildCategoryFilters(l10n),
          SizedBox(height: 16.h),
          Expanded(child: _buildPlacesList(l10n)),
        ],
      ),
    );
  }

  Widget _buildCategoryFilters(S l10n) {
    return SizedBox(
      height: 40.h,
      child: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, state) {
          if (state is CategoriesSuccess) {
            final categories = state.categories;
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              itemCount: categories.length + 1,
              itemBuilder: (context, index) {
                final isAll = index == 0;
                final isSelected = isAll ? _selectedCategoryId == null : _selectedCategoryId == categories[index - 1].id;
                final text = isAll ? 'All' : categories[index - 1].name;

                return GestureDetector(
                  onTap: () => _onCategorySelected(isAll ? null : categories[index - 1].id),
                  child: Container(
                    margin: EdgeInsets.only(right: 12.w),
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : AppColors.textSecondary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        text,
                        style: AppStyles.bodyMedium.copyWith(
                          color: isSelected ? Colors.white : AppColors.textSecondary,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildPlacesList(S l10n) {
    return BlocBuilder<AdminPlacesCubit, AdminPlacesState>(
      builder: (context, state) {
        if (state is AdminPlacesLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is AdminPlacesError) {
          return CustomErrorState(
            title: l10n.oops,
            message: state.message,
            onRetry: () => context.read<AdminPlacesCubit>().fetchOrganizations(categoryId: _selectedCategoryId),
          );
        } else if (state is AdminPlacesLoaded) {
          final places = state.places;
          if (places.isEmpty) {
            return CustomEmptyState(
              title: l10n.noPlacesFoundTitle,
              subtitle: l10n.noPlacesFoundSubtitle,
              icon: Icons.location_city_outlined,
            );
          }
          return ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
            itemCount: places.length,
            separatorBuilder: (context, index) => SizedBox(height: 16.h),
            itemBuilder: (context, index) {
              final place = places[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrganizationDetailsScreen(organization: place),
                    ),
                  );
                },
                child: Container(
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
                  child: Row(
                    children: [
                      Container(
                        width: 60.w,
                        height: 60.w,
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: (place.imagePaths != null && place.imagePaths!.isNotEmpty)
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12.r),
                                child: Image.network(place.imagePaths!.first, fit: BoxFit.cover),
                              )
                            : const Icon(Icons.location_city, color: AppColors.primary),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              place.name,
                              style: AppStyles.h3.copyWith(fontSize: 16.sp),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              place.category,
                              style: AppStyles.bodySmall.copyWith(color: AppColors.primary),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 24.w),
                    ],
                  ),
                ),
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
