import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../l10n/l10n.dart';
import '../../../home/domain/entities/category.dart';

class AdminCategoryList extends StatelessWidget {
  final List<Category> categories;
  final VoidCallback? onViewAll;

  const AdminCategoryList({
    super.key,
    required this.categories,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              S.of(context)!.categories,
              style: AppStyles.h3.copyWith(
                color: const Color(0xFF1A2B3C),
                fontWeight: FontWeight.bold,
              ),
            ),
            if (onViewAll != null)
              GestureDetector(
                onTap: onViewAll,
                child: Text(
                  S.of(context)!.adminViewAll,
                  style: AppStyles.bodySmall.copyWith(
                    color: AppColors.textHint,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 12.h),
        // List
        ...categories.map((category) => _CategoryListTile(category: category)),
      ],
    );
  }
}

class _CategoryListTile extends StatelessWidget {
  final Category category;

  const _CategoryListTile({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFF0F0F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF3EEFB),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: (category.image != null && category.image!.isNotEmpty)
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Image.network(
                      category.image!,
                      fit: BoxFit.cover,
                      width: 44,
                      height: 44,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.category_rounded,
                          color: Color(0xFF8E6BBE),
                          size: 24,
                        );
                      },
                    ),
                  )
                : const Icon(
                    Icons.category_rounded,
                    color: Color(0xFF8E6BBE),
                    size: 24,
                  ),
          ),
          SizedBox(width: 14.w),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.name,
                  style: AppStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A2B3C),
                  ),
                ),
              ],
            ),
          ),
          // Action
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert_rounded, color: AppColors.textHint),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
