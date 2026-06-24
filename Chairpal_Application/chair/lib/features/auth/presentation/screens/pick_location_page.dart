import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';

import '../../../../l10n/l10n.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../core/theme/app_colors.dart';

class PickLocationPage extends StatefulWidget {
  const PickLocationPage({super.key});

  @override
  State<PickLocationPage> createState() => _PickLocationPageState();
}

class _PickLocationPageState extends State<PickLocationPage> {
  LatLng? selectedLocation;
  LatLng? currentLocation;
  String? selectedAddress;
  String? selectedCity;
  String? selectedCountry;
  bool isLoadingAddress = false;
  bool isSearching = false;
  List<Map<String, dynamic>> searchResults = [];
  final TextEditingController _searchController = TextEditingController();
  final MapController _mapController = MapController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _getAddressFromLatLng(LatLng latLng) async {
    setState(() {
      isLoadingAddress = true;
    });

    final l10n = S.of(context)!;
    try {
      final placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final parts = <String>[];
        if (place.street?.isNotEmpty ?? false) parts.add(place.street!);
        if (place.subLocality?.isNotEmpty ?? false) {
          parts.add(place.subLocality!);
        }
        if (place.locality?.isNotEmpty ?? false) parts.add(place.locality!);
        if (place.country?.isNotEmpty ?? false) parts.add(place.country!);

        selectedCity = place.locality;
        selectedCountry = place.country;
        selectedAddress = parts.isNotEmpty
            ? parts.join(', ')
            : l10n.unknownLocation;
      }
    } catch (e) {
      selectedAddress = l10n.unknownLocation;
    }

    setState(() {
      isLoadingAddress = false;
    });
  }

  Future<void> _searchLocation(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchResults = [];
        isSearching = false;
      });
      return;
    }

    setState(() {
      isSearching = true;
    });

    final l10n = S.of(context)!;
    try {
      final locations = await locationFromAddress(query);

      // Get detailed information for each location
      final detailedResults = <Map<String, dynamic>>[];
      for (var location in locations.take(5)) {
        try {
          final placemarks = await placemarkFromCoordinates(
            location.latitude,
            location.longitude,
          );

          if (placemarks.isNotEmpty) {
            final place = placemarks.first;
            final parts = <String>[];
            if (place.street?.isNotEmpty ?? false) parts.add(place.street!);
            if (place.locality?.isNotEmpty ?? false) parts.add(place.locality!);
            if (place.country?.isNotEmpty ?? false) parts.add(place.country!);

            detailedResults.add({
              'location': location,
              'address': parts.isNotEmpty
                  ? parts.join(', ')
                  : l10n.unknownLocation,
              'name': place.name ?? place.locality ?? l10n.location,
            });
          }
        } catch (e) {
          detailedResults.add({
            'location': location,
            'address':
                '${location.latitude.toStringAsFixed(4)}, ${location.longitude.toStringAsFixed(4)}',
            'name': l10n.location,
          });
        }
      }

      setState(() {
        searchResults = detailedResults;
        isSearching = false;
      });
    } catch (e) {
      setState(() {
        searchResults = [];
        isSearching = false;
      });
    }
  }

  void _selectSearchResult(Map<String, dynamic> result) {
    final location = result['location'] as Location;
    final latLng = LatLng(location.latitude, location.longitude);
    setState(() {
      selectedLocation = latLng;
      selectedAddress = result['address'] as String;
      searchResults = [];
      _searchController.clear();
      _searchFocusNode.unfocus();
    });

    // Animate to the selected location with zoom
    _mapController.move(latLng, 16);
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) return;

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );

    setState(() {
      currentLocation = LatLng(position.latitude, position.longitude);
    });
  }

  void _goToCurrentLocation() {
    if (currentLocation != null) {
      _mapController.move(currentLocation!, 15);
      setState(() {
        selectedLocation = currentLocation;
      });
      _getAddressFromLatLng(currentLocation!);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentLocation == null) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset:
          false, // Prevent map resizing when keyboard opens
      body: Stack(
        children: [
          // Map Layer
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: currentLocation!,
              initialZoom: 15,
              minZoom: 3,
              maxZoom: 18,
              onTap: (_, latLng) async {
                setState(() {
                  selectedLocation = latLng;
                  _searchFocusNode.unfocus();
                  searchResults = [];
                });
                await _getAddressFromLatLng(latLng);
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.chair_pal',
                tileBuilder: (context, widget, tile) {
                  return ColorFiltered(
                    colorFilter: const ColorFilter.matrix(<double>[
                      0.2126,
                      0.7152,
                      0.0722,
                      0,
                      0,
                      0.2126,
                      0.7152,
                      0.0722,
                      0,
                      0,
                      0.2126,
                      0.7152,
                      0.0722,
                      0,
                      0,
                      0,
                      0,
                      0,
                      1,
                      0,
                    ]),
                    child: widget,
                  );
                },
              ),
              if (selectedLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: selectedLocation!,
                      width: 50.w,
                      height: 50.h,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 50,
                      ),
                    ),
                  ],
                ),
            ],
          ),

          // Top Area: Back Button & Title
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 0.w,
            right: 0.w,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: [
                      // Back Button
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.arrow_back_ios,
                              size: 20,
                              color: AppColors.primaryDark,
                            ),
                            Text(
                              S.of(context)!.back,
                              style: AppStyles.bodyMedium.copyWith(
                                color: AppColors.primaryDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Centered Title
                      Expanded(
                        child: Text(
                          S.of(context)!.location,
                          textAlign: TextAlign.center,
                          style: AppStyles.h3.copyWith(
                            color: AppColors.primaryDark,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      SizedBox(width: 50.w), // Balance the row
                    ],
                  ),
                ),
                SizedBox(height: 16.h),

                // Search Bar
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      decoration: InputDecoration(
                        hintText: S.of(context)!.whatsYourLocation,
                        hintStyle: AppStyles.hint,
                        prefixIcon: const Icon(
                          Icons.search,
                          color: AppColors.primary,
                        ),
                        suffixIcon: const Icon(
                          Icons.location_on,
                          color: AppColors.primary,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 15.h,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {});
                        if (value.length > 2) {
                          _searchLocation(value);
                        }
                      },
                      onSubmitted: _searchLocation,
                    ),
                  ),
                ),

                // Search Results List
                if (searchResults.isNotEmpty)
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.r),
                      child: ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: searchResults.length,
                        separatorBuilder: (context, index) =>
                            Divider(height: 1.h),
                        itemBuilder: (context, index) {
                          final result = searchResults[index];
                          return ListTile(
                            title: Text(
                              result['name'],
                              style: AppStyles.bodyMedium,
                            ),
                            subtitle: Text(
                              result['address'],
                              style: AppStyles.caption,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () => _selectSearchResult(result),
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Bottom Area: My Location & Details Sheet
          Positioned(
            left: 0.w,
            right: 0.w,
            bottom: 0.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // My Location Button
                Padding(
                  padding: EdgeInsets.only(right: 16.w, bottom: 16.h),
                  child: FloatingActionButton(
                    onPressed: _goToCurrentLocation,
                    backgroundColor: Colors.white,
                    child: const Icon(
                      Icons.my_location,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ),

                // Details Bottom Sheet
                if (selectedLocation != null)
                  Container(
                    padding: EdgeInsets.all(24.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(32.r),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 20,
                          offset: Offset(0, -5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.near_me,
                              color: AppColors.primary,
                              size: 24,
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (isLoadingAddress)
                                    Text(
                                      S.of(context)!.loadingAddress,
                                      style: AppStyles.bodyMediumHint,
                                    )
                                  else ...[
                                    Text(
                                      selectedAddress ??
                                          S.of(context)!.unknownLocation,
                                      style: AppStyles.h4.copyWith(
                                        color: AppColors.primaryDark,
                                      ),
                                    ),
                                    // if (selectedAddress != null)
                                    //   Text(
                                    //     selectedAddress!,
                                    //     style: AppStyles.bodySmall.copyWith(color: Colors.grey),
                                    //   ),
                                  ],
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  selectedLocation = null;
                                  selectedAddress = null;
                                });
                              },
                              icon: const Icon(
                                Icons.close,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24.h),
                        SizedBox(
                          width: double.infinity,
                          height: 50.h,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context, {
                                'address': selectedAddress ?? '',
                                'latLng': selectedLocation,
                                'cityName': selectedCity ?? '',
                                'countryName': selectedCountry ?? '',
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary, // Teal color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            child: Text(
                              S.of(context)!.confirm,
                              style: AppStyles.button,
                            ),
                          ),
                        ),
                      ],
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
