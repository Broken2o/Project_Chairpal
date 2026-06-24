import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../l10n/l10n.dart';
import '../../domain/repositories/community_repository.dart';
import '../../data/models/post_model.dart';
import '../cubit/community_cubit.dart';
import '../cubit/user_posts_cubit.dart';
import '../../../auth/presentation/cubit/user_cubit/user_cubit.dart';
import '../../../auth/presentation/cubit/user_cubit/user_state.dart';
import 'package:chair_pal/core/widgets/custom_snackbar.dart';

class SharePostSheet extends StatefulWidget {
  final PostModel post;

  const SharePostSheet({super.key, required this.post});

  @override
  State<SharePostSheet> createState() => _SharePostSheetState();
}

class _SharePostSheetState extends State<SharePostSheet> {
  final TextEditingController _contentController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _sharePost() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      String? successMessage;
      try {
        successMessage = await context.read<CommunityCubit>().sharePost(
          widget.post.id,
          content: _contentController.text.trim(),
        );
      } catch (_) {
        if (!mounted) return;
        try {
          successMessage = await context.read<UserPostsCubit>().sharePost(
            widget.post.id,
            content: _contentController.text.trim(),
          );
        } catch (_) {
          if (!mounted) return;
          // Fallback to Repository if not in any Cubit context
          final result = await context.read<CommunityRepository>().sharePost(
            widget.post.id,
            content: _contentController.text.trim(),
          );
          successMessage = result['message'] as String?;
        }
      }
      
      if (mounted) {
        Navigator.pop(context);
        CustomSnackBar.showSuccess(
          context: context, 
          message: successMessage ?? S.of(context)!.share 
        );
      }
    } catch (e) {
      if (mounted) {
        CustomSnackBar.showError(
          context: context, 
          message: 'Failed to share post'
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.scaffoldBackground,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        padding: EdgeInsets.fromLTRB(20.r, 12.r, 20.r, 24.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  S.of(context)!.share,
                  style: AppStyles.h3PrimaryDark,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(color: AppColors.border),
            SizedBox(height: 12.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<UserCubit, UserState>(
                  builder: (context, state) {
                    if (state is UserLoaded && state.user.image != null) {
                      return CircleAvatar(
                        radius: 20.r,
                        backgroundImage: NetworkImage(state.user.image!),
                      );
                    }
                    return CircleAvatar(
                      radius: 20.r,
                      backgroundColor: Colors.grey[200],
                      child: Icon(Icons.person, color: Colors.grey[400]),
                    );
                  },
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: TextField(
                    controller: _contentController,
                    maxLines: 4,
                    minLines: 2,
                    style: AppStyles.bodyMedium,
                    decoration: InputDecoration(
                      hintText: S.of(context)!.saySomethingAboutThis,
                      hintStyle: AppStyles.bodyMediumHint,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: _isLoading ? null : _sharePost,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: Size(double.infinity, 48.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: _isLoading
                  ? SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      S.of(context)!.shareNow,
                      style: AppStyles.button,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
