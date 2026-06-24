import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../l10n/l10n.dart';

class ChatHubDrawer extends StatelessWidget {
  final VoidCallback onNewChat;
  final VoidCallback onHistoryTap;

  const ChatHubDrawer({
    super.key,
    required this.onNewChat,
    required this.onHistoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.primaryDark,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.0.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.white, size: 28),
                ),
              ),
              SizedBox(height: 48.h),
              _buildDrawerItem(
                context,
                icon: Icons.chat_bubble_outline,
                title: S.of(context)!.newChat,
                onTap: () {
                  Navigator.pop(context);
                  onNewChat();
                },
              ),
              SizedBox(height: 24.h),
              _buildDrawerItem(
                context,
                icon: Icons.history,
                title: S.of(context)!.history,
                onTap: () {
                  Navigator.pop(context);
                  onHistoryTap();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: Colors.orange, size: 28),
          SizedBox(width: 16.w),
          Text(
            title,
            style: AppStyles.h3.copyWith(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
