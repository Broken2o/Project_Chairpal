import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../features/auth/presentation/cubit/user_cubit/user_cubit.dart';
import '../../../../features/auth/presentation/cubit/user_cubit/user_state.dart';
import '../../../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../../../l10n/l10n.dart';

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({super.key});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  String? _deviceLocation;

  @override
  void initState() {
    super.initState();
    _fetchDeviceLocation();
  }

  Future<void> _fetchDeviceLocation() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.whileInUse || 
          permission == LocationPermission.always) {
        
        final position = await Geolocator.getLastKnownPosition() ?? 
                         await Geolocator.getCurrentPosition(locationSettings: const LocationSettings(accuracy: LocationAccuracy.low));
        
        final placemarks = await placemarkFromCoordinates(
          position.latitude, 
          position.longitude
        );
        
        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          final locality = place.locality ?? place.subAdministrativeArea ?? place.administrativeArea;
          if (locality != null && mounted) {
            setState(() {
              _deviceLocation = locality;
            });
          }
        }
      }
    } catch (e) {
      // Silently fallback if location fetch fails
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            String name = 'User';
            String location = _deviceLocation ?? l10n.locationNotSet;

            if (state is UserLoaded) {
              name = state.user.name;
              if (state.user.location != null && state.user.location!.isNotEmpty) {
                location = state.user.location!;
              } else {
                location = _deviceLocation ?? l10n.locationNotSet;
              }
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.hiUser(name),
                  style: AppStyles.h2.copyWith(fontSize: 20),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      location,
                      style: AppStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
        Stack(
          children: [
             Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.1),
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationsScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.notifications_none_rounded),
                color: AppColors.textPrimary,
              ),
            ),
            Positioned(
              right: 12.w,
              top: 12.h,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.primaryLight, // Assuming orange/red attention color
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
