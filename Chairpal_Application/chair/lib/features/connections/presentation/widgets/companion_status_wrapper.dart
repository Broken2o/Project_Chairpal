import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../l10n/l10n.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../core/constants/assets.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_snackbar.dart';
import '../../../auth/presentation/cubit/user_cubit/user_cubit.dart';
import '../../../auth/presentation/cubit/user_cubit/user_state.dart';
import '../cubit/companion_status_cubit.dart';
import '../../../home/presentation/widgets/roles/companion_dashboard_widget.dart';
import '../../../home/presentation/cubit/home_dashboard_cubit/home_dashboard_cubit.dart';
import '../../../home/presentation/cubit/home_dashboard_cubit/home_dashboard_state.dart';

class CompanionStatusWrapper extends StatefulWidget {
  const CompanionStatusWrapper({super.key});

  @override
  State<CompanionStatusWrapper> createState() => _CompanionStatusWrapperState();
}

class _CompanionStatusWrapperState extends State<CompanionStatusWrapper> {
  final TextEditingController _usernameController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeDashboardCubit, HomeDashboardState>(
      builder: (context, dashboardState) {
        if (dashboardState is HomeDashboardLoading || dashboardState is HomeDashboardInitial) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }

        if (dashboardState is CompanionDashboardLoaded || dashboardState is HomeDashboardLoaded) {
          return const CompanionDashboardWidget();
        }

        // If it failed to load (no connected user), check pending connection
        return BlocProvider(
          create: (context) => sl<CompanionStatusCubit>()..fetchStatus(),
          child: BlocConsumer<CompanionStatusCubit, CompanionStatusState>(
            listener: (context, state) {
              if (state is CompanionStatusRequestSuccess) {
                CustomSnackBar.showSuccess(
                  context: context,
                  message: state.message,
                );
              } else if (state is CompanionStatusRequestError) {
                CustomSnackBar.showError(
                  context: context,
                  message: state.message,
                );
              }
            },
            builder: (context, state) {
              if (state is CompanionStatusLoading || state is CompanionStatusInitial) {
                return const Center(child: CircularProgressIndicator(color: AppColors.primary));
              }

              final l10n = S.of(context)!;
              
              String title = '';
              String desc = '';
              String imagePath = '';
              Widget buttons = const SizedBox.shrink();

              if (state is CompanionStatusPending) {
                title = l10n.companionRequestPending;
                desc = l10n.companionRequestPendingDesc;
                imagePath = Assets.imagesCompanionPending;
                buttons = Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: l10n.retry,
                        onPressed: () {
                          context.read<CompanionStatusCubit>().fetchStatus();
                          final userState = context.read<UserCubit>().state;
                          if (userState is UserLoaded) {
                            context.read<HomeDashboardCubit>().fetchDashboard(
                              userState.user.id,
                              userState.user.role ?? 'companion',
                            );
                          }
                        },
                      ),
                    ),
                  ],
                );
              } else {
                title = l10n.noConnections; 
                desc = l10n.enterPatientUsernameToSendConnectionRequest;
                imagePath = Assets.imagesNoConnections;
                buttons = Column(
                  children: [
                    CustomTextField(
                      controller: _usernameController,
                      hintText: l10n.patientUsername,
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                    SizedBox(height: 16.h),
                    CustomButton(
                      text: l10n.sendRequest,
                      isLoading: state is CompanionStatusSendingRequest,
                      onPressed: () {
                        if (state is CompanionStatusSendingRequest) return;
                        final username = _usernameController.text.trim();
                        if (username.isNotEmpty) {
                          context.read<CompanionStatusCubit>().sendRequest(username);
                        }
                      },
                    ),
                  ],
                );
              }

              return Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        imagePath,
                        height: 200.h,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: 32.h),
                      Text(
                        title,
                        style: AppStyles.h3.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        desc,
                        style: AppStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 48.h),
                      buttons,
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
