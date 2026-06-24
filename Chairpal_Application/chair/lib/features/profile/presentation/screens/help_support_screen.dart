import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../l10n/l10n.dart';
import '../../../../core/di/injection_container.dart';
import '../cubit/support_cubit/support_cubit.dart';
import '../cubit/support_cubit/support_state.dart';
import 'package:chair_pal/core/widgets/custom_back_button.dart';
import 'package:chair_pal/core/widgets/custom_snackbar.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context)!;
    
    return BlocProvider(
      create: (context) => sl<SupportCubit>(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          leading: const CustomBackButton(),
          leadingWidth: 100,
          title: Text(
            l10n.helpSupport,
            style: AppStyles.h3.copyWith(color: AppColors.primaryDark),
          ),
        ),
        body: BlocConsumer<SupportCubit, SupportState>(
          listener: (context, state) {
            if (state is SupportSuccess) {
              showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                    backgroundColor: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(24.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              icon: const Icon(Icons.cancel_outlined, color: Colors.deepOrange, size: 28),
                              onPressed: () => Navigator.pop(context),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ),
                          Image.asset(
                            Assets.imagesMessageSent,
                            height: 150.h,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            l10n.helpSupportSuccessMessage,
                            style: AppStyles.h3.copyWith(color: AppColors.primaryDark),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 12.h),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: AppStyles.bodyMedium.copyWith(color: AppColors.textSecondary, height: 1.5),
                              children: [
                                TextSpan(text: l10n.helpSupportSuccessDesc1),
                                TextSpan(
                                  text: l10n.helpSupportSuccessDesc2,
                                  style: const TextStyle(color: AppColors.primary),
                                ),
                                TextSpan(text: l10n.helpSupportSuccessDesc3),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
              _messageController.clear();
            } else if (state is SupportError) {
              CustomSnackBar.showError(context: context, message: state.message);
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: AppStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                          children: _buildRichText(l10n.helpSupportAssistance, 'ChairPal'),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 48.h),
                  Text(
                    l10n.helpSupportContactInfo,
                    style: AppStyles.h3.copyWith(color: AppColors.primaryDark),
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Transform.scale(
                        scaleX: Directionality.of(context) == TextDirection.rtl ? -1 : 1,
                        child: const Icon(Icons.phone, color: AppColors.primary, size: 20),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        "+201554411691",
                        style: AppStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                        textDirection: TextDirection.ltr,
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      const Icon(Icons.email, color: AppColors.primary, size: 20),
                      SizedBox(width: 12.w),
                      Text(
                        "chairpalsupport@gmail.com",
                        style: AppStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  SizedBox(height: 32.h),
                  Text(
                    l10n.helpSupportMessage,
                    style: AppStyles.h3.copyWith(color: AppColors.primaryDark),
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _messageController,
                      maxLines: 8,
                      decoration: InputDecoration(
                        hintText: l10n.helpSupportMessageHint,
                        hintStyle: AppStyles.bodyMedium.copyWith(color: Colors.grey.shade400),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16.w),
                      ),
                    ),
                  ),
                  SizedBox(height: 40.h),
                  SizedBox(
                    width: double.infinity,
                    height: 56.h,
                    child: ElevatedButton(
                      onPressed: state is SupportLoading
                          ? null
                          : () {
                              context.read<SupportCubit>().sendSupportMessage(_messageController.text);
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        elevation: 0,
                      ),
                      child: state is SupportLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : Text(
                              l10n.helpSupportSend,
                              style: AppStyles.bodyLarge.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<InlineSpan> _buildRichText(String text, String highlight) {
    final parts = text.split(highlight);
    if (parts.length == 1) return [TextSpan(text: text)];
    
    List<InlineSpan> spans = [];
    for (int i = 0; i < parts.length; i++) {
      spans.add(TextSpan(text: parts[i]));
      if (i != parts.length - 1) {
        spans.add(TextSpan(text: highlight, style: const TextStyle(color: AppColors.primary)));
      }
    }
    return spans;
  }
}
