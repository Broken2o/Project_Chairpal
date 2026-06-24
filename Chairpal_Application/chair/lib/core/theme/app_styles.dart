import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';
import '../constants/app_constants.dart';

/// App styles using Cairo font
class AppStyles {
  AppStyles._();

  // Headings
  static TextStyle h1 = TextStyle(
    fontFamily: kFontFamily,
    fontSize: 32.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle primaryBold = TextStyle(
    fontFamily: kFontFamily,
    fontSize: 22.sp,
    fontWeight: FontWeight.w800,
    color: AppColors.primary,
  );
  static TextStyle primaryDarkBold = TextStyle(
    fontFamily: kFontFamily,
    fontSize: 20.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryDark,
  );

  static TextStyle h2 = TextStyle(
    fontFamily: kFontFamily,
    fontSize: 24.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle h2PrimaryDark = h2.copyWith(color: AppColors.primaryDark);

  static TextStyle h3 = TextStyle(
    fontFamily: kFontFamily,
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle h3Primary = h3.copyWith(color: AppColors.primary);
  static TextStyle h3PrimaryDark = h3.copyWith(color: AppColors.primaryDark);
  static TextStyle h3Bold = h3.copyWith(fontWeight: FontWeight.bold);

  static TextStyle h4 = TextStyle(
    fontFamily: kFontFamily,
    fontSize: 18.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle h4Primary = h4.copyWith(color: AppColors.primary);
  static TextStyle h4PrimaryDark = h4.copyWith(color: AppColors.primaryDark);
  static TextStyle h4Bold = h4.copyWith(fontWeight: FontWeight.bold);

  // Body Text
  static TextStyle bodyLarge = TextStyle(
    fontFamily: kFontFamily,
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static TextStyle bodyMedium = TextStyle(
    fontFamily: kFontFamily,
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static TextStyle bodyMediumPrimaryDark = bodyMedium.copyWith(color: AppColors.primaryDark);
  static TextStyle bodyMediumBold = bodyMedium.copyWith(fontWeight: FontWeight.bold);
  static TextStyle bodyMediumBoldPrimaryDark = bodyMediumBold.copyWith(color: AppColors.primaryDark);
  static TextStyle bodyMediumSecondary = bodyMedium.copyWith(color: AppColors.textSecondary);
  static TextStyle bodyMediumPrimary = bodyMedium.copyWith(color: AppColors.primary);
  static TextStyle bodyMediumHint = bodyMedium.copyWith(color: AppColors.textHint);

  static TextStyle bodySmall = TextStyle(
    fontFamily: kFontFamily,
    fontSize: 12.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  static TextStyle bodySmallBold = bodySmall.copyWith(fontWeight: FontWeight.bold);
  static TextStyle bodySmallHint = bodySmall.copyWith(color: AppColors.textHint);

  // Button Text
  static TextStyle button = TextStyle(
    fontFamily: kFontFamily,
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textWhite,
  );

  static TextStyle buttonSmall = TextStyle(
    fontFamily: kFontFamily,
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textWhite,
  );

  static TextStyle buttonPrimary = buttonSmall.copyWith(color: AppColors.primary);

  // Caption & Labels
  static TextStyle caption = TextStyle(
    fontFamily: kFontFamily,
    fontSize: 12.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  static TextStyle label = TextStyle(
    fontFamily: kFontFamily,
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static TextStyle labelPrimaryDark = label.copyWith(color: AppColors.primaryDark);

  // Special Text Styles
  static TextStyle link = TextStyle(
    fontFamily: kFontFamily,
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
    decoration: TextDecoration.underline,
  );

  static TextStyle error = TextStyle(
    fontFamily: kFontFamily,
    fontSize: 12.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.error,
  );

  static TextStyle badge = TextStyle(
    fontFamily: kFontFamily,
    fontSize: 10.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textWhite,
  );

  static TextStyle hint = TextStyle(
    fontFamily: kFontFamily,
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    color: Colors.grey[400],
  );

  static TextStyle bodySmallGrey = TextStyle(
    fontFamily: kFontFamily,
    fontSize: 12.sp,
    fontWeight: FontWeight.normal,
    color: Colors.grey[500],
  );
}
