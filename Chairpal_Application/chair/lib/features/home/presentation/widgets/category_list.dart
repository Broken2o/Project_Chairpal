import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/category_cubit/category_cubit.dart';
import '../cubit/category_cubit/category_state.dart';
import '../cubit/popular_places_cubit/popular_places_cubit.dart';
import '../cubit/popular_places_cubit/popular_places_state.dart';
import '../../../../core/widgets/custom_empty_state.dart';
import '../../../../core/widgets/custom_error_state.dart';
import '../../../../l10n/l10n.dart';
import '../screens/add_category_screen.dart';
import '../screens/category_details_screen.dart';
import '../cubit/add_category_cubit/add_category_cubit.dart';
import '../cubit/category_details_cubit/category_details_cubit.dart';
import '../../../../core/di/injection_container.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context)!;
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.categories, style: AppStyles.h3),
          SizedBox(height: 16.h),
          SizedBox(
            height: 110,
            child: BlocBuilder<CategoryCubit, CategoryState>(
              builder: (context, categoryState) {
                if (categoryState is CategoryLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (categoryState is CategoryError) {
                  return CustomErrorState(
                    title: l10n.oops,
                    message: categoryState.message,
                    onRetry: () => context.read<CategoryCubit>().fetchCategories(mainOnly: true),
                  );
                } else if (categoryState is CategoriesSuccess) {
                  final categories = categoryState.categories;
                  if (categories.isEmpty) {
                    return CustomEmptyState(
                      title: l10n.noCategoriesTitle,
                      subtitle: l10n.noCategoriesSubtitle,
                      icon: Icons.category_rounded,
                    );
                  }
                  return BlocBuilder<PopularPlacesCubit, PopularPlacesState>(
                    builder: (context, placesState) {

                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length + 1, // +1 for Add New
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return Padding(
                              padding: EdgeInsets.only(right: 20.w),
                              child: GestureDetector(
                                onTap: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BlocProvider(
                                        create: (_) => sl<AddCategoryCubit>(),
                                        child: const AddCategoryScreen(),
                                      ),
                                    ),
                                  );
                                  if (result == true && context.mounted) {
                                    context.read<CategoryCubit>().fetchCategories(mainOnly: true);
                                  }
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      width: 70.w,
                                      height: 70.w,
                                      decoration: const BoxDecoration(
                                        color: AppColors.primary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.add, color: Colors.white, size: 30),
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      l10n.addNew,
                                      style: AppStyles.bodySmall.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primaryDark,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          final category = categories[index - 1];

                          return Padding(
                            padding: EdgeInsets.only(right: 20.w),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BlocProvider(
                                      create: (_) => sl<CategoryDetailsCubit>(),
                                      child: CategoryDetailsScreen(category: category),
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  Container(
                                    width: 70.w,
                                    height: 70.w,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(alpha: 0.08),
                                      shape: BoxShape.circle,
                                    ),
                                    child: (category.image != null && category.image!.isNotEmpty)
                                        ? ClipOval(
                                            child: Image.network(
                                              category.image!,
                                              fit: BoxFit.cover,
                                              width: 70.w,
                                              height: 70.w,
                                              errorBuilder: (context, error, stackTrace) {
                                                return Center(
                                                  child: Icon(
                                                    _getCategoryIcon(category.name),
                                                    color: AppColors.primary,
                                                    size: 28.w,
                                                  ),
                                                );
                                              },
                                            ),
                                          )
                                        : Center(
                                            child: Icon(
                                              _getCategoryIcon(category.name),
                                              color: AppColors.primary,
                                              size: 28.w,
                                            ),
                                          ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    category.name,
                                    style: AppStyles.bodySmall.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primaryDark,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
    );
  }

  IconData _getCategoryIcon(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('universit') || lower.contains('school')) return Icons.school;
    if (lower.contains('restaurant') || lower.contains('food')) return Icons.restaurant;
    if (lower.contains('hotel') || lower.contains('stay')) return Icons.hotel;
    if (lower.contains('hospital') || lower.contains('clinic')) return Icons.local_hospital;
    if (lower.contains('park') || lower.contains('garden')) return Icons.park;
    return Icons.category;
  }
}
