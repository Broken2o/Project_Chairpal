import 'package:chair_pal/features/home/presentation/screens/place_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../core/widgets/entity_card_large.dart';
import '../../domain/entities/place.dart';
import '../cubit/place_list_cubit/place_list_cubit.dart';
import '../cubit/place_list_cubit/place_list_state.dart';
import '../cubit/favorite_cubit/favorite_cubit.dart';
import 'add_place_screen.dart';
import '../../../../l10n/l10n.dart'; // We should have this from the old codebase, let's assume it exists
import 'package:chair_pal/core/widgets/custom_back_button.dart';

class PlaceListScreen extends StatefulWidget {
  final Place floor;

  const PlaceListScreen({super.key, required this.floor});

  @override
  State<PlaceListScreen> createState() => _PlaceListScreenState();
}

class _PlaceListScreenState extends State<PlaceListScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context)!;
    return BlocProvider(
      create: (context) => sl<PlaceListCubit>()..fetchPlaces(int.parse(widget.floor.id)),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          centerTitle: true,
          leadingWidth: 100.w,
          leading: const CustomBackButton(),
          title: Text(
            l10n.places,
            style: AppStyles.h3PrimaryDark.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        body: BlocBuilder<PlaceListCubit, PlaceListState>(
          builder: (context, state) {
            if (state is PlaceListLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PlaceListError) {
              return Center(child: Text(state.message, style: TextStyle(color: Colors.red, fontSize: 14.sp)));
            } else if (state is PlaceListLoaded) {
              final places = state.places;

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l10n.placesCount(places.length), style: AppStyles.h4PrimaryDark),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: context.read<PlaceListCubit>(),
                                  child: AddPlaceScreen(floor: widget.floor),
                                ),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              Icon(Icons.add, color: AppColors.primary, size: 20.sp),
                              SizedBox(width: 4.w),
                              Text(l10n.addNewPlace, style: AppStyles.bodyMediumBold.copyWith(color: AppColors.primary)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Expanded(
                      child: places.isEmpty
                          ? Center(
                              child: Text(
                                l10n.noPlacesFound,
                                style: AppStyles.bodyMediumSecondary,
                              ),
                            )
                          : ListView.builder(
                              itemCount: places.length,
                              itemBuilder: (context, index) {
                                final place = places[index];
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 16.h),
                                  child: EntityCardLarge(
                                    title: place.name,
                                    imageUrl: place.imagePaths?.isNotEmpty == true ? place.imagePaths!.first : null,
                                    distance: 'N/A',
                                    isFavorite: place.isFavorite,
                                    onFavoriteToggle: () {
                                      context.read<FavoriteCubit>().toggleFavorite('place', place.id);
                                      place.isFavorite = !place.isFavorite;
                                    },
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PlaceDetailsScreen(place: place, distance: 'N/A'),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
