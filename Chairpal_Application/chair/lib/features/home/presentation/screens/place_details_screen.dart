import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';

import '../../domain/entities/place.dart';
import '../../../../features/auth/presentation/cubit/user_cubit/user_cubit.dart';
import '../../../../features/auth/presentation/cubit/user_cubit/user_state.dart';
import '../cubit/edit_delete_cubit/edit_delete_cubit.dart';
import '../cubit/edit_delete_cubit/edit_delete_state.dart';
import '../cubit/favorite_cubit/favorite_cubit.dart';
import '../cubit/favorite_cubit/favorite_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/widgets/custom_snackbar.dart';
import 'add_place_screen.dart';
import '../widgets/place_utils.dart';
import '../widgets/rating_summary.dart';
import 'rate_app_screen.dart';
import 'location_screen.dart';
import 'package:chair_pal/core/widgets/custom_back_button.dart';
import '../../../../l10n/l10n.dart';

// ─────────────────────────────────────────────────────────
// Entry point widget
// ─────────────────────────────────────────────────────────
class PlaceDetailsScreen extends StatefulWidget {
  final Place place;
  final String distance;

  const PlaceDetailsScreen({
    super.key,
    required this.place,
    required this.distance,
  });

  @override
  State<PlaceDetailsScreen> createState() => _PlaceDetailsScreenState();
}

class _PlaceDetailsScreenState extends State<PlaceDetailsScreen> {
  int _currentPage = 0;

  bool _isOwner(BuildContext context) {
    final state = context.read<UserCubit>().state;
    if (state is UserLoaded) {
      return state.user.id == widget.place.owner?.id;
    }
    return false;
  }

  void _confirmDelete(BuildContext context) {
    final l10n = S.of(context)!;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 40.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.delete_outline_rounded, color: Colors.red, size: 28),
            ),
            SizedBox(height: 16.h),
            Text(
              l10n.delete,
              style: AppStyles.h2.copyWith(color: AppColors.primaryDark),
            ),
            SizedBox(height: 8.h),
            Text(
              "Are you sure you want to delete this place? This action cannot be undone.",
              textAlign: TextAlign.center,
              style: AppStyles.bodyMedium.copyWith(color: Colors.grey),
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    onPressed: () => Navigator.pop(ctx),
                    child: Text(l10n.cancel, style: AppStyles.bodyMedium.copyWith(color: Colors.grey.shade700, fontWeight: FontWeight.bold)),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.pop(ctx);
                      context.read<EditDeleteCubit>().deletePlace(int.parse(widget.place.id));
                    },
                    child: Text("Delete", style: AppStyles.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _edit(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddPlaceScreen(
          floor: Place(id: widget.place.owner?.id.toString() ?? "0", name: "Floor", latitude: 0, longitude: 0, category: "Floor"),
          placeToEdit: widget.place,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = widget.place.imagePaths != null &&
        widget.place.imagePaths!.isNotEmpty;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<EditDeleteCubit>()),
        BlocProvider(create: (_) => sl<FavoriteCubit>()),
      ],
      child: BlocListener<EditDeleteCubit, EditDeleteState>(
        listener: (context, state) {
          if (state is EditDeleteSuccess) {
            CustomSnackBar.showSuccess(
              context: context,
              message: "Deleted successfully",
            );
            Navigator.pop(context);
          } else if (state is EditDeleteError) {
            CustomSnackBar.showError(
              context: context,
              message: state.message,
            );
          }
        },
        child: hasImage
            ? _WithImageLayout(
                place: widget.place,
                distance: widget.distance,
                currentPage: _currentPage,
                onPageChanged: (i) => setState(() => _currentPage = i),
                isOwner: _isOwner(context),
                onEdit: () => _edit(context),
                onDelete: () => _confirmDelete(context),
              )
            : _NoImageLayout(
                place: widget.place,
                distance: widget.distance,
                isOwner: _isOwner(context),
                onEdit: () => _edit(context),
                onDelete: () => _confirmDelete(context),
              ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Layout A – with image gallery
// ─────────────────────────────────────────────────────────
class _WithImageLayout extends StatelessWidget {
  final Place place;
  final String distance;
  final int currentPage;
  final ValueChanged<int> onPageChanged;
  final bool isOwner;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _WithImageLayout({
    required this.place,
    required this.distance,
    required this.currentPage,
    required this.onPageChanged,
    required this.isOwner,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final imageHeight = MediaQuery.of(context).size.height * 0.46;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: const Color(0xFFF8F9FB),
        body: Stack(
          children: [
            // ── Hero gallery ─────────────────────────────
            Positioned(
              top: 0.h,
              left: 0.w,
              right: 0.w,
              height: imageHeight,
              child: _HeroGallery(
                place: place,
                currentPage: currentPage,
                onPageChanged: onPageChanged,
              ),
            ),

            // ── Floating action row ───────────────────────
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              left: 16.w,
              right: 16.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _GlassButton(
                    onTap: () => Navigator.pop(context),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.chevron_left_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Back',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 4.w),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      if (isOwner) ...[
                        _GlassButton(
                          onTap: onEdit,
                          child: const Icon(Icons.edit, color: Colors.white, size: 20),
                        ),
                        SizedBox(width: 8.w),
                        _GlassButton(
                          onTap: onDelete,
                          child: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                        ),
                        SizedBox(width: 8.w),
                      ],
                      StatefulBuilder(
                        builder: (context, setState) {
                          return BlocListener<FavoriteCubit, FavoriteState>(
                            listener: (context, state) {
                              // Optional: handle errors here to revert if needed
                            },
                            child: _GlassButton(
                              onTap: () {
                                print('PlaceDetailsScreen: Favorite tapped for place ${place.id}');
                                context.read<FavoriteCubit>().toggleFavorite('place', place.id);
                                setState(() {
                                  place.isFavorite = !place.isFavorite;
                                });
                              },
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                                child: Icon(
                                  place.isFavorite ? Icons.favorite : Icons.favorite_border_rounded,
                                  key: ValueKey<bool>(place.isFavorite),
                                  color: place.isFavorite ? Colors.redAccent : Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── Dot page indicator ────────────────────────
            if (place.imagePaths!.length > 1)
              Positioned(
                top: imageHeight - 48,
                left: 0.w,
                right: 0.w,
                child: _DotIndicator(
                  count: place.imagePaths!.length,
                  current: currentPage,
                ),
              ),

            // ── Draggable content sheet ───────────────────
            DraggableScrollableSheet(
              initialChildSize: 0.58,
              minChildSize: 0.58,
              maxChildSize: 0.95,
              builder: (context, scrollController) => _ContentSheet(
                place: place,
                distance: distance.toString(),
                scrollController: scrollController,
              ),
            ),
          ],
        ),

        floatingActionButton: _MapFab(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Layout B – no image
// ─────────────────────────────────────────────────────────
class _NoImageLayout extends StatelessWidget {
  final Place place;
  final String distance;
  final bool isOwner;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _NoImageLayout({
    required this.place, 
    required this.distance,
    required this.isOwner,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FB),
        body: CustomScrollView(
          slivers: [
            // ── Gradient app bar ──────────────────────────
            SliverAppBar(
              expandedHeight: 220,
              pinned: true,
              backgroundColor: AppColors.primary,
              automaticallyImplyLeading: false,
              leadingWidth: 100,
        leading: const CustomBackButton(),
              actions: [
                if (isOwner) ...[
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white, size: 20),
                    onPressed: onEdit,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                    onPressed: onDelete,
                  ),
                ],
                StatefulBuilder(
                  builder: (context, setState) {
                    return BlocListener<FavoriteCubit, FavoriteState>(
                      listener: (context, state) {
                        // Optional error handling
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 16.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                            child: Icon(
                              place.isFavorite ? Icons.favorite : Icons.favorite_border_rounded,
                              key: ValueKey<bool>(place.isFavorite),
                              color: place.isFavorite ? Colors.redAccent : Colors.white,
                              size: 20,
                            ),
                          ),
                          onPressed: () {
                            print('PlaceDetailsScreen: Favorite tapped for place ${place.id}');
                            context.read<FavoriteCubit>().toggleFavorite('place', place.id);
                            setState(() {
                              place.isFavorite = !place.isFavorite;
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                background: _NoImageHeroHeader(category: place.category),
                title: Text(
                  place.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    shadows: [
                      Shadow(
                        color: Colors.black38,
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),

            // ── Body ─────────────────────────────────────
            SliverToBoxAdapter(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF8F9FB),
                ),
                child: _DetailsBody(place: place, distance: distance),
              ),
            ),
          ],
        ),
        floatingActionButton: _MapFab(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Hero gallery (with-image)
// ─────────────────────────────────────────────────────────
class _HeroGallery extends StatelessWidget {
  final Place place;
  final int currentPage;
  final ValueChanged<int> onPageChanged;

  const _HeroGallery({
    required this.place,
    required this.currentPage,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        PageView.builder(
          itemCount: place.imagePaths!.length,
          onPageChanged: onPageChanged,
          itemBuilder: (context, index) {
            return Image.network(
              place.imagePaths![index],
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  _CategoryHeroPlaceholder(category: place.category),
            );
          },
        ),
        // Bottom-to-top gradient for sheet readability
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
    );
  }
}

// ─────────────────────────────────────────────────────────
// Draggable content sheet (with-image layout)
// ─────────────────────────────────────────────────────────
class _ContentSheet extends StatelessWidget {
  final Place place;
  final String distance;
  final ScrollController scrollController;

  const _ContentSheet({
    required this.place,
    required this.distance,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Color(0xFFF8F9FB),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        boxShadow: [
          BoxShadow(
            color: Color(0x18000000),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              SizedBox(height: 12.h),
              // Pill handle
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 20.h),
              _DetailsBody(place: place, distance: distance),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// All detail content (shared between both layouts)
// ─────────────────────────────────────────────────────────
class _DetailsBody extends StatelessWidget {
  final Place place;
  final String distance;

  const _DetailsBody({required this.place, required this.distance});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 110),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Title block ────────────────────────────────
          _TitleBlock(place: place, distance: distance),
          SizedBox(height: 16.h),

          // ── Quick-info tiles ───────────────────────────
          if (place.openingHours != null ||
              place.phone != null ||
              place.website != null) ...[
            _QuickInfoGrid(place: place),
            SizedBox(height: 20.h),
          ],

          // ── Description ────────────────────────────────
          _SectionLabel(label: 'About this place'),
          SizedBox(height: 10.h),
          _ExpandableDescription(
            text: place.description ??
                'No description available for this location.',
          ),
          SizedBox(height: 28.h),

          // ── Rate this place ──────────────────────────────
          _RateSection(place: place),
          SizedBox(height: 28.h),

          // ── Reviews ────────────────────────────────────
          _ReviewsSection(place: place),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Title block: name, rating, category, address
// ─────────────────────────────────────────────────────────
class _TitleBlock extends StatelessWidget {
  final Place place;
  final String distance;

  const _TitleBlock({required this.place, required this.distance});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category + distance row
        Row(
          children: [
            _Chip(
              label: PlaceUtils.formatCategory(place.category),
              color: AppColors.primary,
              textColor: AppColors.primary,
            ),
            const Spacer(),
            const Icon(
              Icons.near_me_rounded,
              size: 14,
              color: AppColors.textSecondary,
            ),
            SizedBox(width: 4.w),
            Text(
              distance,
              style: AppStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),

        // Name
        Text(
          place.name,
          style: AppStyles.h1.copyWith(
            fontSize: 24,
            color: const Color(0xFF1A2340),
            height: 1.2,
          ),
        ),
        SizedBox(height: 10.h),

        // Stars + address
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stars
            if (place.rating > 0)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ...List.generate(5, (i) => Icon(
                            i < place.rating.floor()
                                ? Icons.star_rounded
                                : i < place.rating
                                    ? Icons.star_half_rounded
                                    : Icons.star_border_rounded,
                            color: const Color(0xFFF5A623),
                            size: 18,
                          )),
                      SizedBox(width: 6.w),
                      Text(
                        place.rating.toStringAsFixed(1),
                        style: AppStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A2340),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

            const Spacer(),

            // Address chip
            if (place.address != null && place.address!.isNotEmpty)
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.place_rounded,
                      size: 14,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: 4.w),
                    Flexible(
                      child: Text(
                        place.address!,
                        style: AppStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────
// Quick info tiles (hours, phone, website)
// ─────────────────────────────────────────────────────────
class _QuickInfoGrid extends StatelessWidget {
  final Place place;

  const _QuickInfoGrid({required this.place});

  @override
  Widget build(BuildContext context) {
    final items = <_InfoTileData>[];

    if (place.openingHours != null) {
      items.add(_InfoTileData(
        icon: Icons.schedule_rounded,
        title: 'Hours',
        value: place.openingHours!,
        color: const Color(0xFF2ECC71),
      ));
    }
    if (place.phone != null) {
      items.add(_InfoTileData(
        icon: Icons.phone_rounded,
        title: 'Phone',
        value: '\u202A${place.phone!}\u202C',
        color: AppColors.primary,
      ));
    }
    if (place.website != null) {
      items.add(_InfoTileData(
        icon: Icons.language_rounded,
        title: 'Website',
        value: place.website!,
        color: const Color(0xFF3B82F6),
      ));
    }

    if (items.isEmpty) return SizedBox.shrink();

    return Column(
      children: items.map((item) => _InfoTile(data: item)).toList(),
    );
  }
}

class _InfoTileData {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _InfoTileData({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });
}

class _InfoTile extends StatelessWidget {
  final _InfoTileData data;

  const _InfoTile({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: data.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(data.icon, size: 20, color: data.color),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: AppStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  data.value,
                  style: AppStyles.bodyMedium.copyWith(
                    color: const Color(0xFF1A2340),
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            size: 18,
            color: Colors.grey.shade300,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Expandable description
// ─────────────────────────────────────────────────────────
class _ExpandableDescription extends StatefulWidget {
  final String text;

  const _ExpandableDescription({required this.text});

  @override
  State<_ExpandableDescription> createState() =>
      _ExpandableDescriptionState();
}

class _ExpandableDescriptionState extends State<_ExpandableDescription> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 250),
          crossFadeState: _expanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          firstChild: Text(
            widget.text,
            style: AppStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.65,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          secondChild: Text(
            widget.text,
            style: AppStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.65,
            ),
          ),
        ),
        if (widget.text.length > 150)
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: EdgeInsets.only(top: 6.h),
              child: Text(
                _expanded ? 'Show less' : 'Read more',
                style: AppStyles.bodySmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────
// Rate this place
// ─────────────────────────────────────────────────────────
class _RateSection extends StatefulWidget {
  final Place place;

  const _RateSection({required this.place});

  @override
  State<_RateSection> createState() => _RateSectionState();
}

class _RateSectionState extends State<_RateSection> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: const Icon(
                  Icons.star_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                'Rate this place',
                style: AppStyles.h3.copyWith(fontSize: 16),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final filled = index < _selected;
              return GestureDetector(
                onTap: () => setState(() => _selected = index + 1),
                child: AnimatedScale(
                  scale: filled ? 1.15 : 1.0,
                  duration: const Duration(milliseconds: 150),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Icon(
                      filled
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      size: 36,
                      color: filled
                          ? const Color(0xFFF5A623)
                          : Colors.grey.shade300,
                    ),
                  ),
                ),
              );
            }),
          ),
          SizedBox(height: 14.h),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  side: BorderSide(
                    color: AppColors.primary.withValues(alpha: 0.3),
                  ),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RateAppScreen(
                      place: widget.place,
                      initialRating: _selected,
                    ),
                  ),
                );
              },
              child: Text(
                'Write a review',
                style: AppStyles.bodySmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Reviews section
// ─────────────────────────────────────────────────────────
class _ReviewsSection extends StatelessWidget {
  final Place place;

  const _ReviewsSection({required this.place});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _SectionLabel(label: 'Reviews'),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'View all',
                style: AppStyles.bodySmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 14.h),

        if (place.rating > 0) ...[
          // Rating summary card
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x08000000),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: RatingSummary(
              averageRating: place.rating,
              totalReviews: (place.rating * 10).toInt() + 5,
              ratingDistribution: const {
                5: 0.7,
                4: 0.2,
                3: 0.07,
                2: 0.02,
                1: 0.01,
              },
            ),
          ),
          SizedBox(height: 16.h),

          // Review cards
          const _ReviewCard(
            name: 'Sara Salem',
            initials: 'SS',
            avatarColor: Color(0xFF14908E),
            rating: 5,
            comment:
                'Amazing place! The view is stunning and the atmosphere is great. Would definitely come back.',
            date: '2 days ago',
          ),
          const _ReviewCard(
            name: 'John Doe',
            initials: 'JD',
            avatarColor: Color(0xFF26525B),
            rating: 4,
            comment:
                'Good experience overall, but a bit crowded during weekends. Still worth a visit!',
            date: '1 week ago',
          ),
        ] else
          _EmptyReviews(),
      ],
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final String name;
  final String initials;
  final Color avatarColor;
  final int rating;
  final String comment;
  final String date;

  const _ReviewCard({
    required this.name,
    required this.initials,
    required this.avatarColor,
    required this.rating,
    required this.comment,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Avatar
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: avatarColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A2340),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        ...List.generate(
                          5,
                          (i) => Icon(
                            i < rating
                                ? Icons.star_rounded
                                : Icons.star_border_rounded,
                            size: 13,
                            color: const Color(0xFFF5A623),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                date,
                style: AppStyles.bodySmall.copyWith(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            comment,
            style: AppStyles.bodySmall.copyWith(
              color: const Color(0xFF4A5568),
              height: 1.55,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyReviews extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 32.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.rate_review_outlined,
            size: 52,
            color: Colors.grey.shade300,
          ),
          SizedBox(height: 12.h),
          Text(
            'No reviews yet',
            style: AppStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A2340),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Be the first to leave a review for this place.',
            textAlign: TextAlign.center,
            style: AppStyles.bodySmall.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Small reusable widgets
// ─────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          label,
          style: AppStyles.h3.copyWith(
            fontSize: 17,
            color: const Color(0xFF1A2340),
          ),
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;

  const _Chip({
    required this.label,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        label,
        style: AppStyles.bodySmall.copyWith(
          color: textColor,
          fontWeight: FontWeight.w700,
          fontSize: 11,
        ),
      ),
    );
  }
}

/// Frosted-glass button overlay (for image layout).
class _GlassButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;

  const _GlassButton({required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 9.h),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.38),
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
          ),
        ),
        child: child,
      ),
    );
  }
}

class _DotIndicator extends StatelessWidget {
  final int count;
  final int current;

  const _DotIndicator({required this.count, required this.current});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: EdgeInsets.symmetric(horizontal: 3.w),
          width: active ? 20 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.white.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(3.r),
          ),
        );
      }),
    );
  }
}

class _MapFab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LocationScreen(),
          ),
        );
      },
      backgroundColor: AppColors.primary,
      icon: const Icon(Icons.map_outlined, color: Colors.white, size: 20),
      label: const Text(
        'View on map',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// No-image hero header visuals
// ─────────────────────────────────────────────────────────
class _NoImageHeroHeader extends StatelessWidget {
  final String category;

  const _NoImageHeroHeader({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF0D6E6C),
            AppColors.primary,
            AppColors.primaryLight,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Large background icon watermark
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(
              PlaceUtils.iconForCategory(category),
              size: 160,
              color: Colors.white.withValues(alpha: 0.08),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    PlaceUtils.iconForCategory(category),
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryHeroPlaceholder extends StatelessWidget {
  final String category;

  const _CategoryHeroPlaceholder({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryDark, AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Icon(
        PlaceUtils.iconForCategory(category),
        size: 72,
        color: Colors.white.withValues(alpha: 0.4),
      ),
    );
  }
}