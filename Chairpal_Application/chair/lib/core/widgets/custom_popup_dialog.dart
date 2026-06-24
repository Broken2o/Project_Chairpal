import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';
import '../theme/app_styles.dart';
import 'custom_button.dart';

class CustomPopupDialog extends StatelessWidget {
  final String imagePath;
  final String title;
  final Widget? bodyWidget;
  final String? primaryButtonText;
  final IconData? primaryButtonIcon;
  final VoidCallback? onPrimaryPressed;
  final String? secondaryButtonText;
  final IconData? secondaryButtonIcon;
  final VoidCallback? onSecondaryPressed;

  const CustomPopupDialog({
    super.key,
    required this.imagePath,
    required this.title,
    this.bodyWidget,
    this.primaryButtonText,
    this.primaryButtonIcon,
    this.onPrimaryPressed,
    this.secondaryButtonText,
    this.secondaryButtonIcon,
    this.onSecondaryPressed,
  });

  @override
  Widget build(BuildContext context) {
    final hasButtons = (primaryButtonText != null && onPrimaryPressed != null) ||
        (secondaryButtonText != null && onSecondaryPressed != null);

    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFF27B50), width: 2),
                  ),
                  padding: EdgeInsets.all(4.w),
                  child: Icon(Icons.close, color: const Color(0xFFF27B50), size: 20.sp),
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Image.asset(imagePath, height: 160.h),
            SizedBox(height: 24.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppStyles.h3.copyWith(color: AppColors.primaryDark, fontWeight: FontWeight.bold),
            ),
            if (bodyWidget != null) ...[
              SizedBox(height: 12.h),
              bodyWidget!,
            ],
            if (hasButtons) ...[
              SizedBox(height: 24.h),
              Row(
                children: [
                  if (primaryButtonText != null && onPrimaryPressed != null)
                    Expanded(
                      child: CustomButton(
                        text: primaryButtonText!,
                        icon: primaryButtonIcon,
                        onPressed: onPrimaryPressed,
                      ),
                    ),
                  if (primaryButtonText != null && secondaryButtonText != null)
                    SizedBox(width: 16.w),
                  if (secondaryButtonText != null && onSecondaryPressed != null)
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFF27B50)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                        ),
                        onPressed: onSecondaryPressed,
                        icon: secondaryButtonIcon != null
                            ? Icon(secondaryButtonIcon, color: const Color(0xFFF27B50))
                            : const SizedBox.shrink(),
                        label: Text(
                          secondaryButtonText!,
                          style: AppStyles.h4.copyWith(color: const Color(0xFFF27B50)),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
