import 'package:chair_pal/core/widgets/logo_image.dart';
import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        LogoImage(),
      ],
    );
  }
}
