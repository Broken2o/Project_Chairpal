/// Shared widgets used across all entity detail screens:
/// OrganizationDetailsScreen, BuildingDetailsScreen, PlaceDetailsScreen, etc.
library detail_screen_widgets;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../domain/entities/review.dart';
import '../screens/rate_app_screen.dart';
import '../../domain/entities/place.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DetailHeroImage  — full-width image gallery + gradient overlay
// ─────────────────────────────────────────────────────────────────────────────

class DetailHeroImage extends StatelessWidget {
  final List<String>? imagePaths;
  final int currentPage;
  final ValueChanged<int> onPageChanged;
  final IconData fallbackIcon;

  const DetailHeroImage({
    super.key,
    required this.imagePaths,
    required this.currentPage,
    required this.onPageChanged,
    this.fallbackIcon = Icons.business,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = imagePaths != null && imagePaths!.isNotEmpty;
    if (!hasImage) {
      return Container(
        color: AppColors.primary,
        child: Center(
            child: Icon(fallbackIcon, color: Colors.white, size: 80.sp)),
      );
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        PageView.builder(
          itemCount: imagePaths!.length,
          onPageChanged: onPageChanged,
          itemBuilder: (_, i) => CachedNetworkImage(
            imageUrl: imagePaths![i],
            fit: BoxFit.cover,
            errorWidget: (_, __, ___) => Container(
              color: AppColors.primary,
              child: Icon(fallbackIcon, color: Colors.white, size: 60.sp),
            ),
          ),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.45),
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.10),
                ],
                stops: const [0, 0.5, 1],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DetailPageIndicator
// ─────────────────────────────────────────────────────────────────────────────

class DetailPageIndicator extends StatelessWidget {
  final int count;
  final int current;

  const DetailPageIndicator(
      {super.key, required this.count, required this.current});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          width: current == i ? 24.w : 8.w,
          height: 8.h,
          decoration: BoxDecoration(
            color: current == i
                ? Colors.white
                : Colors.white.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(4.r),
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DetailGlassButton  — frosted-glass overlay button (Back / Favourite)
// ─────────────────────────────────────────────────────────────────────────────

class DetailGlassButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;

  const DetailGlassButton(
      {super.key, required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
                color: Colors.white.withValues(alpha: 0.35), width: 1),
          ),
          child: child,
        ),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// DetailDragHandle
// ─────────────────────────────────────────────────────────────────────────────

class DetailDragHandle extends StatelessWidget {
  const DetailDragHandle({super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(top: 12.h, bottom: 4.h),
        child: Center(
          child: Container(
            width: 36.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
        ),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// DetailInlineRating  — ⭐⭐⭐⭐☆ 3.5 row
// ─────────────────────────────────────────────────────────────────────────────

class DetailInlineRating extends StatelessWidget {
  final double rating;

  const DetailInlineRating({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    if (rating <= 0) return const SizedBox.shrink();
    return Row(
      children: [
        ...List.generate(5, (i) {
          final filled = i < rating.floor();
          final half = !filled && i < rating;
          return Icon(
            filled
                ? Icons.star
                : half
                    ? Icons.star_half
                    : Icons.star_border,
            color: Colors.orange,
            size: 18.sp,
          );
        }),
        SizedBox(width: 6.w),
        Text(
          rating.toStringAsFixed(1),
          style: AppStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DetailCategoryChip  — small pill label
// ─────────────────────────────────────────────────────────────────────────────

class DetailCategoryChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const DetailCategoryChip(
      {super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.primary, size: 14.sp),
            SizedBox(width: 4.w),
            Text(label,
                style: AppStyles.bodySmall.copyWith(
                    color: AppColors.primary, fontWeight: FontWeight.w600)),
          ],
        ),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// DetailNavigationRow  — tappable arrow-row (buildings, floors, places…)
// ─────────────────────────────────────────────────────────────────────────────

class DetailNavigationRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const DetailNavigationRow(
      {super.key,
      required this.icon,
      required this.label,
      required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child:
                        Icon(icon, color: AppColors.primary, size: 20.sp),
                  ),
                  SizedBox(width: 12.w),
                  Text(label, style: AppStyles.bodyMediumBoldPrimaryDark),
                ],
              ),
              Icon(Icons.arrow_forward_ios,
                  color: AppColors.textSecondary, size: 16.sp),
            ],
          ),
        ),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// DetailRateSection  — stars + "Type your opinion" link
// ─────────────────────────────────────────────────────────────────────────────

class DetailRateSection extends StatefulWidget {
  final Place place;
  final String rateType; // 'place', 'organization', 'building', etc.
  final String title;

  const DetailRateSection({
    super.key,
    required this.place,
    required this.rateType,
    this.title = 'Rate this place',
  });

  @override
  State<DetailRateSection> createState() => _DetailRateSectionState();
}

class _DetailRateSectionState extends State<DetailRateSection> {
  int _selected = 0;

  void _openRate(int rating) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RateAppScreen(
          place: widget.place,
          initialRating: rating,
          type: widget.rateType,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title, style: AppStyles.h4PrimaryDark),
        SizedBox(height: 14.h),
        Row(
          children: List.generate(5, (i) {
            return GestureDetector(
              onTap: () {
                setState(() => _selected = i + 1);
                _openRate(i + 1);
              },
              child: Padding(
                padding: EdgeInsets.only(right: 10.w),
                child: AnimatedScale(
                  scale: i < _selected ? 1.15 : 1.0,
                  duration: const Duration(milliseconds: 150),
                  child: Icon(
                    i < _selected ? Icons.star : Icons.star_border,
                    color: i < _selected ? Colors.amber : Colors.grey.shade400,
                    size: 36.sp,
                  ),
                ),
              ),
            );
          }),
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: () => _openRate(_selected == 0 ? 1 : _selected),
          child: Text(
            'Type your opinion',
            style: AppStyles.bodySmall.copyWith(
              color: AppColors.primary,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DetailReviewsSection  — header + distribution bars + review cards
// ─────────────────────────────────────────────────────────────────────────────

class DetailReviewsSection extends StatelessWidget {
  final List<Review> reviews;
  final double avgRating;

  const DetailReviewsSection({
    super.key,
    required this.reviews,
    required this.avgRating,
  });

  Map<int, double> get _distribution {
    if (reviews.isEmpty) return {};
    final counts = <int, int>{1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    for (final r in reviews) {
      final key = r.rating.round().clamp(1, 5);
      counts[key] = (counts[key] ?? 0) + 1;
    }
    return counts.map((k, v) => MapEntry(k, v / reviews.length));
  }

  @override
  Widget build(BuildContext context) {
    final dist = _distribution;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header ──────────────────────────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Reviews', style: AppStyles.h4PrimaryDark),
            if (reviews.isNotEmpty)
              Text('View all',
                  style: AppStyles.bodySmall.copyWith(
                      color: AppColors.primary, fontWeight: FontWeight.w600)),
          ],
        ),
        SizedBox(height: 16.h),

        if (reviews.isNotEmpty) ...[
          // ── Distribution + average ───────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Bars
              Expanded(
                child: Column(
                  children: List.generate(5, (i) {
                    final star = 5 - i;
                    final pct = dist[star] ?? 0.0;
                    return Padding(
                      padding: EdgeInsets.only(bottom: 5.h),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 12.w,
                            child: Text('$star',
                                style: AppStyles.bodySmall
                                    .copyWith(color: AppColors.textSecondary)),
                          ),
                          SizedBox(width: 6.w),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4.r),
                              child: LinearProgressIndicator(
                                value: pct,
                                minHeight: 6.h,
                                backgroundColor: Colors.grey.shade200,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.primary),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(width: 20.w),
              // Average
              Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.orange, size: 28.sp),
                      SizedBox(width: 4.w),
                      Text(avgRating.toStringAsFixed(1),
                          style: AppStyles.h2PrimaryDark
                              .copyWith(fontSize: 28.sp)),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text('${reviews.length} Reviews',
                      style: AppStyles.bodySmall
                          .copyWith(color: AppColors.textSecondary)),
                ],
              ),
            ],
          ),
          SizedBox(height: 20.h),

          // ── Cards ────────────────────────────────────────────────────
          ...reviews.map((r) => DetailReviewCard(review: r)),
        ] else
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Text('No reviews yet',
                  style: AppStyles.bodyMediumSecondary),
            ),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DetailReviewCard  — single review card (avatar, name, stars, time, comment)
// ─────────────────────────────────────────────────────────────────────────────

class DetailReviewCard extends StatelessWidget {
  final Review review;

  const DetailReviewCard({super.key, required this.review});

  String _timeAgo(String? iso) {
    if (iso == null) return '';
    final dt = DateTime.tryParse(iso);
    if (dt == null) return '';
    final diff = DateTime.now().difference(dt);
    if (diff.inDays >= 7) {
      final w = (diff.inDays / 7).floor();
      return '$w week${w == 1 ? '' : 's'} ago';
    }
    if (diff.inDays > 0) return '${diff.inDays} day${diff.inDays == 1 ? '' : 's'} ago';
    if (diff.inHours > 0) return '${diff.inHours} hour${diff.inHours == 1 ? '' : 's'} ago';
    return 'Just now';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar
              CircleAvatar(
                radius: 22.r,
                backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                backgroundImage:
                    (review.user?.image != null && review.user!.image!.isNotEmpty)
                        ? NetworkImage(review.user!.image!) as ImageProvider
                        : null,
                child: (review.user?.image == null || review.user!.image!.isEmpty)
                    ? Icon(Icons.person, size: 22.sp, color: AppColors.primary)
                    : null,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.user?.name ?? 'Anonymous',
                      style: AppStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary),
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        ...List.generate(
                            5,
                            (i) => Icon(
                                  i < review.rating.floor()
                                      ? Icons.star
                                      : Icons.star_border,
                                  size: 14.sp,
                                  color: Colors.orange,
                                )),
                        SizedBox(width: 6.w),
                        Text(
                          _timeAgo(review.createdAt),
                          style: AppStyles.bodySmall
                              .copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (review.comment.isNotEmpty) ...[
            SizedBox(height: 10.h),
            Text(review.comment,
                style: AppStyles.bodyMediumSecondary.copyWith(height: 1.55)),
          ],
          SizedBox(height: 6.h),
          Divider(color: Colors.grey.shade100, height: 1),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DetailStartNavigationButton
// ─────────────────────────────────────────────────────────────────────────────

class DetailStartNavigationButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String label;

  const DetailStartNavigationButton({
    super.key,
    this.onTap,
    this.label = 'Start Navigation',
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 32.h),
        child: ElevatedButton(
          onPressed: onTap ?? () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            minimumSize: Size(double.infinity, 56.h),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
            elevation: 0,
          ),
          child: Text(
            label,
            style: AppStyles.bodyMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 16.sp),
          ),
        ),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// DetailSectionLabel
// ─────────────────────────────────────────────────────────────────────────────

class DetailSectionLabel extends StatelessWidget {
  final String label;
  const DetailSectionLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) => Text(label, style: AppStyles.h4PrimaryDark);
}
