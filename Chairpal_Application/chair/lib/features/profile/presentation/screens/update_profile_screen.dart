import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../core/constants/assets.dart';
import '../../../../l10n/l10n.dart';
import '../../../../features/auth/presentation/cubit/user_cubit/user_cubit.dart';
import '../../../../features/auth/presentation/cubit/user_cubit/user_state.dart';
import '../cubit/profile_update_cubit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/di/injection_container.dart' as di;
import 'package:chair_pal/core/widgets/custom_back_button.dart';
import 'package:chair_pal/core/widgets/custom_snackbar.dart';

class HeaderCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
      size.width / 2, size.height - 120.h,
      size.width, size.height,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class NotchClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final radius = 24.0.r;
    final notchRadius = 40.0.r; // slightly larger than avatar radius

    path.moveTo(0, radius);
    path.arcToPoint(Offset(radius, 0), radius: Radius.circular(radius));

    final center = size.width / 2;
    path.lineTo(center - notchRadius, 0);

    path.arcToPoint(
      Offset(center + notchRadius, 0),
      radius: Radius.circular(notchRadius),
      clockwise: false,
    );

    path.lineTo(size.width - radius, 0);
    path.arcToPoint(Offset(size.width, radius), radius: Radius.circular(radius));

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class UpdateProfileScreen extends StatelessWidget {
  const UpdateProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<ProfileUpdateCubit>()..fetchConnectedDoctor(),
      child: const _UpdateProfileView(),
    );
  }
}

class _UpdateProfileView extends StatefulWidget {
  const _UpdateProfileView();

  @override
  State<_UpdateProfileView> createState() => _UpdateProfileViewState();
}

class _UpdateProfileViewState extends State<_UpdateProfileView> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _phoneController;
  late TextEditingController _weightController;
  late TextEditingController _heightController;

  String? _phoneNumber;
  String? _selectedGender;
  DateTime? _selectedBirthDate;
  bool _logoutOtherDevices = false;
  String _initialCountryCode = 'EG';

  XFile? _profileImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _usernameController = TextEditingController();
    _phoneController = TextEditingController();
    _weightController = TextEditingController();
    _heightController = TextEditingController();

    final userState = context.read<UserCubit>().state;
    if (userState is UserLoaded) {
      final user = userState.user;
      _nameController.text = user.name;
      _usernameController.text = user.username ?? '';

      // Separate country code from national number
      final rawPhone = user.phone ?? '';
      _phoneNumber = rawPhone.isEmpty ? null : rawPhone;
      if (rawPhone.startsWith('+')) {
        // Try known prefixes (longest first to avoid mis-matching)
        const dialCodes = {
          '+213': 'DZ', '+244': 'AO', '+251': 'ET', '+212': 'MA',
          '+216': 'TN', '+218': 'LY', '+220': 'GM', '+221': 'SN',
          '+233': 'GH', '+234': 'NG', '+249': 'SD', '+966': 'SA',
          '+971': 'AE', '+974': 'QA', '+962': 'JO', '+961': 'LB',
          '+963': 'SY', '+964': 'IQ', '+968': 'OM', '+967': 'YE',
          '+44':  'GB', '+49':  'DE', '+33':  'FR', '+39':  'IT',
          '+34':  'ES', '+31':  'NL', '+46':  'SE', '+47':  'NO',
          '+1':   'US', '+7':   'RU', '+20':  'EG', '+91':  'IN',
          '+86':  'CN', '+81':  'JP', '+82':  'KR', '+55':  'BR',
        };
        String matched = '';
        for (final entry in dialCodes.entries) {
          if (rawPhone.startsWith(entry.key) && entry.key.length > matched.length) {
            matched = entry.key;
            _initialCountryCode = entry.value;
          }
        }
        _phoneController.text = matched.isNotEmpty
            ? rawPhone.substring(matched.length)
            : rawPhone.substring(1);
      } else {
        _phoneController.text = rawPhone;
      }
      _selectedGender = user.gender;
      _weightController.text = user.weight?.toString() ?? '';
      _heightController.text = user.height?.toString() ?? '';

      if (user.birthDate != null && user.birthDate!.isNotEmpty) {
        try {
          _selectedBirthDate = DateTime.parse(user.birthDate!);
        } catch (_) {}
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final l10n = S.of(context)!;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              SizedBox(height: 30.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOptionIcon(
                    icon: Icons.remove_red_eye_outlined,
                    label: 'View',
                    onTap: () {
                      Navigator.pop(context);
                      _viewProfileImage();
                    },
                  ),
                  _buildOptionIcon(
                    icon: Icons.photo_library_outlined,
                    label: l10n.gallery,
                    onTap: () async {
                      Navigator.pop(context);
                      if (Platform.isAndroid) {
                        final status = await Permission.photos.request();
                        if (status.isPermanentlyDenied) {
                          openAppSettings();
                          return;
                        }
                      } else {
                        final status = await Permission.photos.request();
                        if (status.isPermanentlyDenied) {
                          openAppSettings();
                          return;
                        }
                      }
                      final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
                      if (image != null) setState(() => _profileImage = image);
                    },
                  ),
                  _buildOptionIcon(
                    icon: Icons.camera_alt_outlined,
                    label: l10n.camera,
                    onTap: () async {
                      Navigator.pop(context);
                      final status = await Permission.camera.request();
                      if (status.isPermanentlyDenied) {
                        openAppSettings();
                        return;
                      }
                      final XFile? image = await _picker.pickImage(source: ImageSource.camera, imageQuality: 80);
                      if (image != null) setState(() => _profileImage = image);
                    },
                  ),
                ],
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionIcon({required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 28.r),
          ),
          SizedBox(height: 8.h),
          Text(label, style: AppStyles.bodyMedium.copyWith(color: AppColors.primaryDark)),
        ],
      ),
    );
  }

  void _viewProfileImage() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          alignment: Alignment.center,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                color: Colors.black87,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            InteractiveViewer(
              panEnabled: true,
              boundaryMargin: const EdgeInsets.all(20),
              minScale: 0.5,
              maxScale: 4,
              child: _profileImage != null
                  ? Image.file(File(_profileImage!.path))
                  : (context.read<UserCubit>().state is UserLoaded && (context.read<UserCubit>().state as UserLoaded).user.image != null)
                      ? Image.network((context.read<UserCubit>().state as UserLoaded).user.image!)
                      : CircleAvatar(
                          radius: 100.r,
                          backgroundColor: Colors.grey.shade200,
                          child: Icon(Icons.person, size: 100.r, color: Colors.grey),
                        ),
            ),
            Positioned(
              top: 40.h,
              right: 20.w,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        text,
        style: AppStyles.bodyMediumHint,
      ),
    );
  }

  InputDecoration _buildInputDecoration({Widget? prefixIcon, String? hintText, bool disabled = false}) {
    return InputDecoration(
      filled: true,
      fillColor: disabled ? Colors.grey.shade100 : Colors.white,
      hintText: hintText,
      hintStyle: AppStyles.bodyMediumHint,
      prefixIcon: prefixIcon,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(color: disabled ? Colors.grey.shade300 : AppColors.border),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white, // White background as requested
      extendBodyBehindAppBar: true, // Let the curve go up to the top
      appBar: AppBar(
        title: Text(
          l10n.myAccount,
          style: AppStyles.h3.copyWith(color: AppColors.textWhite),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const CustomBackButton(),
        leadingWidth: 80.w,
      ),
      body: BlocConsumer<ProfileUpdateCubit, ProfileUpdateState>(
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
        builder: (context, state) {
          bool isLoading = state is ProfileUpdateLoading;

          return Stack(
            children: [
              // Background SVG
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SvgPicture.asset(
                  Assets.svgBg,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.fitWidth,
                ),
              ),

              // Scrollable Content
              SafeArea(
                child: Column(
                  children: [
                    SizedBox(height: 10.h), // Space below AppBar
                    Expanded(
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          // Rectangle info card with image curve from top
                          Positioned.fill(
                            top: 35.r,
                            child: Container(
                              margin: EdgeInsets.only(
                                left: 20.w,
                                right: 20.w,
                                bottom: 20.h,
                              ),
                              child: PhysicalShape(
                                color: Colors.white,
                                clipper: NotchClipper(),
                                elevation: 2, // Subtle shadow to define the card against white bg
                                shadowColor: Colors.black.withAlpha(20),
                                child: Form(
                                  key: _formKey,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 60.0),
                                    child: SingleChildScrollView(
                                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [ // Space for Avatar

                                        _buildLabel(l10n.name),
                                        TextFormField(
                                          controller: _nameController,
                                          style: AppStyles.bodyLarge.copyWith(color: AppColors.primaryDark),
                                          decoration: _buildInputDecoration(
                                            prefixIcon: const Icon(Icons.person, color: AppColors.textHint),
                                          ),
                                          validator: (val) => val == null || val.isEmpty ? l10n.required : null,
                                        ),
                                        SizedBox(height: 20.h),

                                        _buildLabel(l10n.username),
                                        TextFormField(
                                          controller: _usernameController,
                                          style: AppStyles.bodyLarge.copyWith(color: AppColors.primaryDark),
                                          decoration: _buildInputDecoration(
                                            prefixIcon: const Icon(Icons.alternate_email, color: AppColors.textHint),
                                          ),
                                          validator: (val) => val == null || val.isEmpty ? l10n.required : null,
                                        ),
                                        SizedBox(height: 20.h),

                                        _buildLabel(l10n.phoneNumber),
                                        Directionality(
                                          textDirection: TextDirection.ltr,
                                          child: IntlPhoneField(
                                            controller: _phoneController,
                                            style: AppStyles.bodyLarge.copyWith(color: AppColors.primaryDark),
                                            decoration: _buildInputDecoration(),
                                            initialCountryCode: _initialCountryCode,
                                            showDropdownIcon: true,
                                            dropdownIconPosition: IconPosition.trailing,
                                            dropdownIcon: Icon(Icons.unfold_more, color: AppColors.textHint, size: 20),
                                            flagsButtonPadding: EdgeInsets.only(left: 16.w),
                                            onChanged: (phone) {
                                              _phoneNumber = phone.completeNumber;
                                            },
                                          ),
                                        ),
                                        SizedBox(height: 20.h),

                                        _buildLabel(l10n.gender),
                                        Row(
                                          children: [
                                            _buildGenderOption('male', l10n.male, Icons.male),
                                            SizedBox(width: 16.w),
                                            _buildGenderOption('female', l10n.female, Icons.female),
                                          ],
                                        ),
                                        SizedBox(height: 20.h),

                                        _buildLabel(l10n.birthDate),
                                        TextFormField(
                                          readOnly: true,
                                          onTap: () async {
                                            final initialDate = _selectedBirthDate ?? DateTime.now().subtract(const Duration(days: 365 * 18));
                                            final picked = await showDatePickerDialog(
                                              context: context,
                                              selectedDate: initialDate,
                                              displayedDate: initialDate,
                                              minDate: DateTime(1900),
                                              maxDate: DateTime.now().subtract(const Duration(days: 1)),
                                              theme: DatePickerPlusTheme(
                                                headerTheme: HeaderTheme(
                                                  centerLeadingDate: true,
                                                  leadingDateTextStyle: AppStyles.bodyLarge.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    color: AppColors.primary,
                                                  ),
                                                ),
                                                daysPickerTheme: DaysPickerTheme(
                                                  daysOfTheWeekTheme: DaysOfTheWeekTheme(
                                                    textStyle: AppStyles.bodyMedium.copyWith(
                                                      fontSize: 10.sp,
                                                      color: AppColors.textHint,
                                                    ),
                                                  ),
                                                  selectedCellDecoration: BoxDecoration(
                                                    color: AppColors.primary,
                                                    borderRadius: BorderRadius.circular(8.r),
                                                  ),
                                                  selectedCellTextStyle: AppStyles.bodyMedium.copyWith(
                                                    color: Colors.white,
                                                  ),
                                                  currentDateTextStyle: AppStyles.bodyMedium.copyWith(
                                                    color: AppColors.primary,
                                                  ),
                                                  enabledCellsTextStyle: AppStyles.bodyMedium.copyWith(
                                                    color: AppColors.textPrimary,
                                                  ),
                                                  disabledCellsTextStyle: AppStyles.bodyMedium.copyWith(
                                                    color: AppColors.textHint,
                                                  ),
                                                ),
                                                monthsPickerTheme: MonthsPickerTheme(
                                                  selectedCellDecoration: BoxDecoration(
                                                    color: AppColors.primary,
                                                    borderRadius: BorderRadius.circular(8.r),
                                                  ),
                                                  selectedCellTextStyle: AppStyles.bodyMedium.copyWith(
                                                    color: Colors.white,
                                                  ),
                                                  currentDateTextStyle: AppStyles.bodyMedium.copyWith(
                                                    color: AppColors.primary,
                                                  ),
                                                  enabledCellsTextStyle: AppStyles.bodyMedium.copyWith(
                                                    color: AppColors.textPrimary,
                                                  ),
                                                  disabledCellsTextStyle: AppStyles.bodyMedium.copyWith(
                                                    color: AppColors.textHint,
                                                  ),
                                                ),
                                                yearsPickerTheme: YearsPickerTheme(
                                                  selectedCellDecoration: BoxDecoration(
                                                    color: AppColors.primary,
                                                    borderRadius: BorderRadius.circular(8.r),
                                                  ),
                                                  selectedCellTextStyle: AppStyles.bodyMedium.copyWith(
                                                    color: Colors.white,
                                                  ),
                                                  currentDateTextStyle: AppStyles.bodyMedium.copyWith(
                                                    color: AppColors.primary,
                                                  ),
                                                  enabledCellsTextStyle: AppStyles.bodyMedium.copyWith(
                                                    color: AppColors.textPrimary,
                                                  ),
                                                  disabledCellsTextStyle: AppStyles.bodyMedium.copyWith(
                                                    color: AppColors.textHint,
                                                  ),
                                                ),
                                              ),
                                            );
                                            if (picked != null) {
                                              setState(() => _selectedBirthDate = picked);
                                            }
                                          },
                                          controller: TextEditingController(
                                            text: _selectedBirthDate != null
                                                ? '${_selectedBirthDate!.year}-${_selectedBirthDate!.month.toString().padLeft(2, '0')}-${_selectedBirthDate!.day.toString().padLeft(2, '0')}'
                                                : '',
                                          ),
                                          style: AppStyles.bodyLarge.copyWith(color: AppColors.primaryDark),
                                          decoration: _buildInputDecoration(
                                            prefixIcon: const Icon(Icons.calendar_today_outlined, color: AppColors.textHint),
                                            hintText: l10n.birthDateHint,
                                          ),
                                        ),
                                        SizedBox(height: 20.h),

                                        // Weight & Height in same row
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  _buildLabel(l10n.weightKg),
                                                  TextFormField(
                                                    controller: _weightController,
                                                    style: AppStyles.bodyLarge.copyWith(color: AppColors.primaryDark),
                                                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                                    decoration: _buildInputDecoration(
                                                      prefixIcon: const Icon(Icons.monitor_weight_outlined, color: AppColors.textHint),
                                                      hintText: l10n.weightKg,
                                                    ),
                                                    validator: (val) {
                                                      if (val != null && val.isNotEmpty) {
                                                        final n = num.tryParse(val);
                                                        if (n == null || n < 1) return l10n.required;
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 12.w),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  _buildLabel(l10n.heightCm),
                                                  TextFormField(
                                                    controller: _heightController,
                                                    style: AppStyles.bodyLarge.copyWith(color: AppColors.primaryDark),
                                                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                                    decoration: _buildInputDecoration(
                                                      prefixIcon: const Icon(Icons.height, color: AppColors.textHint),
                                                      hintText: l10n.heightCm,
                                                    ),
                                                    validator: (val) {
                                                      if (val != null && val.isNotEmpty) {
                                                        final n = num.tryParse(val);
                                                        if (n == null || n < 1) return l10n.required;
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 32.h),

                                        // Follow Doctor Toggle
                                        BlocBuilder<ProfileUpdateCubit, ProfileUpdateState>(
                                          buildWhen: (previous, current) => current is DoctorStatusLoaded,
                                          builder: (context, state) {
                                            final cubit = context.read<ProfileUpdateCubit>();
                                            bool isFollowingDoctor = cubit.currentConnectedDoctor != null;

                                            if (!isFollowingDoctor) return const SizedBox.shrink();

                                            return Row(
                                              children: [
                                                Text(l10n.followDoctor, style: AppStyles.bodyMediumHint),
                                                SizedBox(width: 8.w),
                                                const Icon(Icons.person_pin_outlined, color: AppColors.textHint, size: 20),
                                                const Spacer(),
                                                CupertinoSwitch(
                                                  activeTrackColor: const Color(0xFF24E051),
                                                  value: isFollowingDoctor,
                                                  onChanged: (val) {
                                                    if (!val && isFollowingDoctor) {
                                                      cubit.removeDoctor();
                                                    } else if (val && !isFollowingDoctor) {
                                                      CustomSnackBar.showSuccess(context: context, message: l10n.pleaseConnectFromDoctorSearch);
                                                    }
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        ),

                                        SizedBox(height: 16.h),

                                        // Logout Other Devices Toggle
                                        Row(
                                          children: [
                                            Text(l10n.logoutOtherDevices, style: AppStyles.bodyMediumHint),
                                            SizedBox(width: 8.w),
                                            const Icon(Icons.devices_outlined, color: AppColors.textHint, size: 20),
                                            const Spacer(),
                                            CupertinoSwitch(
                                              activeColor: AppColors.primary,
                                              value: _logoutOtherDevices,
                                              onChanged: (val) => setState(() => _logoutOtherDevices = val),
                                            ),
                                          ],
                                        ),

                                        SizedBox(height: 40.h),
                                        SizedBox(
                                          width: double.infinity,
                                          height: 56.h,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: AppColors.primary,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12.r),
                                              ),
                                              elevation: 0,
                                            ),
                                             onPressed: isLoading ? null : () {
                                              if (_formKey.currentState!.validate()) {
                                                String? birthDateFormatted;
                                                if (_selectedBirthDate != null) {
                                                  birthDateFormatted =
                                                      '${_selectedBirthDate!.year}-${_selectedBirthDate!.month.toString().padLeft(2, '0')}-${_selectedBirthDate!.day.toString().padLeft(2, '0')}';
                                                }

                                                context.read<ProfileUpdateCubit>().updateProfile(
                                                  name: _nameController.text,
                                                  username: _usernameController.text,
                                                  phone: _phoneNumber,
                                                  gender: _selectedGender,
                                                  birthDate: birthDateFormatted,
                                                  weight: num.tryParse(_weightController.text),
                                                  height: num.tryParse(_heightController.text),
                                                  logoutOtherDevices: _logoutOtherDevices,
                                                  imagePath: _profileImage?.path,
                                                );
                                              }
                                            },
                                            child: isLoading
                                                ? const CircularProgressIndicator(color: Colors.white)
                                                : Text(
                                                    l10n.update,
                                                    style: AppStyles.button.copyWith(fontSize: 18.sp),
                                                  ),
                                          ),
                                        ),
                                        SizedBox(height: 40.h), // Bottom padding
                                      ],
                                    ),
                                                                    ),
                                  ),
                              ),
                            ),
                          ),
                        ),

                        // Profile Image
                          Positioned(
                            top: 0,
                            child: GestureDetector(
                              onTap: _pickImage,
                              child: Stack(
                                clipBehavior: Clip.none,
                                alignment: Alignment.bottomRight,
                                children: [
                                  Container(
                                    width: 70.r,
                                    height: 70.r,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.shimmer,
                                      image: _profileImage != null
                                          ? DecorationImage(
                                              image: FileImage(File(_profileImage!.path)),
                                              fit: BoxFit.cover,
                                            )
                                          : null,
                                    ),
                                    child: _profileImage == null
                                        ? BlocBuilder<UserCubit, UserState>(
                                            builder: (context, userState) {
                                              if (userState is UserLoaded && userState.user.image != null) {
                                                return ClipOval(
                                                  child: Image.network(
                                                    userState.user.image!,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (_, __, ___) => const Icon(Icons.person, size: 50, color: AppColors.textHint),
                                                  ),
                                                );
                                              }
                                              return const Icon(Icons.person, size: 50, color: AppColors.textHint);
                                            },
                                          )
                                        : null,
                                  ),
                                  Positioned(
                                    bottom: -8.r,
                                    right: -8.r,
                                    child: SvgPicture.asset(
                                      Assets.svgCameraFill,
                                      width: 32.r,
                                      height: 32.r,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
  Widget _buildGenderOption(String value, String label, IconData icon) {
    final isSelected = _selectedGender == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedGender = value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 14.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : Colors.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: isSelected ? AppColors.primary : AppColors.textHint, size: 20),
              SizedBox(width: 8.w),
              Text(
                label,
                style: AppStyles.bodyLarge.copyWith(
                  color: isSelected ? AppColors.primary : AppColors.textHint,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
