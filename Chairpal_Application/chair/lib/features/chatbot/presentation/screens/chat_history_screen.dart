import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../l10n/l10n.dart';
import '../cubit/chat_cubit.dart';
import 'package:chair_pal/core/widgets/custom_back_button.dart';

class ChatHistoryScreen extends StatefulWidget {
  final ChatCubit cubit;

  const ChatHistoryScreen({super.key, required this.cubit});

  @override
  State<ChatHistoryScreen> createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen> {
  @override
  void initState() {
    super.initState();
    widget.cubit.fetchSessions();
    widget.cubit.addListener(_onCubitChange);
  }

  void _onCubitChange() {
    setState(() {});
  }

  @override
  void dispose() {
    widget.cubit.removeListener(_onCubitChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          l10n!.history,
          style: AppStyles.primaryDarkBold,
        ),
        centerTitle: true,
        leading: const CustomBackButton(),
        leadingWidth: 100,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: widget.cubit.sessions.isEmpty
          ? Center(child: Text(l10n.noSessionsFound))
          : ListView.separated(
              padding: EdgeInsets.all(24.r),
              itemCount: widget.cubit.sessions.length,
              separatorBuilder: (context, index) => SizedBox(height: 16.h),
              itemBuilder: (context, index) {
                final session = widget.cubit.sessions[index];
                return _buildHistoryItem(
                  title: session.title,
                  date: session.updatedAt.toString().split(' ')[0],
                  time: session.updatedAt
                      .toString()
                      .split(' ')[1]
                      .substring(0, 5),
                  onTap: () {
                    widget.cubit.loadSession(session.id);
                    Navigator.pop(context);
                  },
                );
              },
            ),
    );
  }

  Widget _buildHistoryItem({
    required String title,
    required String date,
    required String time,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: const Color(0xFFE0F7FA).withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppStyles.bodyLarge.copyWith(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  '$date | $time',
                  style: AppStyles.bodySmall.copyWith(color: Colors.grey[500]),
                ),
              ],
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.orange),
          ],
        ),
      ),
    );
  }
}
