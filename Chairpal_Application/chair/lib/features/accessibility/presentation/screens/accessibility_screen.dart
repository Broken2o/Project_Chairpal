import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../l10n/l10n.dart';
import '../cubit/accessibility_cubit.dart';
import '../cubit/accessibility_state.dart';
import '../../data/repositories/ros_repository.dart';
import '../widgets/d_pad_control.dart';
import 'emergency_screen.dart';

class AccessibilityScreen extends StatefulWidget {
  const AccessibilityScreen({super.key});

  @override
  State<AccessibilityScreen> createState() => _AccessibilityScreenState();
}

class _AccessibilityScreenState extends State<AccessibilityScreen> {
  final String _rosUrl = 'wss://thirty-cats-hear.loca.lt';

  @override
  void initState() {
    super.initState();
    context.read<AccessibilityCubit>().connect(_rosUrl);
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;
    
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        leadingWidth: 100,
        title: Text(
          s.eChairTitle,
          style: AppStyles.h2PrimaryDark.copyWith(fontSize: 22),
        ),
        centerTitle: true,
        actions: [
          BlocBuilder<AccessibilityCubit, AccessibilityState>(
            builder: (context, state) {
              Color connectionColor = Colors.grey;
              if (state is AccessibilityStatusUpdate) {
                switch (state.status) {
                  case RosStatus.connected:
                    connectionColor = AppColors.success;
                    break;
                  case RosStatus.connecting:
                    connectionColor = AppColors.warning;
                    break;
                  case RosStatus.error:
                    connectionColor = AppColors.error;
                    break;
                  case RosStatus.disconnected:
                    connectionColor = AppColors.textHint;
                    break;
                }
              }
              return Container(
                margin: EdgeInsets.only(right: 16.w),
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: connectionColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: connectionColor.withValues(alpha: 0.4),
                      blurRadius: 4,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 16.h),
                Text(
                  s.eChairSubtitle,
                  textAlign: TextAlign.center,
                  style: AppStyles.bodyMediumSecondary.copyWith(
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 60.h),
                // Emergency Button
                SizedBox(
                  width: double.infinity,
                  height: 60.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const EmergencyScreen()));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.airport_shuttle_rounded, color: Colors.white, size: 28),
                        SizedBox(width: 12.w),
                        Text(
                          s.emergency,
                          style: AppStyles.bodyLarge.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 18.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 32.h),
                // Control Card
                // Control Card
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 40.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            s.controlEChair,
                            style: AppStyles.h3PrimaryDark.copyWith(fontSize: 18),
                          ),
                          SizedBox(height: 40.h),
                          DPadControl(
                            onForward: () => context.read<AccessibilityCubit>().moveForward(),
                            onBackward: () => context.read<AccessibilityCubit>().moveBackward(),
                            onLeft: () => context.read<AccessibilityCubit>().turnLeft(),
                            onRight: () => context.read<AccessibilityCubit>().turnRight(),
                            onStop: () => context.read<AccessibilityCubit>().stop(),
                          ),
                        ],
                      ),
                    ),
                    // Mascot
                    Positioned(
                      bottom: -60.h,
                      right: -26.w,
                      child: Image.asset(
                        Assets.char,
                        //width: 140,
                        height: 280.h,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 100.h), // Space for bottom padding
              ],
            ),
          ),
        ],
      ),
    );
  }
}

