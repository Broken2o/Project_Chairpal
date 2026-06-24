import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../features/auth/presentation/cubit/user_cubit/user_cubit.dart';
import '../../../../features/auth/presentation/cubit/user_cubit/user_state.dart';
import '../../../../l10n/l10n.dart';
import '../../../../features/notifications/presentation/screens/notifications_screen.dart';

class HomeTealHeader extends StatefulWidget {
  const HomeTealHeader({super.key});

  @override
  State<HomeTealHeader> createState() => _HomeTealHeaderState();
}

class _HomeTealHeaderState extends State<HomeTealHeader> with WidgetsBindingObserver {
  String? _deviceLocation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _fetchDeviceLocation();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _deviceLocation == null) {
      _fetchDeviceLocation();
    }
  }

  Future<void> _fetchDeviceLocation() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        final position = await Geolocator.getLastKnownPosition() ??
            await Geolocator.getCurrentPosition(
                locationSettings: const LocationSettings(accuracy: LocationAccuracy.low));

        final placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

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
      // Silently fallback
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context)!;
    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 40.h, 24.w, 50.h), // Extra bottom padding for overlap
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(40.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<UserCubit, UserState>(
            builder: (context, state) {
              String location = _deviceLocation ?? l10n.locationNotSet;
              String name = "User";
              if (state is UserLoaded) {
                if (state.user.location != null && state.user.location!.isNotEmpty) {
                  location = state.user.location!;
                }
                name = state.user.name;
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.greeting(name),
                    style: AppStyles.h2.copyWith(
                      color: Colors.white,
                      fontSize: 24.sp,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.white, size: 16),
                      SizedBox(width: 4.w),
                      Text(
                        location,
                        style: AppStyles.bodyMedium.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsScreen(),
                ),
              );
            },
            child: Container(
              width: 44.w,
              height: 44.w,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(Icons.notifications_none_rounded, color: AppColors.textPrimary, size: 24.w),
                  Positioned(
                    top: 10.h,
                    right: 12.w,
                    child: Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: const BoxDecoration(
                        color: Colors.deepOrange,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
