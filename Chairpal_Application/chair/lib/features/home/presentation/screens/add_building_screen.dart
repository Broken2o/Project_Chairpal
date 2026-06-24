import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';

import '../../../../features/auth/presentation/screens/pick_location_page.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_snackbar.dart';
import '../../domain/entities/place.dart';
import '../cubit/add_building_cubit/add_building_cubit.dart';
import '../cubit/add_building_cubit/add_building_state.dart';
import '../cubit/building_list_cubit/building_list_cubit.dart';
import '../../../../l10n/l10n.dart';
import 'package:chair_pal/core/widgets/custom_back_button.dart';

class AddBuildingScreen extends StatefulWidget {
  final Place organization;

  const AddBuildingScreen({super.key, required this.organization});

  @override
  State<AddBuildingScreen> createState() => _AddBuildingScreenState();
}

class _AddBuildingScreenState extends State<AddBuildingScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  double? _latitude;
  double? _longitude;

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

  Future<void> _fetchLocation() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PickLocationPage()),
    );

    if (result != null && result is Map<String, dynamic>) {
      final latLng = result['latLng'];
      final address = result['address'] as String?;

      if (latLng != null) {
        setState(() {
          _latitude = latLng.latitude;
          _longitude = latLng.longitude;

          if (address != null && address.isNotEmpty) {
            _locationController.text = address;
          } else {
            _locationController.text = 'Lat: ${_latitude?.toStringAsFixed(4)}, Lng: ${_longitude?.toStringAsFixed(4)}';
          }
        });
      }
    }
  }

  void _submit(BuildContext innerContext) {
    if (_formKey.currentState!.validate()) {
      if (_latitude == null || _longitude == null) {
        CustomSnackBar.showError(context: context, message: S.of(context)!.pleaseSetLocationFirst);
        return;
      }

      innerContext.read<AddBuildingCubit>().createBuilding(
        organizationId: int.parse(widget.organization.id),
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        image: _selectedImage,
        latitude: _latitude,
        longitude: _longitude,
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context)!;
    return BlocProvider(
      create: (context) => sl<AddBuildingCubit>(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          leadingWidth: 100.w,
          leading: const CustomBackButton(),
          title: Text(
            l10n.addBuilding,
            style: AppStyles.h3PrimaryDark.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        body: BlocConsumer<AddBuildingCubit, AddBuildingState>(
          listener: (context, state) {
            if (state is AddBuildingSuccess) {
              CustomSnackBar.showSuccess(
                context: context,
                message: l10n.buildingAddedSuccessfully,
              );
              context.read<BuildingListCubit>().fetchBuildings(int.parse(widget.organization.id));
              Navigator.pop(context);
            } else if (state is AddBuildingError) {
              CustomSnackBar.showError(
                context: context,
                message: state.message,
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Building Name
                    Text(l10n.buildingName, style: AppStyles.bodySmall.copyWith(color: Colors.grey)),
                    SizedBox(height: 8.h),
                    CustomTextField(
                      controller: _nameController,
                      hintText: l10n.buildingNameHint,
                      prefixIcon: Icon(Icons.business_outlined, color: AppColors.primaryDark),
                      validator: (value) => value == null || value.isEmpty ? l10n.requiredField : null,
                    ),
                    SizedBox(height: 16.h),

                    // Location
                    Text(l10n.location, style: AppStyles.bodySmall.copyWith(color: Colors.grey)),
                    SizedBox(height: 8.h),
                    CustomTextField(
                      controller: _locationController,
                      hintText: l10n.enterOrganizationLocationHint,
                      readOnly: true,
                      onTap: _fetchLocation,
                      prefixIcon: Icon(Icons.location_on_outlined, color: Colors.grey),
                      suffixIcon: Icon(Icons.chevron_right, color: AppColors.primaryDark),
                      validator: (value) => value == null || value.isEmpty ? l10n.requiredField : null,
                    ),
                    SizedBox(height: 16.h),

                    // Image of Organization
                    Text(l10n.imageOfOrganization, style: AppStyles.bodySmall.copyWith(color: Colors.grey)),
                    SizedBox(height: 8.h),
                    GestureDetector(
                      onTap: _pickImage,
                      child: DottedBorder(
                        options: RoundedRectDottedBorderOptions(
                          color: AppColors.primary,
                          strokeWidth: 1.5,
                          dashPattern: const [8, 4],
                          radius: Radius.circular(12.r),
                          padding: EdgeInsets.all(4.w),
                        ),
                        child: Container(
                          height: 180.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0FAFA),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: _selectedImage != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10.r),
                                  child: Image.file(
                                    _selectedImage!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.cloud_upload_outlined, color: AppColors.primary, size: 40.sp),
                                    SizedBox(height: 12.h),
                                    Text(
                                      l10n.dragDropImage,
                                      style: AppStyles.bodySmall.copyWith(color: Colors.grey),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Description
                    Text(l10n.description, style: AppStyles.bodySmall.copyWith(color: Colors.grey)),
                    SizedBox(height: 8.h),
                    CustomTextField(
                      controller: _descriptionController,
                      hintText: l10n.typeDescriptionHere,
                      maxLines: 4,
                    ),
                    SizedBox(height: 48.h),

                    // Confirm Button
                    CustomButton(
                      text: l10n.confirm,
                      onPressed: () => _submit(context),
                      isLoading: state is AddBuildingLoading,
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
