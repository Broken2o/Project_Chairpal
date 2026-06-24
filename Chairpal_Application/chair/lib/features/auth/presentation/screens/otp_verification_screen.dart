import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../l10n/l10n.dart';
import '../cubit/forgot_password_cubit/forgot_password_cubit.dart';
import '../cubit/forgot_password_cubit/forgot_password_state.dart';
import 'reset_password_screen.dart';
import 'package:chair_pal/core/widgets/custom_snackbar.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;

  const OtpVerificationScreen({super.key, required this.email});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen>
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
      create: (context) => di.sl<ForgotPasswordCubit>(),
      child: BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
        listener: (context, state) {
          if (state.status == ForgotPasswordStatus.otpVerified) {
            CustomSnackBar.showSuccess(context: context, message: S.of(context)!.otpVerifiedSuccess);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ResetPasswordScreen(
                  email: widget.email,
                  otp: _pinController.text,
                ),
              ),
            );
          } else if (state.status == ForgotPasswordStatus.error) {
            CustomSnackBar.showError(context: context, message: state.errorMessage ?? 'Unknown error');
            _pinController.clear();
            _focusNode.requestFocus();
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.primary,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
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
                              S.of(context)!.enterOtpCode,
                              style: AppStyles.h2.copyWith(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              '${S.of(context)!.otpSentTo} ${widget.email}',
                              style: AppStyles.bodyMedium.copyWith(
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 40.h),
                            Form(
                              key: _formKey,
                              child:
                                  BlocBuilder<
                                    ForgotPasswordCubit,
                                    ForgotPasswordState
                                  >(
                                    builder: (context, state) {
                                      return Pinput(
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
                                                .otpMustBe4Digits;
                                          }
                                          return null;
                                        },
                                        onCompleted: (pin) {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            context
                                                .read<ForgotPasswordCubit>()
                                                .verifyOtp(widget.email, pin);
                                          }
                                        },
                                      );
                                    },
                                  ),
                            ),
                            SizedBox(height: 40.h),
                            BlocBuilder<
                              ForgotPasswordCubit,
                              ForgotPasswordState
                            >(
                              builder: (context, state) {
                                return CustomButton(
                                  text: S.of(context)!.verifyOtp,
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      context
                                          .read<ForgotPasswordCubit>()
                                          .verifyOtp(
                                            widget.email,
                                            _pinController.text,
                                          );
                                    }
                                  },
                                  isLoading:
                                      state.status ==
                                      ForgotPasswordStatus.loading,
                                  width: double.infinity,
                                );
                              },
                            ),
                            SizedBox(height: 24.h),
                            // Resend Code
                            BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
                              listener: (context, state) {
                                if (state.status == ForgotPasswordStatus.otpSent) {
                                  startTimer();
                                  CustomSnackBar.showSuccess(context: context, message: 'Code resent successfully!');
                                }
                              },
                              builder: (context, state) {
                                final isResendDisabled = state.status == ForgotPasswordStatus.loading || _secondsRemaining > 0;
                                return TextButton(
                                  onPressed: isResendDisabled
                                      ? null
                                      : () {
                                          context
                                              .read<ForgotPasswordCubit>()
                                              .sendOtp(widget.email);
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
        ),
      ),
    );
  }
}
