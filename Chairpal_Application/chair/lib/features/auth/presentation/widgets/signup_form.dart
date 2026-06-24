import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../l10n/l10n.dart';
import '../cubit/signup_cubit/signup_cubit.dart';
import '../cubit/signup_cubit/signup_state.dart';
import '../screens/pick_location_page.dart';
import 'package:chair_pal/core/widgets/custom_snackbar.dart';

class SignupForm extends StatefulWidget {
  final String? role;
  final List<int>? medicalConditionIds;

  const SignupForm({
    super.key,
    this.role,
    this.medicalConditionIds,
  });

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final _phoneController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _doctorUsernameController = TextEditingController();
  final _targetUsernameController = TextEditingController();
  final _categoryNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  double? _latitude;
  double? _longitude;
  String? _cityName;
  String? _countryName;

  // Phone Field
  String? _phoneNumber;
  String? _selectedGender;

  // Logo Picker
  XFile? _logoImage;
  final ImagePicker _picker = ImagePicker();

  // Policies
  bool _agreedToPolicies = false;

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    if (image != null) {
      setState(() {
        _logoImage = image;
      });
    }
  }

  final bool _isFollowDoctor = false;

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    _phoneController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _birthDateController.dispose();
    _doctorUsernameController.dispose();
    _targetUsernameController.dispose();
    _categoryNameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Default to 'user' if not specified, though logic should prevent this
    final isOrganization = widget.role == 'organization';
    final isUser = widget.role == 'user';
    final isCompanion = widget.role == 'companion';
    final isDoctor = widget.role == 'doctor';

    return BlocBuilder<SignupCubit, SignupState>(
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                controller: _nameController,
                hintText: S.of(context)!.nameHint,
                labelText: S.of(context)!.name,
                keyboardType: TextInputType.name,
                prefixIcon: const Icon(
                  Icons.person_outline,
                  color: AppColors.textSecondary,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return S.of(context)!.pleaseEnterName;
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.h),
              CustomTextField(
                controller: _usernameController,
                hintText: S.of(context)!.username,
                labelText: S.of(context)!.username,
                keyboardType: TextInputType.name,
                prefixIcon: const Icon(
                  Icons.person_pin_circle_outlined,
                  color: AppColors.textSecondary,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return S.of(context)!.pleaseEnterUsername;
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.h),
              CustomTextField(
                controller: _emailController,
                hintText: S.of(context)!.emailHint,
                labelText: S.of(context)!.email,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(
                  Icons.email_outlined,
                  color: AppColors.textSecondary,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return S.of(context)!.pleaseEnterEmail;
                  }
                  final emailRegex = RegExp(
                    r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
                  );
                  if (!emailRegex.hasMatch(value)) {
                    return S.of(context)!.pleaseEnterValidEmail;
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.h),
              CustomTextField(
                controller: _passwordController,
                hintText: S.of(context)!.passwordHint,
                labelText: S.of(context)!.password,
                obscureText: state.isPasswordVisible,
                prefixIcon: const Icon(
                  Icons.lock_outline,
                  color: AppColors.textSecondary,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    state.isPasswordVisible
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: () {
                    context.read<SignupCubit>().togglePasswordVisibility();
                  },
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return S.of(context)!.pleaseEnterPassword;
                  }
                  if (value.length < 6) {
                    return S.of(context)!.passwordTooShort;
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.h),
              // Confirm Password
              CustomTextField(
                controller: _passwordConfirmController,
                hintText: S.of(context)!.passwordHint, // Or specific hint
                labelText: S.of(context)!.confirmPassword,
                obscureText: state.isPasswordVisible,
                prefixIcon: const Icon(
                  Icons.lock_outline,
                  color: AppColors.textSecondary,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return S.of(context)!.pleaseConfirmPassword;
                  }
                  if (value != _passwordController.text) {
                    return S.of(context)!.passwordsDoNotMatch;
                  }
                  return null;
                },
              ),
              if (!isDoctor) ...[
                SizedBox(height: 20.h),
                IntlPhoneField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: S.of(context)!.phoneNumber,
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
                  ),
                  initialCountryCode: 'EG',
                  validator: (phone) {
                    if (phone == null || phone.number.isEmpty) {
                      return S.of(context)!.pleaseEnterPhoneNumber;
                    }
                    return null;
                  },
                  onChanged: (phone) {
                    _phoneNumber = phone.completeNumber;
                  },
                ),
              ],
              if (isUser) ...[
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: S.of(context)!.gender,
                    prefixIcon: const Icon(Icons.person, color: AppColors.textSecondary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
                  ),
                  initialValue: _selectedGender,
                  items: [
                    DropdownMenuItem(value: 'male', child: Text(S.of(context)!.male)),
                    DropdownMenuItem(value: 'female', child: Text(S.of(context)!.female)),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                  validator: (value) => value == null ? S.of(context)!.pleaseSelectGender : null,
                ),
                SizedBox(height: 20.h),
                CustomTextField(
                  controller: _birthDateController,
                  hintText: S.of(context)!.birthDateHint,
                  labelText: S.of(context)!.birthDate,
                  readOnly: true,
                  prefixIcon: const Icon(
                    Icons.calendar_today_outlined,
                    color: AppColors.textSecondary,
                  ),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      _birthDateController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                    }
                  },
                  validator: (value) => value == null || value.isEmpty ? S.of(context)!.pleaseSelectBirthDate : null,
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _weightController,
                        hintText: S.of(context)!.weightKg,
                        labelText: S.of(context)!.weight,
                        keyboardType: TextInputType.number,
                        validator: (value) => value == null || value.isEmpty ? S.of(context)!.required : null,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: CustomTextField(
                        controller: _heightController,
                        hintText: S.of(context)!.heightCm,
                        labelText: S.of(context)!.height,
                        keyboardType: TextInputType.number,
                        validator: (value) => value == null || value.isEmpty ? S.of(context)!.required : null,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                CustomTextField(
                  controller: _doctorUsernameController,
                  hintText: S.of(context)!.doctorUsername,
                  labelText: S.of(context)!.doctorUsername,
                  keyboardType: TextInputType.text,
                ),
              ],
              if (isCompanion) ...[
                SizedBox(height: 20.h),
                CustomTextField(
                  controller: _targetUsernameController,
                  hintText: S.of(context)!.targetUsername,
                  labelText: S.of(context)!.targetUsername,
                  keyboardType: TextInputType.text,
                  validator: (value) => value == null || value.isEmpty ? S.of(context)!.required : null,
                ),
              ],
              if (isOrganization) ...[
                SizedBox(height: 20.h),
                CustomTextField(
                  controller: _categoryNameController,
                  hintText: S.of(context)!.categoryName,
                  labelText: S.of(context)!.categoryName,
                  keyboardType: TextInputType.text,
                  validator: (value) => value == null || value.isEmpty ? S.of(context)!.required : null,
                ),
                SizedBox(height: 20.h),
                CustomTextField(
                  controller: _descriptionController,
                  hintText: S.of(context)!.description,
                  labelText: S.of(context)!.description,
                  maxLines: 3,
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: 20.h),
                CustomTextField(
                  controller: _locationController,
                  hintText: S.of(context)!.enterLocation,
                  labelText: S.of(context)!.location,
                  readOnly: true,
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PickLocationPage(),
                      ),
                    );

                    if (result != null && result is Map) {
                      _locationController.text = result['address'];
                      _latitude = result['latLng']?.latitude;
                      _longitude = result['latLng']?.longitude;
                      _cityName = result['cityName'];
                      _countryName = result['countryName'];
                    }
                  },
                ),
                SizedBox(height: 24.h),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context)!.logo,
                      style: AppStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 150.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1FDFB), // Light teal/cyan
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            style:
                                BorderStyle.solid, // Should be dotted ideally
                          ),
                        ),
                        child: _logoImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12.r),
                                child: Image.file(
                                  File(_logoImage!.path),
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.cloud_upload_outlined,
                                    size: 32,
                                    color: AppColors.primary,
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    S.of(context)!.dragDropImage,
                                    style: AppStyles.bodySmall.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ],
              SizedBox(height: 24.h),
              // Policies Checkbox
              Row(
                children: [
                  Checkbox(
                    value: _agreedToPolicies,
                    onChanged: (value) {
                      setState(() {
                        _agreedToPolicies = value ?? false;
                      });
                    },
                    activeColor: AppColors.primary,
                  ),
                  Expanded(
                    child: Text(
                      S.of(context)!.agreeToPolicy,
                      style: AppStyles.bodySmall,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              CustomButton(
                text: S.of(context)!.createAccount,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (isOrganization && _logoImage == null) {
                      CustomSnackBar.showError(context: context, message: S.of(context)!.pleaseUploadLogo);
                      return;
                    }
                    if (!_agreedToPolicies) {
                      CustomSnackBar.showError(context: context, message: S.of(context)!.pleaseAgreeToPolicy);
                      return;
                    }

                    context.read<SignupCubit>().signup(
                      name: _nameController.text,
                      username: _usernameController.text,
                      email: _emailController.text,
                      password: _passwordController.text,
                      passwordConfirmation: _passwordConfirmController.text,
                      policies: _agreedToPolicies ? 1 : 0,
                      role: widget.role ?? 'user',
                      phone: _phoneNumber ?? _phoneController.text,
                      gender: isUser ? _selectedGender : null,
                      birthDate: isUser && _birthDateController.text.isNotEmpty ? _birthDateController.text : null,
                      weight: isUser ? num.tryParse(_weightController.text) : null,
                      height: isUser ? num.tryParse(_heightController.text) : null,
                      medicalConditionIds: isUser ? widget.medicalConditionIds : null,
                      doctorUsername: isUser && _doctorUsernameController.text.isNotEmpty ? _doctorUsernameController.text : null,
                      targetUsername: isCompanion && _targetUsernameController.text.isNotEmpty ? _targetUsernameController.text : null,
                      categoryName: isOrganization && _categoryNameController.text.isNotEmpty ? _categoryNameController.text : null,
                      description: isOrganization && _descriptionController.text.isNotEmpty ? _descriptionController.text : null,
                      isFollowDoctor: _isFollowDoctor,
                      location: isOrganization ? _locationController.text : null,
                      latitude: isOrganization ? _latitude : null,
                      longitude: isOrganization ? _longitude : null,
                      countryName: isOrganization ? _countryName : null,
                      cityName: isOrganization ? _cityName : null,
                      image: isOrganization ? _logoImage : null,
                    );
                  }
                },
                isLoading: state.status == SignupStatus.loading,
                width: double.infinity,
              ),
            ],
          ),
        );
      },
    );
  }
}
