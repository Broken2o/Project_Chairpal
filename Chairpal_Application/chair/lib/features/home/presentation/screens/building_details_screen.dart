import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../l10n/l10n.dart';
import '../../domain/entities/place.dart';
import '../cubit/favorite_cubit/favorite_cubit.dart';
import '../widgets/detail_screen_widgets.dart';
import '../../../../core/di/injection_container.dart';
import 'floor_list_screen.dart';

class BuildingDetailsScreen extends StatefulWidget {
  final Place building;

  const BuildingDetailsScreen({super.key, required this.building});

  @override
  State<BuildingDetailsScreen> createState() => _BuildingDetailsScreenState();
}

class _BuildingDetailsScreenState extends State<BuildingDetailsScreen> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context)!;
    final imageHeight = MediaQuery.of(context).size.height * 0.44;
    final hasImage = widget.building.imagePaths != null &&
        widget.building.imagePaths!.isNotEmpty;

    return BlocProvider(
      create: (_) => sl<FavoriteCubit>(),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: AppColors.background,
          body: Stack(
            children: [
              // ── Hero ─────────────────────────────────────────────────────
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: imageHeight,
                child: DetailHeroImage(
                  imagePaths: widget.building.imagePaths,
                  currentPage: _currentPage,
                  onPageChanged: (i) => setState(() => _currentPage = i),
                  fallbackIcon: Icons.apartment,
                ),
              ),

              // ── Back + Favourite ──────────────────────────────────────────
              Positioned(
                top: MediaQuery.of(context).padding.top + 10,
                left: 16.w,
                right: 16.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DetailGlassButton(
                      onTap: () => Navigator.pop(context),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.chevron_left_rounded,
                              color: Colors.white, size: 22.sp),
                          SizedBox(width: 2.w),
                          Text(l10n.back,
                              style: AppStyles.bodyMedium.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600)),
                          SizedBox(width: 4.w),
                        ],
                      ),
                    ),
                    StatefulBuilder(
                      builder: (ctx, setSt) => DetailGlassButton(
                        onTap: () {
                          ctx
                              .read<FavoriteCubit>()
                              .toggleFavorite('building', widget.building.id);
                          setSt(() => widget.building.isFavorite =
                              !widget.building.isFavorite);
                        },
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (child, anim) =>
                              ScaleTransition(scale: anim, child: child),
                          child: Icon(
                            widget.building.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border_rounded,
                            key: ValueKey<bool>(widget.building.isFavorite),
                            color: widget.building.isFavorite
                                ? Colors.redAccent
                                : Colors.white,
                            size: 20.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Page indicator ────────────────────────────────────────────
              if (hasImage && widget.building.imagePaths!.length > 1)
                Positioned(
                  top: imageHeight - 48,
                  left: 0,
                  right: 0,
                  child: DetailPageIndicator(
                    count: widget.building.imagePaths!.length,
                    current: _currentPage,
                  ),
                ),

              // ── Bottom sheet ──────────────────────────────────────────────
              DraggableScrollableSheet(
                initialChildSize: 0.60,
                minChildSize: 0.60,
                maxChildSize: 0.96,
                builder: (_, scrollCtrl) => Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(28.r)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 24,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(28.r)),
                    child: ListView(
                      controller: scrollCtrl,
                      padding: EdgeInsets.zero,
                      children: [
                        const DetailDragHandle(),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Rating
                              DetailInlineRating(
                                  rating: widget.building.rating),
                              SizedBox(height: 10.h),
                              // Name
                              Text(widget.building.name,
                                  style: AppStyles.h2PrimaryDark
                                      .copyWith(fontSize: 22.sp)),
                              SizedBox(height: 6.h),
                              // Address
                              if (widget.building.address != null) ...[
                                Row(
                                  children: [
                                    Icon(Icons.location_on_outlined,
                                        color: AppColors.textSecondary,
                                        size: 16.sp),
                                    SizedBox(width: 4.w),
                                    Expanded(
                                      child: Text(widget.building.address!,
                                          style: AppStyles.bodySmall.copyWith(
                                              color: AppColors.textSecondary)),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 14.h),
                              ],
                              // Category chip
                              if (widget.building.category.isNotEmpty) ...[
                                DetailCategoryChip(
                                  icon: Icons.apartment,
                                  label: widget.building.category,
                                ),
                                SizedBox(height: 20.h),
                              ],
                              // Description
                              if (widget.building.description != null) ...[
                                DetailSectionLabel(label: l10n.aboutBuilding),
                                SizedBox(height: 8.h),
                                Text(widget.building.description!,
                                    style: AppStyles.bodyMediumSecondary
                                        .copyWith(height: 1.6)),
                                SizedBox(height: 24.h),
                              ],
                              // Floors row
                              DetailNavigationRow(
                                icon: Icons.layers,
                                label: l10n.floors,
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => FloorListScreen(
                                        building: widget.building),
                                  ),
                                ),
                              ),
                              SizedBox(height: 28.h),
                              const Divider(height: 1),
                              SizedBox(height: 20.h),
                              // Rate section
                              DetailRateSection(
                                place: widget.building,
                                rateType: 'building',
                                title: l10n.rateThisBuilding,
                              ),
                              SizedBox(height: 28.h),
                              const Divider(height: 1),
                              SizedBox(height: 20.h),
                              // Reviews
                              DetailReviewsSection(
                                reviews: widget.building.reviews ?? [],
                                avgRating: widget.building.rating,
                              ),
                              SizedBox(height: 24.h),
                            ],
                          ),
                        ),
                        // Start Navigation button
                        const DetailStartNavigationButton(),
                      ],
                    ),
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
