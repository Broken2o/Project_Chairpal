import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../core/constants/assets.dart';
import '../../../../features/auth/presentation/cubit/user_cubit/user_cubit.dart';
import '../../../../features/auth/presentation/cubit/user_cubit/user_state.dart';
import '../../../../features/language_selection/presentation/cubit/language_selection_cubit.dart';
import '../../../../features/language_selection/presentation/screens/language_selection_screen.dart';
import '../../../../l10n/l10n.dart';
import '../../../../features/auth/domain/repositories/auth_repository.dart';
import '../cubit/change_password_cubit.dart';
import 'change_password_screen.dart';
import 'help_support_screen.dart';
import 'my_favorites_screen.dart';
import '../widgets/logout_dialog.dart';
import '../widgets/delete_account_dialog.dart';
import 'update_profile_screen.dart';
import 'update_medical_conditions_screen.dart';
import '../../../../core/di/injection_container.dart' as di;

import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context)!;
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.center,
            colors: [
              AppColors.primary.withValues(alpha: 0.35),
              Colors.white.withValues(alpha: 0.8),
              Colors.white,
            ],
            stops: const [0.0, 0.5, 0.6],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 60.0.h, bottom: 20.0.h),
                    child: Center(
                      child: Text(
                        l10n.myProfile,
                        style: AppStyles.h4.copyWith(color: AppColors.primaryDark),
                      ),
                    ),
                  ),
                  BlocBuilder<UserCubit, UserState>(
                    builder: (context, state) {
                      String name = '';
                      String handle = '';
                      String joined = '';

                      if (state is UserLoaded) {
                        name = state.user.name;
                        handle = state.user.username != null ? '@${state.user.username}' : '';
                        if (state.user.createdAt != null) {
                          final monthYear = DateFormat('MMMM yyyy').format(state.user.createdAt!);
                          joined = l10n.joinedDate(monthYear);
                        }
                      }

                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.0.w),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Avatar
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    border: Border.all(color: Colors.white, width: 2),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.05),
                                        blurRadius: 10,
                                        offset: const Offset(0, 5),
                                      )
                                    ]
                                  ),
                                  child: ClipOval(
                                    child: (state is UserLoaded && state.user.image != null)
                                        ? Image.network(
                                            state.user.image!,
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) =>
                                                const Icon(Icons.person, size: 40, color: AppColors.primary),
                                            loadingBuilder: (context, child, loadingProgress) {
                                              if (loadingProgress == null) return child;
                                              return Center(
                                                child: CircularProgressIndicator(
                                                  value: loadingProgress.expectedTotalBytes != null
                                                      ? loadingProgress.cumulativeBytesLoaded /
                                                          loadingProgress.expectedTotalBytes!
                                                      : null,
                                                ),
                                              );
                                            },
                                          )
                                        : const Icon(Icons.person, size: 40, color: AppColors.primary),
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                // Info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        style: AppStyles.h2.copyWith(fontSize: 20, color: AppColors.primaryDark),
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        handle,
                                        style: AppStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        joined,
                                        style: AppStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                                      ),
                                    ],
                                  ),
                                ),
                                // Edit Icon
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(14.r),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const UpdateProfileScreen(),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(2.r),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.4),
                                        borderRadius: BorderRadius.circular(12.r),
                                      ),
                                      child: SvgPicture.asset(
                                        Assets.svgEdit,
                                        width: 32,
                                        height: 32,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 24.h),
                            // Separator
                            Container(
                              height: 1,
                              color: Colors.grey.withValues(alpha: 0.2),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            
            SliverToBoxAdapter(child: SizedBox(height: 16.h)),

          // Menu Options
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildOptionItem(
                  icon: Icons.medical_information_outlined,
                  title: l10n.medicalInfo,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UpdateMedicalConditionsScreen(),
                      ),
                    );
                  },
                ),
                _buildOptionItem(
                  icon: Icons.favorite,
                  title: l10n.myFavorites,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyFavoritesScreen(),
                      ),
                    );
                  },
                ),
                _buildOptionItem(
                  icon: Icons.vpn_key_outlined,
                  title: l10n.changePassword,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => ChangePasswordCubit(
                            authRepository: di.sl<AuthRepository>(),
                          ),
                          child: const ChangePasswordScreen(),
                        ),
                      ),
                    );
                  },
                ),
                _buildOptionItem(
                  icon: Icons.language,
                  title: l10n.languageSetting,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => LanguageSelectionCubit(),
                          child: const LanguageSelectionScreen(
                            isFromSettings: true,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                _buildOptionItem(
                  icon: Icons.accessible_forward,
                  title: l10n.changeMyEChair,
                  onTap: () {},
                ),
                _buildOptionItem(
                  icon: Icons.headset_mic_outlined,
                  title: l10n.helpSupport,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HelpSupportScreen(),
                      ),
                    );
                  },
                ),
                _buildOptionItem(
                  icon: Icons.logout,
                  title: l10n.logOut,
                  isDestructive: true,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => const LogoutDialog(),
                    );
                  },
                ),
              ],
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: 24.h)),

          // Delete Button
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0.w, vertical: 16.h),
              child: OutlinedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const DeleteAccountDialog(),
                  );
                },
                icon: const Icon(Icons.delete_outline),
                label: Text(l10n.deleteAccount),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFF26849),
                  side: const BorderSide(color: Color(0xFFF26849)),
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  textStyle: AppStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          
          SliverToBoxAdapter(child: SizedBox(height: 120.h)), // Space for bottom nav
        ],
      ),
      ),
    );
  }

  Widget _buildOptionItem({
    required IconData icon,
    required String title,
    bool isDestructive = false,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    final color = isDestructive ? const Color(0xFFF26849) : AppColors.primary;
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 24.w),
      leading: Container(
        padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 24),
      ),
      title: Text(
        title,
        style: AppStyles.bodyLarge.copyWith(
          color: isDestructive ? color : AppColors.primaryDark,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: trailing ?? Icon(Icons.chevron_right, color: color, size: 24),
      onTap: onTap,
    );
  }
}
