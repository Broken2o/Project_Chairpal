import 'package:chair_pal/core/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/l10n.dart';
import '../cubit/login_cubit/login_cubit.dart';
import '../cubit/login_cubit/login_state.dart';
import '../cubit/user_cubit/user_cubit.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_navigation_link.dart';
import '../widgets/login_form.dart';
import '../../../home/presentation/screens/home_screen.dart';
import 'role_selection_screen.dart';
import '../../../admin/presentation/screens/admin_main_screen.dart';
import 'verification_screen.dart';
import 'package:chair_pal/core/widgets/custom_snackbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
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

  void _navigateToDashboard(bool isOrganization) {
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            isOrganization ? const AdminMainScreen() : const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<LoginCubit>(),
      child: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state.status == LoginStatus.success) {
            // Refresh user profile after successful login
            context.read<UserCubit>().loadUser();

            CustomSnackBar.showSuccess(context: context, message: S.of(context)!.loggedInSuccess);
            _navigateToDashboard(state.role == 'organization');
          } else if (state.status == LoginStatus.error) {
            CustomSnackBar.showError(context: context, message: state.errorMessage ?? 'Unknown error');

            final errorStr = state.errorMessage?.toLowerCase() ?? '';
            if (errorStr.contains('verify') || errorStr.contains('otp')) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => VerificationScreen(
                    email: state.email ?? '',
                    autoSendOtp: true,
                  ),
                ),
              );
            }
          }
        },
        child: Scaffold(
          appBar: AppBar(title: CustomAppbar()),
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
                      title: S.of(context)!.loginScreenTitle,
                      subtitle: S.of(context)!.loginScreenSubtitle,
                    ),
                    SizedBox(height: 40.h),
                    const LoginForm(),
                    SizedBox(height: 24.h),
                    Builder(
                      builder: (context) {
                        return AuthNavigationLink(
                          text: S.of(context)!.dontHaveAccount,
                          linkText: S.of(context)!.signUp,
                          onTap: () {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        const RoleSelectionScreen(),
                                transitionsBuilder:
                                    (
                                      context,
                                      animation,
                                      secondaryAnimation,
                                      child,
                                    ) {
                                      const begin = Offset(1.0, 0.0);
                                      const end = Offset.zero;
                                      const curve = Curves.easeInOut;

                                      var tween = Tween(
                                        begin: begin,
                                        end: end,
                                      ).chain(CurveTween(curve: curve));

                                      return SlideTransition(
                                        position: animation.drive(tween),
                                        child: child,
                                      );
                                    },
                                transitionDuration: const Duration(
                                  milliseconds: 400,
                                ),
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
