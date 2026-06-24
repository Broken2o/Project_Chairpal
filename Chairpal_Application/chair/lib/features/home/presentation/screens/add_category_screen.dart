import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../l10n/l10n.dart';
import '../cubit/add_category_cubit/add_category_cubit.dart';
import '../cubit/add_category_cubit/add_category_state.dart';
import 'package:chair_pal/core/widgets/custom_back_button.dart';
import 'package:chair_pal/core/widgets/custom_snackbar.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final TextEditingController _nameController = TextEditingController();
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      CustomSnackBar.showSuccess(context: context, message: S.of(context)!.pleaseEnterCategoryName);
      return;
    }
    
    context.read<AddCategoryCubit>().createCategory(
      name: name,
      image: _selectedImage,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context)!;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leadingWidth: 100,
        leading: const CustomBackButton(),
        title: Text(
          l10n.addCategory,
          style: AppStyles.h3.copyWith(color: AppColors.primaryDark),
        ),
      ),
      body: BlocConsumer<AddCategoryCubit, AddCategoryState>(
        listener: (context, state) {
          if (state is AddCategorySuccess) {
            CustomSnackBar.showSuccess(context: context, message: l10n.categoryAddedSuccessfully);
            Navigator.pop(context, true); // Return true to signal refresh
          } else if (state is AddCategoryError) {
            CustomSnackBar.showSuccess(context: context, message: state.message);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.categoryName,
                  style: AppStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                ),
                SizedBox(height: 8.h),
                CustomTextField(
                  controller: _nameController,
                  hintText: l10n.categoryNameHint,
                  prefixIcon: Icon(Icons.share_outlined, color: AppColors.textSecondary, size: 20.sp),
                ),
                SizedBox(height: 24.h),
                Text(
                  l10n.logo,
                  style: AppStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                ),
                SizedBox(height: 8.h),
                GestureDetector(
                  onTap: _pickImage,
                  child: DottedBorder(
                    options: RoundedRectDottedBorderOptions(
                      color: AppColors.primary.withValues(alpha: 0.5),
                      strokeWidth: 1.5,
                      dashPattern: const [8, 4],
                      radius: Radius.circular(12.r),
                    ),
                    child: Container(
                      width: double.infinity,
                      height: 200.h,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: _selectedImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12.r),
                              child: Image.file(_selectedImage!, fit: BoxFit.cover),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.cloud_upload_outlined, color: AppColors.primary, size: 40.sp),
                                SizedBox(height: 12.h),
                                Text(
                                  l10n.dragDropImage,
                                  style: AppStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
                SizedBox(height: 48.h),
                CustomButton(
                  text: l10n.addCategory,
                  onPressed: state is AddCategoryLoading ? null : _submit,
                  isLoading: state is AddCategoryLoading,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
