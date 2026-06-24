import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../l10n/l10n.dart';
import '../../../../core/widgets/custom_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../cubit/medical_conditions_cubit/medical_conditions_cubit.dart';
import '../cubit/medical_conditions_cubit/medical_conditions_state.dart';
import 'signup_screen.dart';
import 'package:chair_pal/core/widgets/custom_back_button.dart';

class HealthConditionsScreen extends StatefulWidget {
  final String role;

  const HealthConditionsScreen({super.key, required this.role});

  @override
  State<HealthConditionsScreen> createState() => _HealthConditionsScreenState();
}

class _HealthConditionsScreenState extends State<HealthConditionsScreen> {
  final Set<int> _selectedConditionIds = {};
  bool _noneOfTheAboveSelected = false;

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
    return BlocProvider(
      create: (context) => sl<MedicalConditionsCubit>()..fetchMedicalConditions(),
      child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const CustomBackButton(),
        leadingWidth: 100,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 16.h),
              // Header with Chat Bubble and Robot
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
                            S.of(context)!.healthConditionTitle,
                            style: AppStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -10,
                          right: 20.w,
                          child: CustomPaint(
                            painter: RightTrianglePainter(),
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
              // Conditions List
              Expanded(
                child: BlocBuilder<MedicalConditionsCubit, MedicalConditionsState>(
                  builder: (context, state) {
                    if (state is MedicalConditionsLoading || state is MedicalConditionsInitial) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is MedicalConditionsError) {
                      return Center(
                        child: Text(
                          state.message,
                          style: AppStyles.bodyMedium.copyWith(color: AppColors.error),
                        ),
                      );
                    } else if (state is MedicalConditionsLoaded) {
                      final conditions = state.conditions;
                      return ListView.separated(
                        itemCount: conditions.length + 1, // +1 for None of the above
                        separatorBuilder: (context, index) => SizedBox(height: 12.h),
                        itemBuilder: (context, index) {
                          if (index == conditions.length) {
                            // Render "None of the above"
                            final isSelected = _noneOfTheAboveSelected;
                            return GestureDetector(
                              onTap: _toggleNoneOfTheAbove,
                              child: Container(
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
                                    Text('✨', style: AppStyles.h3),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: Text(
                                        S.of(context)!.conditionNone,
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
                              ),
                            );
                          }

                          // Render standard conditions
                          final item = conditions[index];
                          final isSelected = _selectedConditionIds.contains(item.id);

                          return GestureDetector(
                            onTap: () => _toggleCondition(item.id),
                            child: Container(
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
                                  Expanded(
                                    child: Text(
                                      item.name,
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
              CustomButton(
                text: S.of(context)!.continueButton,
                onPressed: (_selectedConditionIds.isNotEmpty || _noneOfTheAboveSelected)
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignupScreen(
                              role: widget.role,
                              medicalConditionIds: _selectedConditionIds.toList(),
                            ),
                          ),
                        );
                      }
                    : null,
                width: double.infinity,
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

class RightTrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    var borderPaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    var path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width / 2, size.height);
    path.close();

    canvas.drawShadow(path, Colors.black.withValues(alpha: 0.05), 4, false);
    canvas.drawPath(path, paint);

    var vPath = Path();
    vPath.moveTo(0, 0);
    vPath.lineTo(size.width / 2, size.height);
    vPath.lineTo(size.width, 0);
    canvas.drawPath(vPath, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
