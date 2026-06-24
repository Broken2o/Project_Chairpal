import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  // Mock Coordinates
  final LatLng _userLocation = const LatLng(31.4175, 31.8144); // Damietta
  final LatLng _placeLocation = const LatLng(31.4250, 31.8200); // Nearby

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Flutter Map
          FlutterMap(
            options: MapOptions(
              initialCenter: _userLocation,
              initialZoom: 15.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.chair_pal',
                 tileBuilder: (context, widget, tile) {
                  return ColorFiltered(
                    colorFilter: const ColorFilter.matrix(<double>[
                      0.2126, 0.7152, 0.0722, 0, 0,
                      0.2126, 0.7152, 0.0722, 0, 0,
                      0.2126, 0.7152, 0.0722, 0, 0,
                      0,      0,      0,      1, 0,
                    ]),
                    child: widget,
                  );
                },
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: [_userLocation, _placeLocation],
                    strokeWidth: 4.0,
                    color: AppColors.primary,
                  ),
                ],
              ),
              MarkerLayer(
                markers: [
                  // User Marker
                  Marker(
                    point: _userLocation,
                    width: 40,
                    height: 40,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.accessibility_new,
                        color: Colors.orange,
                        size: 24,
                      ),
                    ),
                  ),
                  // Place Marker
                  Marker(
                    point: _placeLocation,
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Back Button
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16.w,
            child: SafeArea(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(8.r),
                    boxShadow: [
                       BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                      )
                    ]
                  ),
                  child: Row(
                    children: const [
                       Icon(Icons.arrow_back_ios, color: AppColors.primaryDark, size: 16),
                       Text('Back', style: TextStyle(color: AppColors.primaryDark, fontSize: 16)),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Location Header Mock
          Positioned(
            top: MediaQuery.of(context).padding.top + 20,
            left: 0.w,
            right: 0.w,
            child: const Center(
              child: Text(
                'Location',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 3.0,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),


          // Bottom Sheet Information
          Positioned(
            left: 0.w,
            right: 0.w,
            bottom: 0.h,
            child: Container(
              padding: EdgeInsets.all(24.r),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
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
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    margin: EdgeInsets.only(bottom: 24.h),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                  Text(
                    '10 minutes left',
                    style: AppStyles.h2.copyWith(color: AppColors.primaryDark),
                  ),
                  SizedBox(height: 8.h),
                   Text(
                    'Arrive to Faculty of Engineering, Damietta University',
                    textAlign: TextAlign.center,
                    style: AppStyles.bodySmall.copyWith(color: Colors.grey),
                  ),
                  SizedBox(height: 24.h),
                  
                  // Progress Bar Mock
                  Row(
                    children: [
                      Expanded(child: _buildProgressSegment(true)),
                      SizedBox(width: 4.w),
                       Expanded(child: _buildProgressSegment(true)),
                      SizedBox(width: 4.w),
                       Expanded(child: _buildProgressSegment(true)),
                      SizedBox(width: 4.w),
                       Expanded(child: _buildProgressSegment(false)),
                    ],
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSegment(bool isActive) {
    return Container(
      height: 6,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : Colors.grey[200],
        borderRadius: BorderRadius.circular(3.r),
      ),
    );
  }
}