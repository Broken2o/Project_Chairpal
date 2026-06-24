import 'package:chair_pal/core/widgets/custom_appbar.dart';
import 'package:chair_pal/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../l10n/l10n.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_navigation_link.dart';
import 'login_screen.dart';
import 'health_assistant_intro_screen.dart';
import 'signup_screen.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  String? _selectedRole;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onRoleSelected(String role) {
    setState(() {
      _selectedRole = role;
    });
  }

  void _onChoose() {
    if (_selectedRole != null) {
      if (_selectedRole == 'user') {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                HealthAssistantIntroScreen(role: _selectedRole!),
          ),
        );
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SignupScreen(role: _selectedRole),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomAppbar(),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AuthHeader(
                    title: S.of(context)!.roleSelectionTitle,
                    subtitle: S.of(context)!.roleSelectionSubtitle,
                  ),
                  SizedBox(height: 32.h),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.85,
                    children: [
                      RoleCard(
                        role: 'user',
                        title: S.of(context)!.roleUser,
                        imagePath: Assets.imagesUser,
                        isSelected: _selectedRole == 'user',
                        onTap: () => _onRoleSelected('user'),
                      ),
                      RoleCard(
                        role: 'organization',
                        title: S.of(context)!.roleOrganization,
                        imagePath: Assets.imagesOrganization,
                        isSelected: _selectedRole == 'organization',
                        onTap: () => _onRoleSelected('organization'),
                      ),
                      RoleCard(
                        role: 'companion',
                        title: S.of(context)!.roleCompanion,
                        imagePath: Assets.companion,
                        isSelected: _selectedRole == 'companion',
                        onTap: () => _onRoleSelected('companion'),
                      ),
                      RoleCard(
                        role: 'doctor',
                        title: S.of(context)!.roleDoctor,
                        imagePath: Assets.doctor,
                        isSelected: _selectedRole == 'doctor',
                        onTap: () => _onRoleSelected('doctor'),
                      ),
                    ],
                  ),
                  SizedBox(height: 32.h),
                  CustomButton(
                    text: S.of(context)!.choose,
                    onPressed: _selectedRole != null ? _onChoose : null,
                    width: double.infinity,
                  ),
                  SizedBox(height: 24.h),
                  Center(
                    child: AuthNavigationLink(
                      text: S.of(context)!.alreadyHaveAccount,
                      linkText: S.of(context)!.login,
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RoleCard extends StatefulWidget {
  final String role;
  final String title;
  final String imagePath;
  final bool isSelected;
  final VoidCallback onTap;

  const RoleCard({
    super.key,
    required this.role,
    required this.title,
    required this.imagePath,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<RoleCard> createState() => _RoleCardState();
}

class _RoleCardState extends State<RoleCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _animationController.reverse();
    widget.onTap();
  }

  void _handleTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: widget.isSelected
                  ? const Color(0xFFFF6B00)
                  : Colors.grey.shade200,
              width: widget.isSelected ? 1.5 : 1,
            ),
            boxShadow: [
              if (widget.isSelected)
                BoxShadow(
                  color: const Color(0xFFFF6B00).withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Image.asset(widget.imagePath, fit: BoxFit.contain),
              ),
              SizedBox(height: 16.h),
              Text(
                widget.title,
                style: AppStyles.h4.copyWith(
                  fontSize: 16,
                  color: AppColors.primaryDark,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
