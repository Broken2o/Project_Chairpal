import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../generated/app_colors.dart';
import '../../l10n/l10n.dart';
import '../theme/app_styles.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback? onTap;

  const CustomBackButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;

    return GestureDetector(
      onTap: onTap ?? () => Navigator.pop(context),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.arrow_back_ios, size: 15.w, color: AppColors.textDark,),
              Text(s.back,
                style: AppStyles.bodyMediumPrimaryDark,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
