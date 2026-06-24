import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../screens/post_image_gallery.dart';

class PostImageGrid extends StatelessWidget {
  final List<String> images;
  final double maxHeight;

  const PostImageGrid({
    super.key,
    required this.images,
    this.maxHeight = 300,
  });

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) return SizedBox.shrink();

    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: _buildGrid(context),
    );
  }

  Widget _buildGrid(BuildContext context) {
    switch (images.length) {
      case 1:
        return _buildSingleImage(context, images[0]);
      case 2:
        return _buildTwoImages(context);
      case 3:
        return _buildThreeImages(context);
      case 4:
        return _buildFourImages(context);
      default:
        return _buildMultiImages(context);
    }
  }

  void _openGallery(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostImageGallery(
          images: images,
          initialIndex: index,
        ),
      ),
    );
  }

  Widget _buildSingleImage(BuildContext context, String url) {
    return GestureDetector(
      onTap: () => _openGallery(context, 0),
      child: _networkImage(url, height: maxHeight, width: double.infinity),
    );
  }

  Widget _buildTwoImages(BuildContext context) {
    return SizedBox(
      height: maxHeight,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _openGallery(context, 0),
              child: _networkImage(images[0], height: maxHeight),
            ),
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: GestureDetector(
              onTap: () => _openGallery(context, 1),
              child: _networkImage(images[1], height: maxHeight),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThreeImages(BuildContext context) {
    return SizedBox(
      height: maxHeight,
      child: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _openGallery(context, 0),
              child: _networkImage(images[0], width: double.infinity),
            ),
          ),
          SizedBox(height: 2.h),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _openGallery(context, 1),
                    child: _networkImage(images[1]),
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _openGallery(context, 2),
                    child: _networkImage(images[2]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFourImages(BuildContext context) {
    return SizedBox(
      height: maxHeight,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _openGallery(context, 0),
                    child: _networkImage(images[0]),
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _openGallery(context, 1),
                    child: _networkImage(images[1]),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _openGallery(context, 2),
                    child: _networkImage(images[2]),
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _openGallery(context, 3),
                    child: _networkImage(images[3]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMultiImages(BuildContext context) {
    return SizedBox(
      height: maxHeight,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _openGallery(context, 0),
                    child: _networkImage(images[0]),
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _openGallery(context, 1),
                    child: _networkImage(images[1]),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _openGallery(context, 2),
                    child: _networkImage(images[2]),
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _openGallery(context, 3),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        _networkImage(images[3]),
                        Container(
                          color: Colors.black.withValues(alpha: 0.5),
                          child: Center(
                            child: Text(
                              '+${images.length - 3}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
    );
  }

  Widget _networkImage(String url, {double? width, double? height}) {
    return Image.network(
      url,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        width: width,
        height: height,
        color: AppColors.shimmer,
        child: const Icon(Icons.broken_image, color: Colors.grey),
      ),
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Container(
          width: width,
          height: height,
          color: AppColors.shimmer,
          child: const Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        );
      },
    );
  }
}
