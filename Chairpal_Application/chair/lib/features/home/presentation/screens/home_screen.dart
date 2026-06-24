import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/assets.dart';
import '../../../../features/profile/presentation/screens/profile_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../features/chatbot/presentation/screens/chatbot_screen.dart';
import '../../../../features/community/presentation/screens/community_screen.dart';
import '../widgets/roles/user_dashboard_widget.dart';
import '../../../connections/presentation/widgets/companion_status_wrapper.dart';
import '../widgets/roles/doctor_dashboard_widget.dart';
import '../widgets/roles/admin_dashboard_widget.dart';
import '../cubit/popular_places_cubit/popular_places_cubit.dart';
import '../cubit/last_visited_places_cubit/last_visited_places_cubit.dart';
import '../cubit/home_dashboard_cubit/home_dashboard_cubit.dart';
import '../../../../features/community/domain/repositories/community_repository.dart';
import '../../../../features/community/presentation/cubit/community_cubit.dart';
import '../../../../features/accessibility/presentation/cubit/accessibility_cubit.dart';
import '../cubit/category_cubit/category_cubit.dart';
import '../../../../features/accessibility/presentation/screens/accessibility_screen.dart';
import '../../../../features/accessibility/data/repositories/ros_repository.dart';
import '../../../../features/auth/presentation/cubit/user_cubit/user_cubit.dart';
import '../../../../features/auth/presentation/cubit/user_cubit/user_state.dart';
import '../../../../core/di/injection_container.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, userState) {
        if (userState is UserLoading || userState is UserInitial) {
          return const Scaffold(
            backgroundColor: AppColors.scaffoldBackground,
            body: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }

        int userId = 16; // Default or fallback
        String userRole = 'user';
        if (userState is UserLoaded) {
          userId = userState.user.id;
          userRole = userState.user.role ?? 'user';
        }

    final bool isPatient = userRole == 'user';

    final List<Widget> screens = [
      MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => sl<PopularPlacesCubit>()..fetchPopularPlaces(),
          ),
          BlocProvider(
            create: (context) => sl<LastVisitedPlacesCubit>()..fetchLastVisitedPlaces(userId),
          ),
          BlocProvider(
            create: (context) => sl<HomeDashboardCubit>()..fetchDashboard(userId, userRole),
          ),
          BlocProvider(
            create: (context) => sl<CategoryCubit>()..fetchCategories(mainOnly: true),
          ),
        ],
        child: _HomeContent(userRole: userRole),
      ),
      if (isPatient) const ChatbotScreen(),
      BlocProvider(
        create: (context) => CommunityCubit(
          repository: context.read<CommunityRepository>(),
        )..fetchPosts(),
        child: const CommunityScreen(),
      ),
      if (isPatient)
        BlocProvider(
          create: (context) => AccessibilityCubit(
            repository: context.read<AccessibilityRepository>(),
          ),
          child: const AccessibilityScreen(),
        ),
      const ProfileScreen(), 
    ];

    List<Widget> navItems = [
      _buildNavItem(0, Assets.svgHome, Assets.svgHomeSelected),
    ];

    if (isPatient) {
      navItems.addAll([
        _buildNavItem(1, Assets.svgAi, Assets.svgAiSelected),
        _buildNavItem(2, Assets.svgCommunity, Assets.svgCommunitySelected),
        _buildNavItem(3, Assets.svgWheelchair, Assets.svgWheelchairSelected),
        _buildNavItem(4, Assets.svgProfile, Assets.svgProfileSelected),
      ]);
    } else {
      navItems.addAll([
        _buildNavItem(1, Assets.svgCommunity, Assets.svgCommunitySelected),
        _buildNavItem(2, Assets.svgProfile, Assets.svgProfileSelected),
      ]);
    }

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF2FAF8), // light teal background
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
        ),
        child: Row(
          mainAxisAlignment: isPatient ? MainAxisAlignment.spaceBetween : MainAxisAlignment.spaceAround,
          children: navItems,
        ),
      ),
    );
      },
    );
  }

  Widget _buildNavItem(int index, String inactiveSvgPath, String activeSvgPath) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(
                scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutBack,
                  ),
                ),
                child: child,
              );
            },
            child: SvgPicture.asset(
              isSelected ? activeSvgPath : inactiveSvgPath,
              key: ValueKey<bool>(isSelected),
              // colorFilter: ColorFilter.mode(
              //   isSelected ? AppColors.primary : AppColors.primary.withValues(alpha: 0.4),
              //   BlendMode.srcIn,
              // ),
              width: isSelected ? 38 : 32,
              height: isSelected ? 38 : 32,
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  final String userRole;
  const _HomeContent({required this.userRole});

  Future<void> _onRefresh(BuildContext context) async {
    context.read<CategoryCubit>().fetchCategories(mainOnly: true);
    context.read<PopularPlacesCubit>().fetchPopularPlaces();
    
    final userState = context.read<UserCubit>().state;
    if (userState is UserLoaded) {
      context.read<HomeDashboardCubit>().fetchDashboard(
        userState.user.id,
        userState.user.role ?? 'user',
      );
    }
    
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (userRole == 'org-admin') {
      content = const AdminDashboardWidget();
    } else if (userRole == 'doctor') {
      content = const DoctorDashboardWidget();
    } else if (userRole == 'companion') {
      content = const CompanionStatusWrapper();
    } else {
      content = const UserDashboardWidget();
    }

    return RefreshIndicator(
      onRefresh: () => _onRefresh(context),
      color: AppColors.primary,
      child: content,
    );
  }
}
