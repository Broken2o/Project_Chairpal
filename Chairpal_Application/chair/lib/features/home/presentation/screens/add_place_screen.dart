import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_snackbar.dart';
import '../../domain/entities/place.dart';
import '../cubit/add_place_cubit/add_place_cubit.dart';
import '../cubit/add_place_cubit/add_place_state.dart';
import '../cubit/place_list_cubit/place_list_cubit.dart';
import '../../../../l10n/l10n.dart';
import 'package:chair_pal/core/widgets/custom_back_button.dart';

import '../cubit/edit_delete_cubit/edit_delete_cubit.dart';
import '../cubit/edit_delete_cubit/edit_delete_state.dart';

class AddPlaceScreen extends StatefulWidget {
  final Place floor;
  final Place? placeToEdit;

  const AddPlaceScreen({super.key, required this.floor, this.placeToEdit});

  @override
  State<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.placeToEdit?.name ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.placeToEdit?.description ?? '',
    );
  }

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

  void _submit(BuildContext innerContext) {
    if (_formKey.currentState!.validate()) {
      if (widget.placeToEdit != null) {
        innerContext.read<EditDeleteCubit>().updatePlace(
          int.parse(widget.placeToEdit!.id),
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
          image: _selectedImage,
        );
      } else {
        innerContext.read<AddPlaceCubit>().createPlace(
          floorId: int.parse(widget.floor.id),
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
          image: _selectedImage,
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context)!;
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<AddPlaceCubit>()),
        BlocProvider(create: (context) => sl<EditDeleteCubit>()),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          leadingWidth: 100.w,
          leading: const CustomBackButton(),
          title: Text(
            widget.placeToEdit != null ? l10n.editPlace : l10n.addNewPlace,
            style: AppStyles.h3PrimaryDark.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<AddPlaceCubit, AddPlaceState>(
              listener: (context, state) {
                if (state is AddPlaceSuccess) {
                  CustomSnackBar.showSuccess(
                    context: context,
                    message: l10n.placeAddedSuccessfully,
                  );
                  context.read<PlaceListCubit>().fetchPlaces(
                    int.parse(widget.floor.id),
                  );
                  Navigator.pop(context);
                } else if (state is AddPlaceError) {
                  CustomSnackBar.showError(
                    context: context,
                    message: state.message,
                  );
                }
              },
            ),
            BlocListener<EditDeleteCubit, EditDeleteState>(
              listener: (context, state) {
                if (state is EditDeleteSuccess) {
                  CustomSnackBar.showSuccess(
                    context: context,
                    message: "Place updated successfully",
                  );
                  // Refresh place list
                  if (widget.floor.id != "0") {
                    context.read<PlaceListCubit>().fetchPlaces(
                      int.parse(widget.floor.id),
                    );
                  }
                  Navigator.pop(context);
                } else if (state is EditDeleteError) {
                  CustomSnackBar.showError(
                    context: context,
                    message: state.message,
                  );
                }
              },
            ),
          ],
          child: BlocBuilder<AddPlaceCubit, AddPlaceState>(
            builder: (context, addState) {
              return BlocBuilder<EditDeleteCubit, EditDeleteState>(
                builder: (context, editState) {
                  final isLoading =
                      addState is AddPlaceLoading ||
                      editState is EditDeleteLoading;
                  return SingleChildScrollView(
                    padding: EdgeInsets.all(24.w),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image Picker
                          GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              height: 160.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(
                                  color: AppColors.primaryLight,
                                  width: 1.5,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              child: _selectedImage != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(16.r),
                                      child: Image.file(
                                        _selectedImage!,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.cloud_upload_outlined,
                                          color: AppColors.primary,
                                          size: 40.sp,
                                        ),
                                        SizedBox(height: 12.h),
                                        Text(
                                          l10n.uploadPlaceImage,
                                          style: AppStyles.bodyMedium.copyWith(
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                          SizedBox(height: 24.h),

                          // Name
                          Text(
                            l10n.placeName,
                            style: AppStyles.labelPrimaryDark,
                          ),
                          SizedBox(height: 8.h),
                          CustomTextField(
                            controller: _nameController,
                            hintText: l10n.placeNameHint,
                            validator: (value) => value == null || value.isEmpty
                                ? 'Required'
                                : null,
                          ),
                          SizedBox(height: 16.h),

                          // Description
                          Text(
                            l10n.descriptionOptional,
                            style: AppStyles.labelPrimaryDark,
                          ),
                          SizedBox(height: 8.h),
                          CustomTextField(
                            controller: _descriptionController,
                            hintText: l10n.placeDescriptionHint,
                            maxLines: 4,
                          ),
                          SizedBox(height: 40.h),

                          // Submit Button
                          CustomButton(
                            text: widget.placeToEdit != null
                                ? l10n.editPlace
                                : l10n.addPlace,
                            onPressed: () => _submit(context),
                            isLoading: isLoading,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
