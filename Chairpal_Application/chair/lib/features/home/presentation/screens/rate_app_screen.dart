import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../l10n/l10n.dart';
import 'package:chair_pal/core/widgets/custom_back_button.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/review_cubit/review_cubit.dart';
import '../cubit/review_cubit/review_state.dart';
import '../../domain/entities/place.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/widgets/custom_snackbar.dart';
import '../../../../features/auth/presentation/cubit/user_cubit/user_cubit.dart';
import '../../../../features/auth/presentation/cubit/user_cubit/user_state.dart';

class RateAppScreen extends StatefulWidget {
  final Place place;
  final int initialRating;
  final String? type;

  const RateAppScreen({
    super.key,
    required this.place,
    this.initialRating = 0,
    this.type,
  });

  @override
  State<RateAppScreen> createState() => _RateAppScreenState();
}

class _RateAppScreenState extends State<RateAppScreen> {
  late int _selectedRating;
  final TextEditingController _commentController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedRating = widget.initialRating;
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitReview(BuildContext context) {
    final l10n = S.of(context)!;
    if (_selectedRating == 0) {
      CustomSnackBar.showError(
        context: context,
        message: l10n.pleaseSelectRating,
      );
      return;
    }

    final parsedId = int.tryParse(widget.place.id);
    if (parsedId == null) {
      CustomSnackBar.showError(
        context: context,
        message: l10n.cannotReviewPlace,
      );
      return;
    }

    final reviewType = widget.type ?? widget.place.type ?? 'place';
    context.read<ReviewCubit>().addReview(
      reviewType,
      parsedId,
      _selectedRating.toDouble(),
      _commentController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context)!;
    return BlocProvider(
      create: (_) => sl<ReviewCubit>(),
      child: BlocConsumer<ReviewCubit, ReviewState>(
        listener: (context, state) {
          if (state is ReviewActionSuccess) {
            CustomSnackBar.showSuccess(
              context: context,
              message: l10n.reviewPostedSuccess,
            );
            Navigator.pop(context);
          } else if (state is ReviewError) {
            CustomSnackBar.showError(context: context, message: state.message);
          }
        },
        builder: (context, state) {
          _isLoading = state is ReviewLoading;
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              title: Text(
                l10n.ratePlaceTitle(widget.place.name),
                style: AppStyles.h3.copyWith(color: AppColors.primaryDark),
              ),
              leading: const CustomBackButton(),
              leadingWidth: 100,
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
              child: Column(
                children: [
                  // User Info
                  BlocBuilder<UserCubit, UserState>(
                    builder: (context, userState) {
                      String name = '';
                      String? imageUrl;

                      if (userState is UserLoaded) {
                        name = userState.user.name;
                        imageUrl = userState.user.image;
                      }

                      return Row(
                        children: [
                          Container(
                            width: 72,
                            height: 72,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFE0F7FA),
                            ),
                            child: ClipOval(
                              child: (imageUrl != null && imageUrl.isNotEmpty)
                                  ? Image.network(
                                      imageUrl,
                                      width: 72,
                                      height: 72,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                          const Icon(Icons.person, size: 36, color: AppColors.primary),
                                      loadingBuilder: (context, child, loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return const Center(
                                          child: SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  : const Icon(Icons.person, size: 36, color: AppColors.primary),
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name.isNotEmpty ? name : 'User',
                                  style: AppStyles.h3.copyWith(fontSize: 18),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  l10n.reviewsVisibilityNote,
                                  style: AppStyles.bodySmall.copyWith(
                                    color: Colors.grey,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 40.h),

                  // Interactive Stars
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedRating = index + 1;
                          });
                        },
                        child: Icon(
                          index < _selectedRating
                              ? Icons.star
                              : Icons.star_border,
                          size: 40,
                          color: index < _selectedRating
                              ? AppColors.primary
                              : Colors.grey,
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 48.h),

                  // Opinion Text Field
                  TextField(
                    controller: _commentController,
                    maxLines: 6,
                    decoration: InputDecoration(
                      hintText: l10n.rateAppHint,
                      hintStyle: TextStyle(color: Colors.grey[300]),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: const BorderSide(color: AppColors.primary),
                      ),
                    ),
                  ),
                  SizedBox(height: 32.h),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      onPressed: _isLoading
                          ? null
                          : () => _submitReview(context),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              l10n.submitReview,
                              style: AppStyles.bodyMedium.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
