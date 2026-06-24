import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/social_auth_button.dart';
import '../cubit/login_cubit/login_cubit.dart';

class SocialAuthRow extends StatelessWidget {
  const SocialAuthRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SocialAuthButton(
          provider: SocialAuthProvider.google,
          onPressed: () {
            context.read<LoginCubit>().socialLogin('google');
          },
        ),
        SizedBox(width: 16.w),
        SocialAuthButton(
          provider: SocialAuthProvider.facebook,
          onPressed: () {
            context.read<LoginCubit>().socialLogin('facebook');
          },
        ),
        SizedBox(width: 16.w),
        SocialAuthButton(
          provider: SocialAuthProvider.apple,
          onPressed: () {
            context.read<LoginCubit>().socialLogin('apple');
          },
        ),
      ],
    );
  }
}
