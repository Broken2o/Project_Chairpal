import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';

class DPadControl extends StatelessWidget {
  final VoidCallback onForward;
  final VoidCallback onBackward;
  final VoidCallback onLeft;
  final VoidCallback onRight;
  final VoidCallback onStop;

  const DPadControl({
    super.key,
    required this.onForward,
    required this.onBackward,
    required this.onLeft,
    required this.onRight,
    required this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _DPadButton(
          icon: Icons.arrow_upward_rounded,
          onPressed: onForward,
          onReleased: onStop,
        ),
        SizedBox(height: 12.h),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _DPadButton(
              icon: Icons.arrow_back_rounded,
              onPressed: onLeft,
              onReleased: onStop,
            ),
            SizedBox(width: 12.w),
            _StopButton(onPressed: onStop),
            SizedBox(width: 12.w),
            _DPadButton(
              icon: Icons.arrow_forward_rounded,
              onPressed: onRight,
              onReleased: onStop,
            ),
          ],
        ),
        SizedBox(height: 12.h),
        _DPadButton(
          icon: Icons.arrow_downward_rounded,
          onPressed: onBackward,
          onReleased: onStop,
        ),
      ],
    );
  }
}

class _DPadButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final VoidCallback onReleased;

  const _DPadButton({
    required this.icon,
    required this.onPressed,
    required this.onReleased,
  });

  @override
  State<_DPadButton> createState() => _DPadButtonState();
}

class _DPadButtonState extends State<_DPadButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) {
        setState(() => _isPressed = true);
        widget.onPressed();
      },
      onPointerUp: (_) {
        setState(() => _isPressed = false);
        widget.onReleased();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: 65.w,
        height: 65.w,
        decoration: BoxDecoration(
          color: _isPressed ? AppColors.primary.withValues(alpha: 0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: AppColors.primaryDark.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Center(
          child: Icon(
            widget.icon,
            size: 28.sp,
            color: AppColors.primaryDark,
          ),
        ),
      ),
    );
  }
}

class _StopButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _StopButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 65.w,
        height: 65.w,
        decoration: BoxDecoration(
          color: const Color(0xFFFFEBEE), // very light red
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: const Color(0xFFFF5252), // red border
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            'Stop',
            style: AppStyles.bodyMedium.copyWith(
              color: const Color(0xFFFF5252),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
