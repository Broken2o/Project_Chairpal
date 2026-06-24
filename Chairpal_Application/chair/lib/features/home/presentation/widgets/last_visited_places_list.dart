import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../cubit/last_visited_places_cubit/last_visited_places_cubit.dart';
import '../cubit/last_visited_places_cubit/last_visited_places_state.dart';
import 'place_card.dart';

import '../../../../core/widgets/custom_empty_state.dart';
import '../../../../core/widgets/custom_error_state.dart';
import '../../../../l10n/l10n.dart';
import '../../../../core/constants/assets.dart';

class LastVisitedPlacesList extends StatelessWidget {
  const LastVisitedPlacesList({super.key});

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
                l10n.lastVisited,
                style: AppStyles.h3.copyWith(
                  color: AppColors.primaryDark,
                  fontSize: 20.sp,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            // Optional: View all button can be implemented later
          ],
        ),
        SizedBox(height: 16.h),

        // ── List ────────────────────────────────────────
        BlocBuilder<LastVisitedPlacesCubit, LastVisitedPlacesState>(
          builder: (context, state) {
            if (state is LastVisitedPlacesLoading) {
              return SizedBox(
                height: 220,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (state is LastVisitedPlacesError) {
              String msg = state.message;
              if (msg.contains("Unauthorized to view other users")) {
                msg = l10n.unauthorizedToViewOtherUsers;
              }
              return SizedBox(
                height: 245,
                child: CustomErrorState(
                  title: l10n.oops,
                  message: msg,
                  imagePath: Assets.imagesNoVisits,
                  // onRetry: () => context.read<LastVisitedPlacesCubit>().fetchLastVisitedPlaces(userId),
                ),
              );
            }

            if (state is LastVisitedPlacesLoaded) {
              if (state.places.isEmpty) {
                return SizedBox(
                  height: 245,
                  child: CustomEmptyState(
                    title: l10n.noPlacesFoundTitle,
                    subtitle: l10n.noPlacesFoundSubtitle,
                    imagePath: Assets.imagesNoVisits,
                  ),
                );
              }

              final bool listHasImages = state.places.any(
                (p) => p.imagePaths != null && p.imagePaths!.isNotEmpty,
              );

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
                    return PlaceCard(
                      place: place,
                      distance: _formatDistance(null, l10n), // Backend doesn't provide user pos here easily unless we pass it
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
