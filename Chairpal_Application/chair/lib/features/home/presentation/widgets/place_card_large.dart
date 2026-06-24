import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';

import '../../../../features/home/presentation/screens/place_details_screen.dart';

import '../../domain/entities/place.dart';
import 'place_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/favorite_cubit/favorite_cubit.dart';
import '../cubit/favorite_cubit/favorite_state.dart';
import '../../../../core/di/injection_container.dart';

/// A large card for the full-screen Popular Places list.
///
/// [showImage] – when `false` (all places in the list lack images),
/// renders a horizontal icon-accent layout instead of an image header.
class PlaceCardLarge extends StatelessWidget {
  final Place place;
  final String distance;

  /// `true` → image header shown.
  /// `false` → horizontal icon-accent, no image slot.
  final bool showImage;

  const PlaceCardLarge({
    super.key,
    required this.place,
    required this.distance,
    this.showImage = true,
  });

  @override
  Widget build(BuildContext context) {
    return showImage
        ? _ImageCardLarge(place: place, distance: distance)
        : _IconCardLarge(place: place, distance: distance);
  }
}

// ─────────────────────────────────────────────────────────
// Layout A – with image header
// ─────────────────────────────────────────────────────────
class _ImageCardLarge extends StatelessWidget {
  final Place place;
  final String distance;

  const _ImageCardLarge({required this.place, required this.distance});

  @override
  Widget build(BuildContext context) {
    final hasImage =
        place.imagePaths != null && place.imagePaths!.isNotEmpty;

    return GestureDetector(
      onTap: () => _openDetails(context, place, distance),
      child: Container(
        margin: EdgeInsets.only(bottom: 20.h),
        decoration: _cardDecoration(radius: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image zone ────────────────────────────────
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24.r),
                  ),
                  child: hasImage
                      ? Image.network(
                          place.imagePaths!.first,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, progress) =>
                              progress == null
                                  ? child
                                  : _GradientPlaceholderLarge(
                                      category: place.category,
                                    ),
                          errorBuilder: (context, error, stackTrace) =>
                              _GradientPlaceholderLarge(
                            category: place.category,
                          ),
                        )
                      : _GradientPlaceholderLarge(category: place.category),
                ),
                // Rating badge
                if (place.rating > 0)
                  Positioned(
                    top: 14.h,
                    left: 14.w,
                    child: _GlassBadge(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 13,
                            color: Color(0xFFF5A623),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            place.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                Positioned(
                  top: 14.h,
                  right: 14.w,
                  child: _FavButton(place: place),
                ),
              ],
            ),

            // ── Content ───────────────────────────────────
            _CardContent(place: place, distance: distance),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Layout B – no image; horizontal icon-accent card
// ─────────────────────────────────────────────────────────
class _IconCardLarge extends StatelessWidget {
  final Place place;
  final String distance;

  const _IconCardLarge({required this.place, required this.distance});

  @override
  Widget build(BuildContext context) {
    final icon = PlaceUtils.iconForCategory(place.category);

    return GestureDetector(
      onTap: () => _openDetails(context, place, distance),
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: _cardDecoration(radius: 20),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Left accent strip with icon ─────────────
              Container(
                width: 84,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryDark,
                      AppColors.primary,
                      AppColors.primaryLight,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(20.r),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, color: Colors.white, size: 32),
                    SizedBox(height: 6.h),
                    // Category abbreviated
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      child: Text(
                        PlaceUtils.formatCategory(place.category),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Right content ────────────────────────────
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 14, 12, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name + favourite
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              place.name,
                              style: AppStyles.h3.copyWith(fontSize: 15),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          _FavButton(place: place),
                        ],
                      ),
                      SizedBox(height: 6.h),

                      // Address
                      if (place.address != null &&
                          place.address!.isNotEmpty) ...[
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 13,
                              color: AppColors.textSecondary,
                            ),
                            SizedBox(width: 4.w),
                            Expanded(
                              child: Text(
                                place.address!,
                                style: AppStyles.bodySmall.copyWith(
                                  fontSize: 11,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                      ],

                      // Info chips
                      if (place.openingHours != null ||
                          place.phone != null ||
                          place.website != null)
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: [
                            if (place.openingHours != null)
                              _InfoChip(
                                icon: Icons.access_time_rounded,
                                label: place.openingHours!,
                              ),
                            if (place.phone != null)
                              _InfoChip(
                                icon: Icons.phone_rounded,
                                label: '\u202A${place.phone!}\u202C',
                              ),
                            if (place.website != null)
                              const _InfoChip(
                                icon: Icons.language_rounded,
                                label: 'Website',
                              ),
                          ],
                        ),

                      const Spacer(),

                      // Rating + Distance
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (place.rating > 0)
                            Row(
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  size: 14,
                                  color: Color(0xFFF5A623),
                                ),
                                SizedBox(width: 3.w),
                                Text(
                                  place.rating.toStringAsFixed(1),
                                  style: AppStyles.bodySmall.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            )
                          else
                            SizedBox.shrink(),
                          Row(
                            children: [
                              const Icon(
                                Icons.near_me_rounded,
                                size: 13,
                                color: AppColors.textSecondary,
                              ),
                              SizedBox(width: 3.w),
                              Text(
                                distance,
                                style: AppStyles.bodySmall.copyWith(
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Shared content block (used in _ImageCardLarge)
// ─────────────────────────────────────────────────────────
class _CardContent extends StatelessWidget {
  final Place place;
  final String distance;

  const _CardContent({required this.place, required this.distance});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category + Distance
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: _CategoryChip(category: place.category),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.near_me_rounded,
                    size: 13,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    distance,
                    style: AppStyles.bodySmall,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10.h),

          // Name
          Text(
            place.name,
            style: AppStyles.h3.copyWith(fontSize: 17),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 6.h),

          // Address
          if (place.address != null && place.address!.isNotEmpty) ...[
            Row(
              children: [
                const Icon(
                  Icons.map_outlined,
                  size: 14,
                  color: AppColors.textSecondary,
                ),
                SizedBox(width: 6.w),
                Expanded(
                  child: Text(
                    place.address!,
                    style: AppStyles.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
          ],

          // Info chips
          if (place.openingHours != null ||
              place.phone != null ||
              place.website != null)
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: [
                if (place.openingHours != null)
                  _InfoChip(
                    icon: Icons.access_time_rounded,
                    label: place.openingHours!,
                  ),
                if (place.phone != null)
                  _InfoChip(
                    icon: Icons.phone_rounded,
                    label: '\u202A${place.phone!}\u202C',
                  ),
                if (place.website != null)
                  const _InfoChip(
                    icon: Icons.language_rounded,
                    label: 'Website',
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Micro-widgets
// ─────────────────────────────────────────────────────────

class _GradientPlaceholderLarge extends StatelessWidget {
  final String category;

  const _GradientPlaceholderLarge({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.15),
            AppColors.primaryLight.withValues(alpha: 0.28),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            PlaceUtils.iconForCategory(category),
            size: 52,
            color: AppColors.primary.withValues(alpha: 0.45),
          ),
          SizedBox(height: 8.h),
          Text(
            'No image available',
            style: AppStyles.bodySmall.copyWith(
              color: AppColors.primary.withValues(alpha: 0.55),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _FavButton extends StatelessWidget {
  final Place place;
  const _FavButton({required this.place});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<FavoriteCubit>(),
      child: BlocBuilder<FavoriteCubit, FavoriteState>(
        builder: (context, state) {
          return GestureDetector(
            onTap: () {
              print('PlaceCardLarge: Favorite tapped for place ${place.id}');
              context.read<FavoriteCubit>().toggleFavorite('place', place.id);
              place.isFavorite = !place.isFavorite;
            },
            child: Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Icon(
                place.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: place.isFavorite ? Colors.redAccent : AppColors.primary,
                size: 18,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _GlassBadge extends StatelessWidget {
  final Widget child;

  const _GlassBadge({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: child,
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String category;

  const _CategoryChip({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Text(
        PlaceUtils.formatCategory(category),
        style: AppStyles.bodySmall.copyWith(
          color: AppColors.primary,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: AppColors.textSecondary),
          SizedBox(width: 4.w),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 100),
            child: Text(
              label,
              style: AppStyles.bodySmall.copyWith(fontSize: 10),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────
BoxDecoration _cardDecoration({required double radius}) => BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: const Color(0xFFF0F0F0)),
      boxShadow: const [
        BoxShadow(
          color: Color(0x0C000000),
          blurRadius: 14,
          offset: Offset(0, 4),
        ),
        BoxShadow(
          color: Color(0x06000000),
          blurRadius: 4,
          offset: Offset(0, 1),
        ),
      ],
    );

void _openDetails(BuildContext context, Place place, String distance) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PlaceDetailsScreen(
        place: place,
        distance: distance,
      ),
    ),
  );
}
