import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/assets.dart';
import '../cubit/onboarding_cubit.dart';
import '../cubit/onboarding_state.dart';
import '../widgets/onboarding_page.dart';
import '../widgets/page_indicator.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import '../../../auth/presentation/screens/role_selection_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();


  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  void _navigateToSignup() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const RoleSelectionScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = S.of(context)!;
    
    final List<Map<String, String>> onboardingData = [
      {
        'title': localizations.onboardingPage1Title,
        'description': localizations.onboardingPage1Description,
        'image': Assets.onboarding1,
      },
      {
        'title': localizations.onboardingPage2Title,
        'description': localizations.onboardingPage2Description,
        'image': Assets.onboarding2,
      },
      {
        'title': localizations.onboardingPage3Title,
        'description': localizations.onboardingPage3Description,
        'image': Assets.onboarding3,
      },
      {
        'title': localizations.onboardingPage4Title,
        'description': localizations.onboardingPage4Description,
        'image': Assets.onboarding4,
      },
    ];
    
    return BlocProvider(
      create: (context) => OnboardingCubit(),
      child: BlocListener<OnboardingCubit, OnboardingState>(
        listener: (context, state) {
          if (state is OnboardingNavigateToLogin) {
            _navigateToLogin();
          } else if (state is OnboardingNavigateToSignup) {
            _navigateToSignup();
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.scaffoldBackground,
          body: Stack(
            children: [
              // Layer 1: Background Images (Blending)
              AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  return Stack(
                    children: List.generate(onboardingData.length, (index) {
                      double opacity = 0.0;
                      if (_pageController.hasClients &&
                          _pageController.position.haveDimensions) {
                        double page = _pageController.page ?? 0.0;
                        // Calculate opacity based on distance from current page
                        double distance = (page - index).abs();
                        opacity = (1.0 - distance).clamp(0.0, 1.0);
                      } else if (index == 0) {
                        opacity = 1.0; // Initial state
                      }

                      return Positioned.fill(
                        child: Opacity(
                          opacity: opacity,
                          child: Column(
                            children: [
                              Expanded(
                                flex: 4,
                                child: Image.asset(
                                  onboardingData[index]['image']!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                              SizedBox(height: 40.h),
                              const Spacer(flex: 2),
                            ],
                          ),
                        ),
                      );
                    }),
                  );
                },
              ),
              
              // Layer 2: Foreground Content (Text & Buttons)
              BlocBuilder<OnboardingCubit, OnboardingState>(
                builder: (context, state) {
                  int currentPage = 0;
                  if (state is OnboardingPageChanged) {
                    currentPage = state.currentPage;
                  }

                  return Column(
                    children: [
                      // PageView with transparent images (only text visible)
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          onPageChanged: (index) {
                            context.read<OnboardingCubit>().onPageChanged(index);
                          },
                          itemCount: onboardingData.length,
                          itemBuilder: (context, index) {
                            final data = onboardingData[index];
                            return AnimatedBuilder(
                              animation: _pageController,
                              builder: (context, child) {
                                double value = 1.0;
                                if (_pageController.position.haveDimensions) {
                                  value = _pageController.page! - index;
                                  value = (1 - (value.abs() * 0.5)).clamp(0.0, 1.0);
                                }
                                return Opacity(
                                  opacity: value,
                                  child: Transform.scale(
                                    scale: value,
                                    child: child,
                                  ),
                                );
                              },
                              child: OnboardingPage(
                                imagePath: '', // Pass empty to make it transparent
                                title: data['title']!,
                                description: data['description']!,
                              ),
                            );
                          },
                        ),
                      ),
                      // Static Page Indicator
                      Padding(
                        padding: EdgeInsets.only(bottom: 32.h),
                        child: PageIndicator(
                          currentPage: currentPage,
                          totalPages: onboardingData.length,
                        ),
                      ),
                      // static
                      SafeArea(
                        top: false,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(24, 0, 24, 20),
                          child: Row(
                            children: [
                              Expanded(
                                child: CustomButton(
                                  text: S.of(context)!.signUp,
                                  onPressed: () {
                                    context.read<OnboardingCubit>().navigateToSignup();
                                  },
                                  variant: ButtonVariant.outlined,
                                ),
                              ),
                              SizedBox(width: 16.w),
                              Expanded(
                                child: CustomButton(
                                  text: S.of(context)!.login,
                                  onPressed: () {
                                    context.read<OnboardingCubit>().navigateToLogin();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
