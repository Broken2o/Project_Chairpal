import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/assets.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../core/widgets/custom_popup_dialog.dart';
import '../../../../l10n/l10n.dart';
import '../cubit/companions_cubit.dart';
import '../../../auth/domain/entities/user.dart';
import 'package:chair_pal/core/widgets/custom_back_button.dart';
import 'package:chair_pal/core/widgets/custom_snackbar.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CompanionsScreen extends StatelessWidget {
  const CompanionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<CompanionsCubit>()..fetchCompanions(),
      child: const _CompanionsView(),
    );
  }
}

class _CompanionsView extends StatefulWidget {
  const _CompanionsView();

  @override
  State<_CompanionsView> createState() => _CompanionsViewState();
}

class _CompanionsViewState extends State<_CompanionsView> {
  void _showDeleteDialog(BuildContext context, S s, User companion) {
    showDialog(
      context: context,
      builder: (_) {
        return CustomPopupDialog(
          imagePath: Assets.imagesDeleteCompanion,
          title: s.deleteCompanion,
          primaryButtonText: s.cancel,
          primaryButtonIcon: Icons.cancel_presentation_outlined,
          onPrimaryPressed: () => Navigator.pop(context),
          secondaryButtonText: s.delete,
          secondaryButtonIcon: Icons.delete_outline,
          onSecondaryPressed: () {
            Navigator.pop(context);
            context.read<CompanionsCubit>().removeCompanion(companion.id);
          },
        );
      },
    );
  }

  void _showNewRequestDialog(BuildContext context, S s, String companionName, int connectionId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return CustomPopupDialog(
          imagePath: Assets.imagesCompanionRequest,
          title: s.newCompanionRequest,
          bodyWidget: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: AppStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
              children: [
                TextSpan(
                  text: '"$companionName" ',
                  style: AppStyles.bodyLarge.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(text: s.wantsToFollow),
              ],
            ),
          ),
          primaryButtonText: s.accept,
          primaryButtonIcon: Icons.domain_verification_outlined,
          onPrimaryPressed: () {
            Navigator.pop(context);
            context.read<CompanionsCubit>().handleConnection(connectionId, 'accept');
          },
          secondaryButtonText: s.decline,
          secondaryButtonIcon: Icons.cancel_presentation_outlined,
          onSecondaryPressed: () {
            Navigator.pop(context);
            context.read<CompanionsCubit>().handleConnection(connectionId, 'reject');
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;
    
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        leadingWidth: 100,
        leading: const CustomBackButton(),
        title: Text(
          s.companions,
          style: AppStyles.h2PrimaryDark.copyWith(fontSize: 22),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<CompanionsCubit, CompanionsState>(
        listener: (context, state) {
          if (state is CompanionsError) {
            CustomSnackBar.showSuccess(context: context, message: state.message);
          } else if (state is CompanionsLoaded) {
            if (state.pendingRequests.isNotEmpty) {
              final pending = state.pendingRequests.first;
              // Show dialog for the first pending request
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _showNewRequestDialog(
                  context, 
                  s, 
                  pending.sender?.name ?? 'Someone', 
                  pending.id
                );
              });
            }
          }
        },
        builder: (context, state) {
          if (state is CompanionsLoading || state is CompanionsInitial) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          } else if (state is CompanionsLoaded) {
            if (state.companions.isEmpty) {
              return Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(Assets.imagesNoConnections, height: 150.h),
                    SizedBox(height: 24.h),
                    Text(
                      s.noEmergencyCompanions,
                      style: AppStyles.h3.copyWith(color: AppColors.primaryDark, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      s.giveYourUsernameDesc,
                      textAlign: TextAlign.center,
                      style: AppStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              );
            }

            return Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                children: [
                  Text(
                    s.manageTrustedCompanions,
                    textAlign: TextAlign.center,
                    style: AppStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                  ),
                  SizedBox(height: 24.h),
                  Expanded(
                    child: ListView.separated(
                      itemCount: state.companions.length,
                      separatorBuilder: (_, __) => Divider(height: 32.h, color: Colors.grey[200]),
                      itemBuilder: (context, index) {
                        final companion = state.companions[index];
                        return Row(
                          children: [
                            CircleAvatar(
                              radius: 28.r,
                              backgroundImage: companion.image != null 
                                  ? NetworkImage(companion.image!) 
                                  : null,
                              backgroundColor: const Color(0xFFD3E3FD),
                              child: companion.image == null ? Icon(Icons.person, color: const Color(0xFF90B5EB), size: 36.r) : null,
                            ),
                            SizedBox(width: 14.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    companion.name,
                                    style: AppStyles.bodyLarge.copyWith(fontWeight: FontWeight.w400, color: AppColors.primaryDark, fontSize: 18.sp),
                                  ),
                                  SizedBox(height: 4.h),
                                  Row(
                                    children: [
                                      Transform.scale(
                                        scaleX: Directionality.of(context) == TextDirection.rtl ? -1 : 1,
                                        child: Icon(Icons.phone, size: 16.sp, color: AppColors.primary),
                                      ),
                                      SizedBox(width: 6.w),
                                      Text(
                                        companion.phone ?? '',
                                        style: AppStyles.bodyMedium.copyWith(color: AppColors.textSecondary, fontSize: 15.sp),
                                        textDirection: TextDirection.ltr,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: SvgPicture.asset(Assets.svgMsg, width: 27.sp),
                              onPressed: () {},
                            ),
                            SizedBox(width: 10.w),
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Color(0xFFF27B50)),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 0.h),
                              ),
                              onPressed: () => _showDeleteDialog(context, s, companion),
                              child: Text(
                                s.delete,
                                style: AppStyles.bodyMedium.copyWith(color: const Color(0xFFF27B50)),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
