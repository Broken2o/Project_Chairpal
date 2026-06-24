import 'package:flutter/material.dart';
import '../localization/localization_constants.dart';
import '../constants/assets.dart';

class LogoImage extends StatelessWidget {
  const LogoImage({super.key, this.color, this.height});
  final Color? color;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.center,
      transform: isArabic()? Matrix4.rotationY(3.14159):Matrix4.rotationY(0) ,
      child: Image.asset(
        Assets.imagesLogo,
        height: height?? 40,
        //color: color ?? AppColors.primary,
        //colorBlendMode: BlendMode.srcIn,
      ),
    );
  }
}
