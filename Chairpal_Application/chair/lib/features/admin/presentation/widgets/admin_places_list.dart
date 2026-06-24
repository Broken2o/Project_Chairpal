import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../l10n/l10n.dart';

/// A data model for a place list item.
class AdminPlaceItem {
  final String name;
  final String type;
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final VoidCallback? onTap;

  const AdminPlaceItem({
    required this.name,
    required this.type,
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    this.onTap,
  });
}

class AdminPlacesList extends StatelessWidget {
  final List<AdminPlaceItem> places;
  final VoidCallback? onViewAll;

  const AdminPlacesList({
    super.key,
    required this.places,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              S.of(context)!.adminYourPlaces,
              style: AppStyles.h3.copyWith(
                color: const Color(0xFF1A2B3C),
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: onViewAll,
              child: Text(
                S.of(context)!.adminViewAll,
                style: AppStyles.bodySmall.copyWith(
                  color: AppColors.textHint,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        // List
        ...places.map((place) => _PlaceListTile(place: place)),
      ],
    );
  }
}

class _PlaceListTile extends StatelessWidget {
  final AdminPlaceItem place;

  const _PlaceListTile({required this.place});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFF0F0F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: place.iconBackground,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(place.icon, color: place.iconColor, size: 22),
          ),
          SizedBox(width: 14.w),
          // Name & type
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  place.name,
                  style: AppStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A2B3C),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  place.type,
                  style: AppStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Arrow
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.primary,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
