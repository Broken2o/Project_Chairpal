import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_empty_state.dart';
import '../../../../core/widgets/custom_error_state.dart';
import '../../../../l10n/l10n.dart';
import '../../domain/entities/category.dart';
import '../cubit/category_details_cubit/category_details_cubit.dart';
import '../cubit/category_details_cubit/category_details_state.dart';
import '../cubit/favorite_cubit/favorite_cubit.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/widgets/entity_card_large.dart';
import 'add_organization_screen.dart';
import 'organization_details_screen.dart';
import 'package:chair_pal/core/widgets/custom_back_button.dart';

class CategoryDetailsScreen extends StatefulWidget {
  final Category category;

  const CategoryDetailsScreen({super.key, required this.category});

  @override
  State<CategoryDetailsScreen> createState() => _CategoryDetailsScreenState();
}

class _CategoryDetailsScreenState extends State<CategoryDetailsScreen> {
  final TextEditingController _searchController = TextEditingController();
  Position? _userPosition;

  @override
  void initState() {
    super.initState();
    context.read<CategoryDetailsCubit>().fetchCategoryDetails(widget.category.id);
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }
      if (permission == LocationPermission.deniedForever) return;
      Position position = await Geolocator.getCurrentPosition();
      if (mounted) {
        setState(() {
          _userPosition = position;
        });
      }
    } catch (e) {
      // Ignore location errors silently
    }
  }

  String _formatDistance(double? meters, S l10n) {
    if (meters == null) return l10n.unknownDistance;
    if (meters >= 1000) {
      return '${(meters / 1000).toStringAsFixed(0)}km';
    }
    return '${meters.round()}m';
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context)!;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leadingWidth: 100.w,
        leading: const CustomBackButton(),
        title: Text(
          widget.category.name,
          style: AppStyles.h3PrimaryDark.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocProvider(
        create: (_) => sl<FavoriteCubit>(),
        child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),
            CustomTextField(
              controller: _searchController,
              hintText: l10n.search,
              prefixIcon: Icon(Icons.search, color: AppColors.textSecondary, size: 24.sp),
            ),
            SizedBox(height: 24.h),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (innerContext) => BlocProvider.value(
                      value: context.read<CategoryDetailsCubit>(),
                      child: AddOrganizationScreen(category: widget.category),
                    ),
                  ),
                );
              },
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.add, color: Colors.white, size: 20.sp),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    l10n.addNewOrganization,
                    style: AppStyles.bodyMedium.copyWith(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            Expanded(
              child: BlocBuilder<CategoryDetailsCubit, CategoryDetailsState>(
                builder: (context, state) {
                  if (state is CategoryDetailsLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is CategoryDetailsError) {
                    return CustomErrorState(
                      title: l10n.oops,
                      message: state.message,
                      onRetry: () => context.read<CategoryDetailsCubit>().fetchCategoryDetails(widget.category.id),
                    );
                  } else if (state is CategoryDetailsLoaded) {
                    final orgs = state.category.organizations ?? [];
                    
                    if (orgs.isEmpty) {
                      return CustomEmptyState(
                        title: l10n.noOrganizationsYet,
                        subtitle: l10n.noOrganizationsYetDesc,
                        icon: Icons.business, // A fallback icon if no specific error image
                        // Replace with an imagePath if you have a specific asset for this
                      );
                    }
                    
                    return ListView.separated(
                      padding: EdgeInsets.only(bottom: 24.h),
                      itemCount: orgs.length,
                      separatorBuilder: (context, index) => SizedBox(height: 16.h),
                      itemBuilder: (context, index) {
                        final org = orgs[index];
                        final distanceStr = _formatDistance(
                          _userPosition != null
                              ? Geolocator.distanceBetween(
                                  _userPosition!.latitude,
                                  _userPosition!.longitude,
                                  org.latitude,
                                  org.longitude,
                                )
                              : null,
                          l10n,
                        );
                        
                        return EntityCardLarge(
                          imageUrl: org.imagePaths?.isNotEmpty == true ? org.imagePaths!.first : null,
                          title: org.name,
                          distance: distanceStr,
                          isFavorite: org.isFavorite,
                          onFavoriteToggle: () {
                            context.read<FavoriteCubit>().toggleFavorite('organization', org.id);
                            org.isFavorite = !org.isFavorite;
                          },
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OrganizationDetailsScreen(organization: org),
                              ),
                            );
                          },
                        );
                      },
                    );
                  }
                  
                  return SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}
