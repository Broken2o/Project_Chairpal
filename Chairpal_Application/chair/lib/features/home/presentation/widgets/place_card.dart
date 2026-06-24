import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/favorite_cubit/favorite_cubit.dart';
import '../cubit/favorite_cubit/favorite_state.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_styles.dart';

import '../../../../features/home/presentation/screens/place_details_screen.dart';
import '../../domain/entities/place.dart';
import 'place_utils.dart';

/// Compact card for the horizontal Popular Places list.
///
/// * [showImage] = `true`  → real network image (or gradient fallback).
/// * [showImage] = `false` → rich gradient-header icon card; no network call.
class PlaceCard extends StatelessWidget {
  final Place place;
  final String distance;
  final bool showImage;

  const PlaceCard({
    super.key,
    required this.place,
    required this.distance,
    this.showImage = true,
  });

  @override
  Widget build(BuildContext context) {
    return showImage
        ? _ImageCard(place: place, distance: distance)
        : _IconCard(place: place, distance: distance);
  }
}

// ─────────────────────────────────────────────
// Layout A – image header card
// ─────────────────────────────────────────────
class _ImageCard extends StatelessWidget {
  final Place place;
  final String distance;

  const _ImageCard({required this.place, required this.distance});

  @override
  Widget build(BuildContext context) {
    final hasImage =
        place.imagePaths != null && place.imagePaths!.isNotEmpty;

    return _CardShell(
      onTap: () => _push(context, place, distance),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Image / gradient header ──────────────────
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(22.r),
                ),
                child: hasImage
                    ? Image.network(
                        place.imagePaths!.first,
                        height: 110,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (ctx, child, prog) => prog == null
                            ? child
                            : _HeaderGradient(
                                category: place.category,
                                height: 110,
                              ),
                        errorBuilder: (ctx, e, s) => _HeaderGradient(
                          category: place.category,
                          height: 110,
                        ),
                      )
                    : _HeaderGradient(
                        category: place.category,
                        height: 110,
                      ),
              ),
              // Bottom-to-top scrim so name is readable
              Positioned(
                bottom: 0.h,
                left: 0.w,
                right: 0.w,
                height: 50,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.45),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              // Category badge
              Positioned(
                top: 10.h,
                left: 10.w,
                child: _CategoryBadge(category: place.category),
              ),
              // Favourite
              Positioned(
                top: 8.h,
                right: 8.w,
                child: _FavBtn(place: place),
              ),
            ],
          ),

          // ── Content ─────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  place.name,
                  style: AppStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    color: const Color(0xFF1A2340),
                    letterSpacing: -0.1,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (place.address != null &&
                    place.address!.isNotEmpty) ...[
                  SizedBox(height: 3.h),
                  Row(
                    children: [
                      const Icon(
                        Icons.place_rounded,
                        size: 11,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Text(
                          place.address!,
                          style: AppStyles.bodySmall.copyWith(
                            fontSize: 10,
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
                SizedBox(height: 10.h),
                _FooterRow(rating: place.rating, distance: distance),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Layout B – gradient icon header card
// ─────────────────────────────────────────────
class _IconCard extends StatelessWidget {
  final Place place;
  final String distance;

  const _IconCard({required this.place, required this.distance});

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      onTap: () => _push(context, place, distance),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Gradient header with centred icon ────────
          Stack(
            children: [
              _HeaderGradient(
                category: place.category,
                height: 110,
                showCentredIcon: true,
              ),
              // Category badge (top-left, same as image card)
              Positioned(
                top: 10.h,
                left: 10.w,
                child: _CategoryBadge(category: place.category),
              ),
              // Favourite (top-right)
              Positioned(
                top: 8.h,
                right: 8.w,
                child: _FavBtn(place: place),
              ),
            ],
          ),

          // ── Content ─────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  place.name,
                  style: AppStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    color: const Color(0xFF1A2340),
                    letterSpacing: -0.1,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (place.address != null &&
                    place.address!.isNotEmpty) ...[
                  SizedBox(height: 3.h),
                  Row(
                    children: [
                      const Icon(
                        Icons.place_rounded,
                        size: 11,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Text(
                          place.address!,
                          style: AppStyles.bodySmall.copyWith(
                            fontSize: 10,
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
                SizedBox(height: 10.h),
                _FooterRow(rating: place.rating, distance: distance),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Shared heavy-lifting widgets
// ─────────────────────────────────────────────

/// White card shell with premium shadow + rounded corners.
class _CardShell extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;

  const _CardShell({required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 190,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

/// Gradient fill used for both the image fallback and the icon-only header.
class _HeaderGradient extends StatelessWidget {
  final String category;
  final double height;

  /// When `true`, draws a centred frosted-glass icon (icon-card mode).
  final bool showCentredIcon;

  const _HeaderGradient({
    required this.category,
    required this.height,
    this.showCentredIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    final icon = PlaceUtils.iconForCategory(category);
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)),
      child: Container(
        height: height,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0D6E6C), // deep teal
              AppColors.primary, // brand teal
              AppColors.primaryLight, // mint
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Watermark icon bottom-right
            Positioned(
              right: -12,
              bottom: -12,
              child: Icon(
                icon,
                size: 90,
                color: Colors.white.withValues(alpha: 0.07),
              ),
            ),
            if (showCentredIcon)
              Center(
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.35),
                      width: 1.2,
                    ),
                  ),
                  child: Icon(icon, color: Colors.white, size: 28),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Teal category badge (top-left of header).
class _CategoryBadge extends StatelessWidget {
  final String category;

  const _CategoryBadge({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.40),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.25),
        ),
      ),
      child: Text(
        PlaceUtils.formatCategory(category),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

/// White circle favourite button with shadow.
class _FavBtn extends StatelessWidget {
  final Place place;
  const _FavBtn({required this.place});

  @override
  Widget build(BuildContext context) {
    // Use shared FavoriteCubit instance from the nearest provider or the DI container
    // Determine the correct type for the API endpoint (e.g., 'organization', 'place')
    final String apiType = (place.type?.toLowerCase() ?? 'place');
    return BlocProvider.value(
      value: sl<FavoriteCubit>(),
      child: BlocBuilder<FavoriteCubit, FavoriteState>(
        builder: (context, state) {
          return GestureDetector(
            onTap: () {
              print('PlaceCard: Favorite tapped for ${apiType} ${place.id}');
              context.read<FavoriteCubit>().toggleFavorite(apiType, place.id);
              // Optimistically update UI state
              place.isFavorite = !place.isFavorite;
            },
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                place.isFavorite ? Icons.favorite : Icons.favorite_border_rounded,
                size: 15,
                color: place.isFavorite ? Colors.redAccent : AppColors.primary,
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Rating star + teal distance badge footer row.
class _FooterRow extends StatelessWidget {
  final double rating;
  final String distance;

  const _FooterRow({required this.rating, required this.distance});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Stars + value
        if (rating > 0) ...[
          const Icon(
            Icons.star_rounded,
            size: 13,
            color: Color(0xFFF5A623),
          ),
          SizedBox(width: 3.w),
          Text(
            rating.toStringAsFixed(1),
            style: AppStyles.bodySmall.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A2340),
            ),
          ),
          const Spacer(),
        ] else
          const Spacer(),

        // Distance pill
        Container(
          padding:
              EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryLight],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.near_me_rounded,
                size: 10,
                color: Colors.white,
              ),
              SizedBox(width: 3.w),
              Text(
                distance,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Navigation helper
// ─────────────────────────────────────────────
void _push(BuildContext context, Place place, String distance) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => PlaceDetailsScreen(
        place: place,
        distance: distance,
      ),
    ),
  );
}
