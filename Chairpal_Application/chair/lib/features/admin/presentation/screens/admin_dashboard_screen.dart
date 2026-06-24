import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../auth/presentation/cubit/user_cubit/user_cubit.dart';
import '../../../auth/presentation/cubit/user_cubit/user_state.dart';
import '../widgets/admin_overview_card.dart';
import '../widgets/admin_places_list.dart';
import '../widgets/quick_actions_grid.dart';
import '../widgets/recent_activity_list.dart';
import '../../../../l10n/l10n.dart';
import '../../../home/presentation/cubit/category_cubit/category_cubit.dart';
import '../../../home/presentation/cubit/category_cubit/category_state.dart';
import '../../../home/data/repositories/home_repository_impl.dart';
import '../../../home/data/datasources/home_remote_data_source.dart';
import '../widgets/admin_category_list.dart';

/// Admin dashboard screen — pixel-perfect match to the provided designs.
class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: SafeArea(
        child: BlocProvider(
          create: (context) {
            final userState = context.read<UserCubit>().state;
            int? userId;
            if (userState is UserLoaded) {
              userId = userState.user.id;
            }
            return CategoryCubit(
              homeRepository: HomeRepositoryImpl(
                remoteDataSource: HomeRemoteDataSourceImpl(),
              ),
            )..fetchCategories(
                ownerId: userId,
                mainOnly: true,
                include:
                    'owner,parent,children,organizations,organizations.owner,organizations.categories,organizations.country,organizations.city,places,places.owner,places.categories,places.reviews,places.favoritedBy',
              );
          },
          child: CustomScrollView(
            slivers: [
              // Top padding
              SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Header greeting
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _AdminHeader(),
              ),
            ),

            SliverToBoxAdapter(child: SizedBox(height: 20)),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: BlocBuilder<CategoryCubit, CategoryState>(
                  builder: (context, state) {
                    int totalCategories = 8; // default mock
                    if (state is CategoriesSuccess) {
                      totalCategories = state.categories.length;
                    }
                    return AdminOverviewCard(
                      totalPlaces: 24, // Keep mock for now
                      totalCategories: totalCategories,
                    );
                  },
                ),
              ),
            ),

            SliverToBoxAdapter(child: SizedBox(height: 28)),

            // Quick Actions
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        S.of(context)!.adminQuickActions,
                        style: AppStyles.h3.copyWith(
                          color: const Color(0xFF1A2B3C),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    QuickActionsGrid(
                      actions: [
                        QuickAction(
                          icon: Icons.add_rounded,
                          label: S.of(context)!.adminAddPlace,
                          iconColor: const Color(0xFF5C6BC0),
                          iconBackground: const Color(0xFFEEF0FB),
                          onTap: () {},
                        ),
                        QuickAction(
                          icon: Icons.layers_rounded,
                          label: S.of(context)!.adminAddCategory,
                          iconColor: const Color(0xFF8E6BBE),
                          iconBackground: const Color(0xFFF3EEFB),
                          onTap: () {},
                        ),
                        QuickAction(
                          icon: Icons.edit_rounded,
                          label: S.of(context)!.adminEditInfo,
                          iconColor: const Color(0xFFE09B3D),
                          iconBackground: const Color(0xFFFDF4E7),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(child: SizedBox(height: 28)),

            // Your Places
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: AdminPlacesList(
                  places: [
                    AdminPlaceItem(
                      name: S.of(context)!.adminMockPlaceUniversity,
                      type: S.of(context)!.adminMockTypeUniversity,
                      icon: Icons.account_balance_rounded,
                      iconColor: const Color(0xFF5C6BC0),
                      iconBackground: const Color(0xFFEEF0FB),
                    ),
                    AdminPlaceItem(
                      name: S.of(context)!.adminMockPlaceRestaurant,
                      type: S.of(context)!.adminMockTypeRestaurant,
                      icon: Icons.restaurant_rounded,
                      iconColor: const Color(0xFF8E6BBE),
                      iconBackground: const Color(0xFFF3EEFB),
                    ),
                    AdminPlaceItem(
                      name: S.of(context)!.adminMockPlaceHotel,
                      type: S.of(context)!.adminMockTypeHotel,
                      icon: Icons.hotel_rounded,
                      iconColor: const Color(0xFFE09B3D),
                      iconBackground: const Color(0xFFFDF4E7),
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(child: SizedBox(height: 28)),

            // Your Categories
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: BlocBuilder<CategoryCubit, CategoryState>(
                  builder: (context, state) {
                    if (state is CategoryLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is CategoriesSuccess) {
                      return AdminCategoryList(
                        categories: state.categories,
                        onViewAll: () {},
                      );
                    } else if (state is CategoryError) {
                      return Text('Error: ${state.message}', style: const TextStyle(color: Colors.red));
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),

            SliverToBoxAdapter(child: SizedBox(height: 28)),

            // Recent Activity
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: RecentActivityList(
                  activities: [
                    ActivityItem(
                      title: S.of(context)!.adminActivityNewPlace,
                      subtitle: S.of(context)!.adminActivityNewPlaceSub(
                        S.of(context)!.adminMockPlaceUniversity,
                        'universities',
                      ),
                      timeAgo: S.of(context)!.adminTimeHoursAgo(2),
                      icon: Icons.check_rounded,
                      iconColor: const Color(0xFF38A169),
                      iconBackground: const Color(0xFFEBF8F1),
                    ),
                    ActivityItem(
                      title: S.of(context)!.adminActivityPlaceUpdated,
                      subtitle: S.of(context)!.adminActivityPlaceUpdatedSub(
                        S.of(context)!.adminMockPlaceRestaurant,
                      ),
                      timeAgo: S.of(context)!.adminTimeHoursAgo(5),
                      icon: Icons.edit_rounded,
                      iconColor: const Color(0xFF5C6BC0),
                      iconBackground: const Color(0xFFEEF0FB),
                    ),
                    ActivityItem(
                      title: S.of(context)!.adminActivityNewCategory,
                      subtitle: S.of(context)!.adminActivityNewCategorySub(
                        'Recreation',
                      ),
                      timeAgo: S.of(context)!.adminTimeDaysAgo(1),
                      icon: Icons.layers_rounded,
                      iconColor: const Color(0xFF8E6BBE),
                      iconBackground: const Color(0xFFF3EEFB),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom space for nav bar
            SliverToBoxAdapter(child: SizedBox(height: 120)),
          ],
        ),
        ),
      ),
    );
  }
}

class _AdminHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context)!.adminWelcomeBack,
              style: AppStyles.h2.copyWith(
                color: AppColors.primaryDark,
                fontSize: 26,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              S.of(context)!.adminManagePlacesSubtitle,
              style: AppStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        );
      },
    );
  }
}
