import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../core/constants/assets.dart';
import '../../../auth/presentation/cubit/user_cubit/user_cubit.dart';
import '../../../auth/presentation/cubit/user_cubit/user_state.dart';
import '../../../auth/presentation/screens/login_screen.dart';

import '../../../../l10n/l10n.dart';
import 'package:chair_pal/core/widgets/custom_snackbar.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context)!;
    const orangeActionColor = Color(0xFFE97A53);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
      ),
      backgroundColor: Colors.white,
      child: BlocListener<UserCubit, UserState>(
        listener: (context, state) {
          if (state is UserInitial) { // Logout successful, state was reset
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) => false,
            );
          } else if (state is UserError) {
            CustomSnackBar.showSuccess(context: context, message: state.message);
            Navigator.pop(context); // close dialog on error so user can retry
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(24.0.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Close button
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(20.r),
                    child: Container(
                      padding: EdgeInsets.all(4.r),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: orangeActionColor, width: 2),
                      ),
                      child: const Icon(
                        Icons.close,
                        color: orangeActionColor,
                        size: 20,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 16.h),

                // Illustration
                Image.asset(
                  Assets.imagesLogout, // using generated assets class
                  height: 120,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.exit_to_app, size: 100, color: AppColors.primaryDark),
                ),

                // Title
                Text(
                  l10n.logoutDialogTitle,
                  //textAlign: TextAlign.center,
                  style: AppStyles.h3.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryDark,
                  ),
                ),

                SizedBox(height: 25.h),

                // Actions
                Row(
                  children: [
                    // Cancel Button
                    Expanded(
                      child: SizedBox(
                        child: ElevatedButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.cancel_outlined, color: Colors.white, size: 18),
                          label: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                l10n.cancelButton,
                                maxLines: 1,
                                style: AppStyles.button.copyWith(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    // Log out Button
                    Expanded(
                      child: BlocBuilder<UserCubit, UserState>(
                        builder: (context, state) {
                          final isLoading = state is UserLoading;
                          return SizedBox(
                            child: OutlinedButton.icon(
                              onPressed: isLoading
                                  ? null
                                  : () => context.read<UserCubit>().logout(),
                              icon: isLoading
                                  ? const SizedBox.shrink()
                                  : const Icon(Icons.logout, color: orangeActionColor, size: 18),
                              label: isLoading
                                  ? SizedBox(
                                      height: 20.h,
                                      width: 20.w,
                                      child: CircularProgressIndicator(
                                        color: orangeActionColor,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                            l10n.logoutButton,
                                            maxLines: 1,
                                            style: AppStyles.button.copyWith(
                                              color: orangeActionColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                        ),
                                      ),
                                  ),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: orangeActionColor, width: 1.5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
