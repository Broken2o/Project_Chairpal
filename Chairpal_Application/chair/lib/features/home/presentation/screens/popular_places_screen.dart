import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../widgets/place_card_large.dart';
import '../cubit/popular_places_cubit/popular_places_cubit.dart';
import '../cubit/popular_places_cubit/popular_places_state.dart';
import 'package:chair_pal/core/widgets/custom_back_button.dart';

class PopularPlacesScreen extends StatelessWidget {
  const PopularPlacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: BlocBuilder<PopularPlacesCubit, PopularPlacesState>(
          builder: (context, state) {
            final String title =
                (state is PopularPlacesLoaded &&
                        state.selectedCategory != null)
                    ? 'Popular in ${state.selectedCategory}'
                    : (state is PopularPlacesLoading &&
                            state.selectedCategory != null)
                        ? 'Popular in ${state.selectedCategory}'
                        : 'Popular Places';
            return Text(
              title,
              style: AppStyles.h3.copyWith(color: AppColors.primaryDark),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            );
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const CustomBackButton(),
        leadingWidth: 100,
      ),
      body: BlocBuilder<PopularPlacesCubit, PopularPlacesState>(
        builder: (context, state) {
          if (state is PopularPlacesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PopularPlacesError) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(24.r),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.wifi_off_rounded,
                      size: 52,
                      color: Colors.grey[300],
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: AppStyles.bodySmall.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    ElevatedButton.icon(
                      onPressed: () =>
                          context.read<PopularPlacesCubit>().fetchPopularPlaces(),
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Try again'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is PopularPlacesLoaded) {
            if (state.places.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.location_off_rounded,
                      size: 52,
                      color: Colors.grey[300],
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'No popular places found nearby.',
                      style: AppStyles.bodySmall.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }

            // Detect if ANY place has images.
            final bool listHasImages = state.places.any(
              (p) => p.imagePaths != null && p.imagePaths!.isNotEmpty,
            );

            return ListView.builder(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 32),
              itemCount: state.places.length,
              itemBuilder: (context, index) {
                final place = state.places[index];
                final distanceStr = _formatDistance(
                  state.userPosition != null
                      ? Geolocator.distanceBetween(
                          state.userPosition!.latitude,
                          state.userPosition!.longitude,
                          place.latitude,
                          place.longitude,
                        )
                      : null,
                );
                return PlaceCardLarge(
                  place: place,
                  distance: distanceStr,
                  showImage: listHasImages,
                );
              },
            );
          }

          return SizedBox.shrink();
        },
      ),
    );
  }

  String _formatDistance(double? meters) {
    if (meters == null) return 'Unknown';
    if (meters >= 1000) {
      return '${(meters / 1000).toStringAsFixed(1)}km';
    }
    return '${meters.round()}m';
  }
}
