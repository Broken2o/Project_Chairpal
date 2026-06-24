import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../core/widgets/custom_back_button.dart';
import '../../../../core/widgets/custom_popup_dialog.dart';
import '../../../../l10n/l10n.dart';
import '../../../connections/presentation/screens/companions_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  void _showHelpOnTheWayDialog(BuildContext context, S s) {
    showDialog(
      context: context,
      builder: (context) {
        return CustomPopupDialog(
          imagePath: Assets.imagesHelp,
          title: s.helpIsOnTheWay,
          bodyWidget: Text(
            s.emergencyAlertSent,
            textAlign: TextAlign.center,
            style: AppStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;
    
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        leadingWidth: 100,
        leading: const CustomBackButton(),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const CompanionsScreen()));
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    Assets.svgCompanions, 
                    colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn), 
                    width: 24.w,
                  ),
                  Text(
                    s.companions,
                    style: AppStyles.badge.copyWith(color: AppColors.primary),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              s.pressSOS,
              textAlign: TextAlign.center,
              style: AppStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
            ),
            SizedBox(height: 60.h),
            GestureDetector(
              onTap: () => _showHelpOnTheWayDialog(context, s),
              child: SvgPicture.asset(
                Assets.svgSosBtn,
                width: 250.w,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
