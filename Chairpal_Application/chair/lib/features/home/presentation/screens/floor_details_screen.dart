import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../domain/entities/place.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/favorite_cubit/favorite_cubit.dart';
import 'rate_app_screen.dart';
import 'place_list_screen.dart';
import '../../../../core/di/injection_container.dart';

class FloorDetailsScreen extends StatefulWidget {
  final Place floor;

  const FloorDetailsScreen({
    super.key,
    required this.floor,
  });

  @override
  State<FloorDetailsScreen> createState() => _FloorDetailsScreenState();
}

class _FloorDetailsScreenState extends State<FloorDetailsScreen> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context)!;
    final hasImage = widget.floor.imagePaths != null && widget.floor.imagePaths!.isNotEmpty;
    final imageHeight = MediaQuery.of(context).size.height * 0.46;

    return BlocProvider(
      create: (_) => sl<FavoriteCubit>(),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: AppColors.background,
        body: Stack(
          children: [
            // Hero Image
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: imageHeight,
              child: hasImage
                  ? Stack(
                      fit: StackFit.expand,
                      children: [
                        PageView.builder(
                          itemCount: widget.floor.imagePaths!.length,
                          onPageChanged: (i) => setState(() => _currentPage = i),
                          itemBuilder: (context, index) {
                            return CachedNetworkImage(
                              imageUrl: widget.floor.imagePaths![index],
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                        Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withValues(alpha: 0.4),
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.15),
                                ],
                                stops: const [0, 0.45, 1],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container(
                      color: AppColors.primary,
                      child: Icon(Icons.layers, color: Colors.white, size: 80.sp),
                    ),
            ),

            // Top Buttons
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              left: 16.w,
              right: 16.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildGlassButton(
                    onTap: () => Navigator.pop(context),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.chevron_left_rounded, color: Colors.white, size: 22.sp),
                        SizedBox(width: 2.w),
                        Text(
                          l10n.back,
                          style: AppStyles.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(width: 4.w),
                      ],
                    ),
                  ),
                  StatefulBuilder(
                    builder: (context, setState) {
                      return _buildGlassButton(
                        onTap: () {
                          context.read<FavoriteCubit>().toggleFavorite('floor', widget.floor.id);
                          setState(() {
                            widget.floor.isFavorite = !widget.floor.isFavorite;
                          });
                        },
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                          child: Icon(
                            widget.floor.isFavorite ? Icons.favorite : Icons.favorite_border_rounded,
                            key: ValueKey<bool>(widget.floor.isFavorite),
                            color: widget.floor.isFavorite ? Colors.redAccent : Colors.white,
                            size: 20.sp,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Indicator
            if (hasImage && widget.floor.imagePaths!.length > 1)
              Positioned(
                top: imageHeight - 48,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    widget.floor.imagePaths!.length,
                    (index) => Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      width: _currentPage == index ? 24.w : 8.w,
                      height: 8.h,
                      decoration: BoxDecoration(
                        color: _currentPage == index ? Colors.white : Colors.white.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ),
                ),
              ),

            // Draggable Sheet
            DraggableScrollableSheet(
              initialChildSize: 0.58,
              minChildSize: 0.58,
              maxChildSize: 0.95,
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 20,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 12.h),
                          Center(
                            child: Container(
                              width: 36.w,
                              height: 4.h,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(2.r),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title and distance
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        widget.floor.name,
                                        style: AppStyles.h2PrimaryDark.copyWith(fontSize: 24.sp),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.h),
                                // Rating
                                Row(
                                  children: [
                                    Icon(Icons.star, color: Colors.amber, size: 20.sp),
                                    SizedBox(width: 4.w),
                                    Text(
                                      widget.floor.rating.toStringAsFixed(1),
                                      style: AppStyles.bodyMediumBoldPrimaryDark,
                                    ),
                                    SizedBox(width: 8.w),
                                    Text('(8 reviews)', style: AppStyles.bodySmall), // Replace with actual review count when available
                                  ],
                                ),
                                SizedBox(height: 16.h),
                                // Description
                                if (widget.floor.description != null) ...[
                                  Text(l10n.aboutFloor, style: AppStyles.h4PrimaryDark),
                                  SizedBox(height: 8.h),
                                  Text(widget.floor.description!, style: AppStyles.bodyMediumSecondary),
                                  SizedBox(height: 24.h),
                                ],
                                // Places Box
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PlaceListScreen(floor: widget.floor),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(16.r),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
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
                                              child: Icon(Icons.place, color: AppColors.primary, size: 20.sp),
                                            ),
                                            SizedBox(width: 12.w),
                                            Text(l10n.places, style: AppStyles.bodyMediumBoldPrimaryDark),
                                          ],
                                        ),
                                        Icon(Icons.arrow_forward_ios, color: AppColors.textSecondary, size: 16.sp),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 32.h),
                                // Rate this place
                                Text(l10n.rateThisFloor, style: AppStyles.h4PrimaryDark),
                                SizedBox(height: 16.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(5, (index) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => RateAppScreen(
                                              place: widget.floor,
                                              initialRating: index + 1,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                                        child: Icon(Icons.star_border, color: Colors.grey.shade400, size: 40.sp),
                                      ),
                                    );
                                  }),
                                ),
                                SizedBox(height: 40.h),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildGlassButton({required VoidCallback onTap, required Widget child}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1),
        ),
        child: child,
      ),
    );
  }
}
