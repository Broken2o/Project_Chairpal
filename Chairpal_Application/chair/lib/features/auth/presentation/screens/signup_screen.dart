import 'package:chair_pal/core/widgets/custom_appbar.dart';
import 'package:chair_pal/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/l10n.dart';
import '../cubit/signup_cubit/signup_cubit.dart';
import '../cubit/signup_cubit/signup_state.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_navigation_link.dart';
import '../widgets/signup_form.dart';
import 'verification_screen.dart';
import 'package:chair_pal/core/widgets/custom_snackbar.dart';

class SignupScreen extends StatefulWidget {
  final String? role;
  final List<int>? medicalConditionIds;

  const SignupScreen({
    super.key,
    this.role,
    this.medicalConditionIds,
  });

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<SignupCubit>(),
      child: BlocListener<SignupCubit, SignupState>(
        listener: (context, state) {
          if (state.status == SignupStatus.success) {
            CustomSnackBar.showSuccess(context: context, message: state.successMessage ?? 'Account created successfully. Please verify your email.');
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => VerificationScreen(email: state.email ?? ''),
              ),
              (route) => false,
            );
          } else if (state.status == SignupStatus.error) {
            CustomSnackBar.showError(context: context, message: state.errorMessage ?? 'Unknown error');
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: CustomAppbar(),
            automaticallyImplyLeading: false,
          ),
          backgroundColor: AppColors.scaffoldBackground,
          body: SingleChildScrollView(
            padding: EdgeInsets.all(24.w),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AuthHeader(
                      title: widget.role == 'organization'
                          ? S.of(context)!.signupTitleOrg
                          : S.of(context)!.signupTitleUser,
                      subtitle: widget.role == 'organization'
                          ? S.of(context)!.signupSubtitleOrg
                          : S.of(context)!.signupSubtitleUser,
                    ),
                    SizedBox(height: 40.h),
                    SignupForm(
                      role: widget.role,
                      medicalConditionIds: widget.medicalConditionIds,
                    ),
                    SizedBox(height: 24.h),
                    Builder(
                      builder: (context) {
                        return AuthNavigationLink(
                          text: S.of(context)!.alreadyHaveAccount,
                          linkText: S.of(context)!.login,
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return const LoginScreen();
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                    SizedBox(height: 40.h),
                    // Row(
                    //   children: [
                    //     const Expanded(child: Divider()),
                    //     Padding(
                    //       padding: EdgeInsets.symmetric(horizontal: 16.w),
                    //       child: Text(
                    //         S.of(context)!.orContinueWith,
                    //         style: AppStyles.bodySmall,
                    //       ),
                    //     ),
                    //     const Expanded(child: Divider()),
                    //   ],
                    // ),
                    // SizedBox(height: 24.h),
                    // const SocialAuthRow(),
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
