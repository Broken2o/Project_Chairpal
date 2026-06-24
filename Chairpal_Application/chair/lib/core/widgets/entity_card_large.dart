import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../theme/app_colors.dart';
import '../theme/app_styles.dart';

class EntityCardLarge extends StatefulWidget {
  final String? imageUrl;
  final String title;
  final String? distance;
  final List<String> avatarUrls;
  final int totalVisitorsCount;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onTap;

  const EntityCardLarge({
    super.key,
    this.imageUrl,
    required this.title,
    this.distance,
    this.avatarUrls = const [],
    this.totalVisitorsCount = 0,
    this.isFavorite = false,
    this.onFavoriteToggle,
    this.onTap,
  });

  @override
  State<EntityCardLarge> createState() => _EntityCardLargeState();
}

class _EntityCardLargeState extends State<EntityCardLarge> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
  }

  @override
  void didUpdateWidget(covariant EntityCardLarge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isFavorite != widget.isFavorite) {
      _isFavorite = widget.isFavorite;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: 220.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                    child: _buildImage(),
                  ),
                  // Favorite Button
                  Positioned(
                    top: 12.h,
                    right: 12.w,
                    child: GestureDetector(
                      onTap: () {
                        if (widget.onFavoriteToggle != null) {
                          widget.onFavoriteToggle!();
                        }
                        setState(() {
                          _isFavorite = !_isFavorite;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(6.r),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                          child: Icon(
                            _isFavorite ? Icons.favorite : Icons.favorite_border,
                            key: ValueKey<bool>(_isFavorite),
                            color: _isFavorite ? AppColors.primary : Colors.grey,
                            size: 18.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Text and Details Section
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(12.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.title,
                      style: AppStyles.h4PrimaryDark.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Avatars Stack
                        _buildAvatarsStack(),
                        // Distance
                        if (widget.distance != null)
                          Text(
                            widget.distance!,
                            style: AppStyles.bodySmall.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
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
    );
  }

  Widget _buildImage() {
    if (widget.imageUrl == null || widget.imageUrl!.isEmpty) {
      return Container(
        color: AppColors.primary.withValues(alpha: 0.1),
        width: double.infinity,
        height: double.infinity,
        child: Icon(
          Icons.image_not_supported,
          color: AppColors.primary.withValues(alpha: 0.5),
          size: 40.sp,
        ),
      );
    }
    return CachedNetworkImage(
      imageUrl: widget.imageUrl!,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        color: AppColors.primary.withValues(alpha: 0.1),
      ),
      errorWidget: (context, url, error) => Container(
        color: AppColors.primary.withValues(alpha: 0.1),
        child: Icon(
          Icons.broken_image,
          color: AppColors.primary.withValues(alpha: 0.5),
          size: 40.sp,
        ),
      ),
    );
  }

  Widget _buildAvatarsStack() {
    if (widget.avatarUrls.isEmpty && widget.totalVisitorsCount == 0) {
      return const SizedBox.shrink();
    }

    final displayAvatars = widget.avatarUrls.take(3).toList();
    final remainingCount = widget.totalVisitorsCount > 3 ? widget.totalVisitorsCount - 3 : 0;

    return SizedBox(
      height: 24.r,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              for (int i = 0; i < displayAvatars.length; i++)
                Positioned(
                  left: (i * 14).toDouble(),
                  child: Container(
                    width: 24.r,
                    height: 24.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: displayAvatars[i],
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[300],
                          child: Icon(Icons.person, size: 14.sp, color: Colors.grey[600]),
                        ),
                      ),
                    ),
                  ),
                ),
              // Extra space for the positioned elements
              SizedBox(width: (displayAvatars.length * 14).toDouble() + 10),
            ],
          ),
          if (remainingCount > 0)
            Container(
              transform: Matrix4.translationValues(-6, 0, 0),
              width: 24.r,
              height: 24.r,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: Text(
                '+$remainingCount',
                style: AppStyles.bodySmall.copyWith(
                  color: Colors.white,
                  fontSize: 8.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
