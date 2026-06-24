import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../l10n/l10n.dart';
import 'health_conditions_screen.dart';
import 'package:chair_pal/core/widgets/custom_back_button.dart';

class HealthAssistantIntroScreen extends StatelessWidget {
  final String role;

  const HealthAssistantIntroScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const CustomBackButton(),
        leadingWidth: 100,
      ),
      body: Stack(
        children: [
          // 1. Bottom curved background
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipPath(
              clipper: BottomCurveClipper(),
              child: Container(
                height: 250.h,
                width: double.infinity,
                color: AppColors.primary,
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 40.h),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                HealthConditionsScreen(role: role),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primary,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        S.of(context)!.letsGo,
                        style: AppStyles.h4.copyWith(color: AppColors.primary),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 2. Robot Image
          Positioned(
            bottom: 235.h, // Touches the curve slightly overlapping
            left: 0,
            right: 0,
            child: Image.asset(
              Assets.assistant,
              height: 280.h,
              fit: BoxFit.contain,
            ),
          ),

          // 3. Top Content (Text & Speech Bubble)
          Positioned(
            top: 0,
            left: 24.w,
            right: 24.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),
                Text(
                  S.of(context)!.healthAssistantIntroTitle,
                  style: AppStyles.h2.copyWith(color: AppColors.primaryDark),
                ),
                SizedBox(height: 24.h),
                // Improved Chat Bubble
                CustomPaint(
                  painter: SpeechBubblePainter(
                    isRtl: isRtl,
                    borderColor: Colors.grey.shade200,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 20.w,
                      right: 20.w,
                      top: 20.w,
                      bottom: 20.w + 15.0, // extra padding for the tail
                    ),
                    child: Builder(
                      builder: (context) {
                        final message = S
                            .of(context)!
                            .healthAssistantIntroMessage;
                        final boldWords = ['health monitoring', 'مراقبة صحتك'];

                        List<TextSpan> spans = [];
                        bool matched = false;

                        for (var word in boldWords) {
                          if (message.contains(word)) {
                            final parts = message.split(word);
                            spans = [
                              TextSpan(text: parts[0]),
                              TextSpan(
                                text: word,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryDark.withValues(
                                    alpha: 0.8,
                                  ),
                                  fontSize: 16.sp,
                                ),
                              ),
                              if (parts.length > 1) TextSpan(text: parts[1]),
                            ];
                            matched = true;
                            break;
                          }
                        }

                        if (!matched) {
                          spans = [TextSpan(text: message)];
                        }

                        return RichText(
                          text: TextSpan(
                            style: AppStyles.bodyMedium.copyWith(
                              color: const Color(0xFF8A9393),
                              height: 1.6,
                              fontSize: 16.sp,
                            ),
                            children: spans,
                          ),
                        );
                      },
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
}

class SpeechBubblePainter extends CustomPainter {
  final bool isRtl;
  final Color bgColor;
  final Color borderColor;

  SpeechBubblePainter({
    required this.isRtl,
    this.bgColor = Colors.white,
    this.borderColor = const Color(0xFFEEEEEE),
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = bgColor
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final radius = 16.0;
    final tailWidth = 32.0;
    final tailHeight = 18.0;
    final tipRadiusX = 5.0;
    final tipRadiusY = 6.0;

    // The main rectangle is the whole size MINUS tailHeight
    final rect = Rect.fromLTRB(0, 0, size.width, size.height - tailHeight);

    final path = Path();
    // Start at top-left
    path.moveTo(radius, 0);
    path.lineTo(rect.width - radius, 0);
    path.quadraticBezierTo(rect.width, 0, rect.width, radius);
    path.lineTo(rect.width, rect.height - radius);
    path.quadraticBezierTo(
      rect.width,
      rect.height,
      rect.width - radius,
      rect.height,
    );

    if (isRtl) {
      final startX = rect.width - 50.0;
      path.lineTo(startX, rect.height);
      path.lineTo(
        startX - (tailWidth / 2) + tipRadiusX,
        rect.height + tailHeight - tipRadiusY,
      );
      path.quadraticBezierTo(
        startX - (tailWidth / 2),
        rect.height + tailHeight,
        startX - (tailWidth / 2) - tipRadiusX,
        rect.height + tailHeight - tipRadiusY,
      );
      path.lineTo(startX - tailWidth, rect.height);
      path.lineTo(radius, rect.height);
    } else {
      final startX = 50.0 + tailWidth;
      path.lineTo(startX, rect.height);
      path.lineTo(
        startX - (tailWidth / 2) + tipRadiusX,
        rect.height + tailHeight - tipRadiusY,
      );
      path.quadraticBezierTo(
        startX - (tailWidth / 2),
        rect.height + tailHeight,
        startX - (tailWidth / 2) - tipRadiusX,
        rect.height + tailHeight - tipRadiusY,
      );
      path.lineTo(startX - tailWidth, rect.height);
      path.lineTo(radius, rect.height);
    }

    path.quadraticBezierTo(0, rect.height, 0, rect.height - radius);
    path.lineTo(0, radius);
    path.quadraticBezierTo(0, 0, radius, 0);
    path.close();

    // Draw shadow manually
    canvas.drawShadow(path, Colors.black.withValues(alpha: 0.04), 12, false);

    // Draw fill
    canvas.drawPath(path, paint);

    // Draw stroke
    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class BottomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    // Start 80px down from the top at the left edge
    path.moveTo(0, 80);
    // Peak exactly at the top edge (y=0) in the middle
    path.quadraticBezierTo(size.width / 2, -80, size.width, 80);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
