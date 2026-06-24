import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_styles.dart';

/// A data model for a quick action card.
class QuickAction {
  final IconData icon;
  final String label;
  final Color iconColor;
  final Color iconBackground;
  final VoidCallback? onTap;

  const QuickAction({
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.iconBackground,
    this.onTap,
  });
}

class QuickActionsGrid extends StatelessWidget {
  final List<QuickAction> actions;

  const QuickActionsGrid({super.key, required this.actions});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: actions.map((action) {
        return Expanded(
          child: _QuickActionCard(action: action),
        );
      }).toList(),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final QuickAction action;

  const _QuickActionCard({required this.action});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: action.onTap,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 12.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: const Color(0xFFF0F0F0)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: action.iconBackground,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Icon(action.icon, color: action.iconColor, size: 24),
                ),
                SizedBox(height: 10.h),
                Text(
                  action.label,
                  textAlign: TextAlign.center,
                  style: AppStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2D3748),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
