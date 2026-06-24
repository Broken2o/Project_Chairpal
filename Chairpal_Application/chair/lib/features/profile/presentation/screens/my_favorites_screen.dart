import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../l10n/l10n.dart';
import '../../../../core/constants/assets.dart';
import '../../../../core/di/injection_container.dart';
import '../../../home/presentation/widgets/place_card.dart';
import '../cubit/favorites_cubit/favorites_cubit.dart';
import '../cubit/favorites_cubit/favorites_state.dart';
import 'package:chair_pal/core/widgets/custom_back_button.dart';

class MyFavoritesScreen extends StatelessWidget {
  const MyFavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context)!;
    
    return BlocProvider(
      create: (context) => sl<FavoritesCubit>()..fetchFavorites(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          leading: const CustomBackButton(),
          leadingWidth: 100,
          title: Text(
            l10n.myFavorites,
            style: AppStyles.h3.copyWith(color: AppColors.primaryDark),
          ),
        ),
        body: BlocBuilder<FavoritesCubit, FavoritesState>(
          builder: (context, state) {
            if (state is FavoritesLoading || state is FavoritesInitial) {
              return const Center(child: CircularProgressIndicator(color: AppColors.primary));
            }

            if (state is FavoritesError) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Text(
                    state.message,
                    style: AppStyles.bodyLarge.copyWith(color: AppColors.error),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            if (state is FavoritesLoaded) {
              if (state.favorites.isEmpty) {
                return _buildEmptyState(l10n);
              }

              return ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                itemCount: state.favorites.length,
                separatorBuilder: (context, index) => SizedBox(height: 16.h),
                itemBuilder: (context, index) {
                  return PlaceCard(place: state.favorites[index], distance: '');
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(S l10n) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              Assets.imagesNoFav,
              height: 250,
            ),
            SizedBox(height: 32.h),
            Text(
              l10n.noFavoritesYet,
              style: AppStyles.h3.copyWith(
                color: AppColors.primaryDark,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            Text(
              l10n.noFavoritesSubtitle,
              style: AppStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 80.h), 
          ],
        ),
      ),
    );
  }
}
