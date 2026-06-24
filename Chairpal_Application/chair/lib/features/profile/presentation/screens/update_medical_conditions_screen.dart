import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../l10n/l10n.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../../features/auth/presentation/cubit/medical_conditions_cubit/medical_conditions_cubit.dart';
import '../../../../features/auth/presentation/cubit/medical_conditions_cubit/medical_conditions_state.dart';
import '../../../../features/auth/presentation/cubit/user_cubit/user_cubit.dart';
import '../../../../features/auth/presentation/cubit/user_cubit/user_state.dart';
import '../cubit/profile_update_cubit.dart';
import 'package:chair_pal/core/widgets/custom_back_button.dart';
import 'package:chair_pal/core/widgets/custom_snackbar.dart';

class UpdateMedicalConditionsScreen extends StatelessWidget {
  const UpdateMedicalConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<MedicalConditionsCubit>()..fetchMedicalConditions()),
        BlocProvider(create: (_) => di.sl<ProfileUpdateCubit>()..fetchConnectedDoctor()),
      ],
      child: const _UpdateMedicalConditionsView(),
    );
  }
}

class _UpdateMedicalConditionsView extends StatefulWidget {
  const _UpdateMedicalConditionsView();

  @override
  State<_UpdateMedicalConditionsView> createState() => _UpdateMedicalConditionsViewState();
}

class _UpdateMedicalConditionsViewState extends State<_UpdateMedicalConditionsView> {
  final Set<int> _selectedConditionIds = {};
  bool _noneOfTheAboveSelected = false;

  @override
  void initState() {
    super.initState();
    final userState = context.read<UserCubit>().state;
    if (userState is UserLoaded) {
      final ids = userState.user.medicalConditionIds;
      if (ids != null && ids.isNotEmpty) {
        _selectedConditionIds.addAll(ids);
      } else if (ids != null && ids.isEmpty) {
        _noneOfTheAboveSelected = true;
      }
    }
  }

  void _toggleCondition(int id) {
    setState(() {
      _noneOfTheAboveSelected = false;
      if (_selectedConditionIds.contains(id)) {
        _selectedConditionIds.remove(id);
      } else {
        _selectedConditionIds.add(id);
      }
    });
  }

  void _toggleNoneOfTheAbove() {
    setState(() {
      _noneOfTheAboveSelected = !_noneOfTheAboveSelected;
      if (_noneOfTheAboveSelected) {
        _selectedConditionIds.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context)!;

    return BlocListener<ProfileUpdateCubit, ProfileUpdateState>(
      listener: (context, state) {
        if (state is ProfileUpdateSuccess) {
          final msg = state.message.isNotEmpty ? state.message : S.of(context)!.profileUpdatedSuccessfully;
          CustomSnackBar.showSuccess(context: context, message: msg);
          context.read<UserCubit>().fetchProfile();
          Navigator.pop(context);
        } else if (state is ProfileUpdateFailure) {
          CustomSnackBar.showError(context: context, message: state.error);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const CustomBackButton(),
          leadingWidth: 100,
          title: Text(
            l10n.medicalConditionIds.split('(').first.trim(),
            style: AppStyles.h3.copyWith(color: AppColors.primaryDark),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 16.h),
                // Header chat bubble
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(color: Colors.grey.shade200),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Text(
                              l10n.healthConditionTitle,
                              style: AppStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                            ),
                          ),
                          Positioned(
                            bottom: -10,
                            right: 20.w,
                            child: CustomPaint(
                              painter: _RightTrianglePainter(),
                              size: const Size(15, 10),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Image.asset(
                      Assets.assistantTellUs,
                      width: 60.w,
                      height: 80.h,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
                SizedBox(height: 32.h),
                // Conditions list
                Expanded(
                  child: BlocBuilder<MedicalConditionsCubit, MedicalConditionsState>(
                    builder: (context, state) {
                      if (state is MedicalConditionsLoading || state is MedicalConditionsInitial) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is MedicalConditionsError) {
                        return Center(
                          child: Text(state.message,
                              style: AppStyles.bodyMedium.copyWith(color: AppColors.error)),
                        );
                      } else if (state is MedicalConditionsLoaded) {
                        final conditions = state.conditions;
                        return ListView.separated(
                          itemCount: conditions.length + 1,
                          separatorBuilder: (_, __) => SizedBox(height: 12.h),
                          itemBuilder: (context, index) {
                            if (index == conditions.length) {
                              // "None of the above"
                              final isSelected = _noneOfTheAboveSelected;
                              return GestureDetector(
                                onTap: _toggleNoneOfTheAbove,
                                child: _ConditionTile(
                                  label: l10n.conditionNone,
                                  emoji: '✨',
                                  isSelected: isSelected,
                                ),
                              );
                            }
                            final item = conditions[index];
                            final isSelected = _selectedConditionIds.contains(item.id);
                            return GestureDetector(
                              onTap: () => _toggleCondition(item.id),
                              child: _ConditionTile(
                                label: item.name,
                                isSelected: isSelected,
                              ),
                            );
                          },
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
                SizedBox(height: 16.h),
                BlocBuilder<ProfileUpdateCubit, ProfileUpdateState>(
                  builder: (context, state) {
                    final isLoading = state is ProfileUpdateLoading;
                    return SizedBox(
                      height: 56.h,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          elevation: 0,
                        ),
                        onPressed: isLoading
                            ? null
                            : () {
                                context.read<ProfileUpdateCubit>().updateProfile(
                                      medicalConditionIds: _selectedConditionIds.isNotEmpty
                                          ? _selectedConditionIds.toList()
                                          : [],
                                    );
                              },
                        child: isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(
                                l10n.update,
                                style: AppStyles.button.copyWith(fontSize: 18.sp),
                              ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ConditionTile extends StatelessWidget {
  final String label;
  final String? emoji;
  final bool isSelected;

  const _ConditionTile({
    required this.label,
    this.emoji,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isSelected ? AppColors.primary : Colors.grey.shade200,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          if (emoji != null) ...[
            Text(emoji!, style: AppStyles.h3),
            SizedBox(width: 12.w),
          ],
          Expanded(
            child: Text(
              label,
              style: AppStyles.bodyLarge.copyWith(
                color: AppColors.primaryDark,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
          if (isSelected)
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary, width: 1.5),
              ),
              child: const Icon(Icons.check, color: AppColors.primary, size: 16),
            ),
        ],
      ),
    );
  }
}

class _RightTrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();

    canvas.drawShadow(path, Colors.black.withValues(alpha: 0.05), 4, false);
    canvas.drawPath(path, paint);

    final vPath = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0);
    canvas.drawPath(vPath, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
