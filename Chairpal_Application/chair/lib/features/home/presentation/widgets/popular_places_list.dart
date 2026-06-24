import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../cubit/popular_places_cubit/popular_places_cubit.dart';
import '../cubit/popular_places_cubit/popular_places_state.dart';
import 'place_card.dart';

import '../../../../features/home/presentation/screens/popular_places_screen.dart';
import '../../../../core/widgets/custom_empty_state.dart';
import '../../../../core/widgets/custom_error_state.dart';
import '../../../../l10n/l10n.dart';

class PopularPlacesList extends StatelessWidget {
  const PopularPlacesList({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Section header ──────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                l10n.popularPlaces,
                style: AppStyles.h3.copyWith(
                  color: AppColors.primaryDark,
                  fontSize: 20.sp,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            TextButton(
              onPressed: () {
                final cubit = context.read<PopularPlacesCubit>();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider.value(
                      value: cubit,
                      child: const PopularPlacesScreen(),
                    ),
                  ),
                );
              },
              child: Text(
                l10n.viewAll,
                style: AppStyles.bodySmall.copyWith(
                  color: Colors.grey.shade400,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),

        // ── List ────────────────────────────────────────
        BlocBuilder<PopularPlacesCubit, PopularPlacesState>(
          builder: (context, state) {
            if (state is PopularPlacesLoading) {
              return SizedBox(
                height: 220,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (state is PopularPlacesError) {
              return SizedBox(
                height: 220,
                child: CustomErrorState(
                  title: l10n.oops,
                  message: state.message,
                  onRetry: () =>
                      context.read<PopularPlacesCubit>().fetchPopularPlaces(),
                ),
              );
            }

            if (state is PopularPlacesLoaded) {
              if (state.places.isEmpty) {
                return SizedBox(
                  height: 220,
                  child: CustomEmptyState(
                    title: l10n.noPlacesFoundTitle,
                    subtitle: l10n.noPlacesFoundSubtitle,
                    icon: Icons.location_off_rounded,
                  ),
                );
              }

              // Detect whether ANY place in the list has an image.
              final bool listHasImages = state.places.any(
                (p) => p.imagePaths != null && p.imagePaths!.isNotEmpty,
              );

              // Height varies: with images → taller (image + content),
              // without images → compact icon-accent card height.
              final double listHeight = 220;

              return SizedBox(
                height: listHeight,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(bottom: 4.h),
                  itemCount: state.places.length,
                  separatorBuilder: (context, index) =>
                      SizedBox(width: 14.w),
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
                      l10n,
                    );
                    return PlaceCard(
                      place: place,
                      distance: distanceStr,
                      showImage: listHasImages,
                    );
                  },
                ),
              );
            }

            return SizedBox.shrink();
          },
        ),
      ],
    );
  }

  String _formatDistance(double? meters, S l10n) {
    if (meters == null) return l10n.unknownDistance;
    if (meters >= 1000) {
      return '${(meters / 1000).toStringAsFixed(0)}km';
    }
    return '${meters.round()}m';
  }
}
