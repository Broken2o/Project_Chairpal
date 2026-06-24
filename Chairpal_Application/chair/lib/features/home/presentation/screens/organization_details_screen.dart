import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../l10n/l10n.dart';
import '../../domain/entities/place.dart';
import 'building_list_screen.dart';
import '../cubit/favorite_cubit/favorite_cubit.dart';
import '../widgets/detail_screen_widgets.dart';
import '../../../../core/di/injection_container.dart';

class OrganizationDetailsScreen extends StatefulWidget {
  final Place organization;

  const OrganizationDetailsScreen({
    super.key,
    required this.organization,
  });

  @override
  State<OrganizationDetailsScreen> createState() =>
      _OrganizationDetailsScreenState();
}

class _OrganizationDetailsScreenState
    extends State<OrganizationDetailsScreen> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context)!;
    final hasImage = widget.organization.imagePaths != null &&
        widget.organization.imagePaths!.isNotEmpty;
    final imageHeight = MediaQuery.of(context).size.height * 0.44;

    return BlocProvider(
      create: (_) => sl<FavoriteCubit>(),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: AppColors.background,
          body: Stack(
            children: [
              // ── Hero ────────────────────────────────────────────────────
              Positioned(
                top: 0, left: 0, right: 0, height: imageHeight,
                child: DetailHeroImage(
                  imagePaths: widget.organization.imagePaths,
                  currentPage: _currentPage,
                  onPageChanged: (i) => setState(() => _currentPage = i),
                  fallbackIcon: Icons.business,
                ),
              ),

              // ── Back + Favourite ─────────────────────────────────────────
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
                          ctx.read<FavoriteCubit>().toggleFavorite(
                              'organization', widget.organization.id);
                          setSt(() => widget.organization.isFavorite =
                              !widget.organization.isFavorite);
                        },
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (child, anim) =>
                              ScaleTransition(scale: anim, child: child),
                          child: Icon(
                            widget.organization.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border_rounded,
                            key: ValueKey<bool>(widget.organization.isFavorite),
                            color: widget.organization.isFavorite
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

              // ── Page indicator ───────────────────────────────────────────
              if (hasImage && widget.organization.imagePaths!.length > 1)
                Positioned(
                  top: imageHeight - 48,
                  left: 0, right: 0,
                  child: DetailPageIndicator(
                    count: widget.organization.imagePaths!.length,
                    current: _currentPage,
                  ),
                ),

              // ── Bottom sheet ─────────────────────────────────────────────
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
                                  rating: widget.organization.rating),
                              SizedBox(height: 10.h),
                              // Name
                              Text(widget.organization.name,
                                  style: AppStyles.h2PrimaryDark
                                      .copyWith(fontSize: 22.sp)),
                              SizedBox(height: 6.h),
                              // Address
                              if (widget.organization.address != null) ...[
                                Row(
                                  children: [
                                    Icon(Icons.location_on_outlined,
                                        color: AppColors.textSecondary,
                                        size: 16.sp),
                                    SizedBox(width: 4.w),
                                    Expanded(
                                      child: Text(widget.organization.address!,
                                          style: AppStyles.bodySmall.copyWith(
                                              color: AppColors.textSecondary)),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 14.h),
                              ],
                              // Category chip
                              if (widget.organization.category.isNotEmpty) ...[
                                DetailCategoryChip(
                                  icon: Icons.business,
                                  label: widget.organization.category,
                                ),
                                SizedBox(height: 20.h),
                              ],
                              // Description
                              if (widget.organization.description != null) ...[
                                DetailSectionLabel(label: l10n.about),
                                SizedBox(height: 8.h),
                                Text(widget.organization.description!,
                                    style: AppStyles.bodyMediumSecondary
                                        .copyWith(height: 1.6)),
                                SizedBox(height: 24.h),
                              ],
                              // Buildings row
                              DetailNavigationRow(
                                icon: Icons.apartment,
                                label: l10n.buildings,
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BuildingListScreen(
                                        organization: widget.organization),
                                  ),
                                ),
                              ),
                              SizedBox(height: 28.h),
                              const Divider(height: 1),
                              SizedBox(height: 20.h),
                              // Rate
                              DetailRateSection(
                                place: widget.organization,
                                rateType: 'organization',
                                title: l10n.rateThisPlace,
                              ),
                              SizedBox(height: 28.h),
                              const Divider(height: 1),
                              SizedBox(height: 20.h),
                              // Reviews
                              DetailReviewsSection(
                                reviews: widget.organization.reviews ?? [],
                                avgRating: widget.organization.rating,
                              ),
                              SizedBox(height: 24.h),
                            ],
                          ),
                        ),
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
