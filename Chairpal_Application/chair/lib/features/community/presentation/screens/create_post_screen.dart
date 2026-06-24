import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../l10n/l10n.dart';
import '../cubit/create_post_cubit.dart';
import '../../../auth/presentation/cubit/user_cubit/user_cubit.dart';
import '../../../auth/presentation/cubit/user_cubit/user_state.dart';
import 'package:chair_pal/core/widgets/custom_back_button.dart';
import 'package:chair_pal/core/widgets/custom_snackbar.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _contentController = TextEditingController();
  List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage(
      imageQuality: 80,
    );
    if (images.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(images.map((img) => File(img.path)));
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _submit() {
    final content = _contentController.text.trim();
    if (content.isNotEmpty || _selectedImages.isNotEmpty) {
      context.read<CreatePostCubit>().createPost(
        content,
        images: _selectedImages.isNotEmpty ? _selectedImages : null,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreatePostCubit, CreatePostState>(
      listener: (context, state) {
        if (state is CreatePostSuccess) {
          Navigator.pop(context, true); // Return success to refresh feed
        } else if (state is CreatePostError) {
          CustomSnackBar.showSuccess(context: context, message: state.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.scaffoldBackground,
          elevation: 0,
          leadingWidth: 100,
        leading: const CustomBackButton(),
          title: Text(
            S.of(context)!.addNewPostPrompt,
            style: AppStyles.h3.copyWith(color: AppColors.primaryDark),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: BlocBuilder<CreatePostCubit, CreatePostState>(
                builder: (context, state) {
                  final isLoading = state is CreatePostLoading;
                  return ElevatedButton(
                    onPressed: isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                    ),
                    child: isLoading 
                        ? SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Text('Post'),
                  );
                },
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.all(16.0.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BlocBuilder<UserCubit, UserState>(
                        builder: (context, userState) {
                          String name = 'User';
                          String? image;
                          if (userState is UserLoaded) {
                            name = userState.user.name;
                            image = userState.user.image;
                          }
                          return Row(
                            children: [
                              CircleAvatar(
                                radius: 24.r,
                                backgroundImage: image != null ? NetworkImage(image) : null,
                                backgroundColor: Colors.grey[200],
                                child: image == null ? Icon(Icons.person, color: Colors.grey[400]) : null,
                              ),
                              SizedBox(width: 12.w),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: AppStyles.h3.copyWith(fontWeight: FontWeight.bold, color: AppColors.primaryDark),
                                  ),
                                  SizedBox(height: 4.h),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(4.r),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.public, size: 12.sp, color: Colors.grey[700]),
                                        SizedBox(width: 4.w),
                                        Text('Public', style: AppStyles.bodySmall.copyWith(color: Colors.grey[700], fontWeight: FontWeight.bold)),
                                        Icon(Icons.arrow_drop_down, size: 16.sp, color: Colors.grey[700]),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: 16.h),
                      TextField(
                        controller: _contentController,
                        maxLines: null,
                        minLines: 3,
                        style: AppStyles.bodyLarge.copyWith(fontSize: 18.sp),
                        decoration: InputDecoration(
                          hintText: "What's on your mind?",
                          border: InputBorder.none,
                          hintStyle: AppStyles.bodyLarge.copyWith(color: AppColors.textHint, fontSize: 18.sp),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      if (_selectedImages.isNotEmpty) _buildImageGrid(),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Add to your post',
                          style: AppStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600, color: AppColors.primaryDark),
                        ),
                      ),
                      IconButton(
                        onPressed: _pickImages,
                        icon: const Icon(Icons.photo_library, color: Colors.green),
                        tooltip: 'Photo/Video',
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.person_add_alt_1, color: Colors.blue),
                        tooltip: 'Tag people',
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.emoji_emotions_outlined, color: Colors.orange),
                        tooltip: 'Feeling/Activity',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageGrid() {
    if (_selectedImages.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[300]!),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          _buildGridContent(),
          Positioned(
            top: 8.h,
            right: 8.w,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedImages.clear();
                });
              },
              child: Container(
                padding: EdgeInsets.all(6.r),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.close, size: 20.sp, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridContent() {
    final count = _selectedImages.length;
    
    if (count == 1) {
      return Image.file(
        _selectedImages[0],
        width: double.infinity,
        fit: BoxFit.cover,
      );
    } else if (count == 2) {
      return Row(
        children: [
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: Image.file(_selectedImages[0], fit: BoxFit.cover),
            ),
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: Image.file(_selectedImages[1], fit: BoxFit.cover),
            ),
          ),
        ],
      );
    } else if (count == 3) {
      return Column(
        children: [
          AspectRatio(
            aspectRatio: 2,
            child: Image.file(_selectedImages[0], width: double.infinity, fit: BoxFit.cover),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1.5,
                  child: Image.file(_selectedImages[1], fit: BoxFit.cover),
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1.5,
                  child: Image.file(_selectedImages[2], fit: BoxFit.cover),
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      // 4 or more
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.file(_selectedImages[0], fit: BoxFit.cover),
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.file(_selectedImages[1], fit: BoxFit.cover),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.file(_selectedImages[2], fit: BoxFit.cover),
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.file(_selectedImages[3], fit: BoxFit.cover),
                      if (count > 4)
                        Container(
                          color: Colors.black54,
                          alignment: Alignment.center,
                          child: Text(
                            '+${count - 4}',
                            style: AppStyles.h2.copyWith(color: Colors.white, fontSize: 32.sp),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }
  }
}
