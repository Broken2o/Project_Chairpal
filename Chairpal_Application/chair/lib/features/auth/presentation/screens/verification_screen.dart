import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../l10n/l10n.dart';
import '../cubit/verification_cubit/verification_cubit.dart';
import '../cubit/verification_cubit/verification_state.dart';
import 'login_screen.dart';
import 'package:chair_pal/core/widgets/custom_snackbar.dart';

class VerificationScreen extends StatefulWidget {
  final String email;
  final bool autoSendOtp;

  const VerificationScreen({
    super.key,
    required this.email,
    this.autoSendOtp = false,
  });

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  final TextEditingController _pinController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  Timer? _timer;
  int _secondsRemaining = 60;

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

    // Request focus after animation
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        _focusNode.requestFocus();
      }
    });

    startTimer();
  }

  void startTimer() {
    setState(() {
      _secondsRemaining = 60;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    _pinController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56.w,
      height: 56.h,
      textStyle: AppStyles.h2.copyWith(color: AppColors.textPrimary),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppColors.primary, width: 2.w),
      boxShadow: [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.2),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: AppColors.background,
      ),
    );

    return BlocProvider(
      create: (context) {
        final cubit = di.sl<VerificationCubit>(param1: widget.email);
        if (widget.autoSendOtp) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              cubit.resendCode();
            }
          });
        }
        return cubit;
      },
      child: BlocListener<VerificationCubit, VerificationState>(
        listener: (context, state) {
          if (state is VerificationSuccess) {
            CustomSnackBar.showSuccess(context: context, message: S.of(context)!.emailVerifiedSuccess);
            // Navigate to Login screen
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) => false,
            );
          } else if (state is VerificationError) {
            CustomSnackBar.showError(context: context, message: state.message);
            _pinController.clear();
            _focusNode.requestFocus();
          } else if (state is VerificationCodeResent) {
            CustomSnackBar.showSuccess(context: context, message: S.of(context)!.codeResentSuccess);
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.primary,
          body: SafeArea(
            child: Column(
              children: [
                // Top Section (Teal Background)
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: Padding(
                              padding: EdgeInsets.all(24.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.lock_outline,
                              size: 80,
                              color: Colors.white,
                            ),
                            SizedBox(height: 24.h),
                            Text(
                              S.of(context)!.enterVerificationCode,
                              style: AppStyles.h2.copyWith(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              S.of(context)!.verificationDescription,
                              style: AppStyles.bodyMedium.copyWith(
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 40.h),

                            // Pinput Widget
                            Form(
                              key: _formKey,
                              child:
                                  BlocBuilder<
                                    VerificationCubit,
                                    VerificationState
                                  >(
                                    builder: (context, state) {
                                      return Directionality(
                                        textDirection: TextDirection.ltr,
                                        child: Pinput(
                                          length: 6,
                                          controller: _pinController,
                                          focusNode: _focusNode,
                                          defaultPinTheme: defaultPinTheme,
                                          focusedPinTheme: focusedPinTheme,
                                          submittedPinTheme: submittedPinTheme,
                                          pinputAutovalidateMode:
                                              PinputAutovalidateMode.onSubmit,
                                          showCursor: true,
                                          validator: (value) {
                                            if (value == null ||
                                                value.length != 6) {
                                              return S
                                                  .of(context)!
                                                  .verificationCodeMustBe4Digits;
                                            }
                                            return null;
                                          },
                                          onCompleted: (pin) {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              context
                                                  .read<VerificationCubit>()
                                                  .verify(pin);
                                            }
                                          },
                                          onChanged: (value) {
                                            context
                                                .read<VerificationCubit>()
                                                .updateCode(value);
                                          },
                                        ),
                                      );
                                    },
                                  ),
                            ),

                            SizedBox(height: 16.h),

                            // Loading Indicator
                            BlocBuilder<VerificationCubit, VerificationState>(
                              builder: (context, state) {
                                if (state is VerificationLoading) {
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 16.h),
                                    child: const CircularProgressIndicator(color: Colors.white),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),

                            // Resend Code
                            BlocConsumer<VerificationCubit, VerificationState>(
                              listener: (context, state) {
                                if (state is VerificationCodeResent) {
                                  startTimer();
                                  CustomSnackBar.showSuccess(context: context, message: 'Code resent successfully!');
                                }
                              },
                              builder: (context, state) {
                                final isResendDisabled = state is VerificationLoading || _secondsRemaining > 0;
                                return TextButton(
                                  onPressed: isResendDisabled
                                      ? null
                                      : () {
                                          context
                                              .read<VerificationCubit>()
                                              .resendCode();
                                        },
                                  child: Text(
                                    _secondsRemaining > 0 
                                      ? '${S.of(context)!.resendCode} • 00:${_secondsRemaining.toString().padLeft(2, '0')}'
                                      : S.of(context)!.resendCode,
                                    style: AppStyles.bodyMedium.copyWith(
                                      color: isResendDisabled ? Colors.white54 : Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                    ),
                  ],
                ),
              ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
