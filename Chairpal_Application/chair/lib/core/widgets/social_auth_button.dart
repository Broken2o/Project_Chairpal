import 'package:flutter/material.dart';
import '../constants/assets.dart';
import '../theme/app_colors.dart';

enum SocialAuthProvider { google, facebook, apple }

class SocialAuthButton extends StatefulWidget {
  final SocialAuthProvider provider;
  final VoidCallback onPressed;

  const SocialAuthButton({
    super.key,
    required this.provider,
    required this.onPressed,
  });

  @override
  State<SocialAuthButton> createState() => _SocialAuthButtonState();
}

class _SocialAuthButtonState extends State<SocialAuthButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    if (_isPressed) {
      setState(() => _isPressed = false);
      _controller.reverse();
    }
  }

  void _handleTapCancel() {
    if (_isPressed) {
      setState(() => _isPressed = false);
      _controller.reverse();
    }
  }

  IconData _getIcon() {
    switch (widget.provider) {
      case SocialAuthProvider.google:
        return Icons.g_mobiledata;
      case SocialAuthProvider.facebook:
        return Icons.facebook;
      case SocialAuthProvider.apple:
        return Icons.apple;
    }
  }

  Color _getColor() {
    switch (widget.provider) {
      case SocialAuthProvider.google:
        return AppColors.google;
      case SocialAuthProvider.facebook:
        return AppColors.facebook;
      case SocialAuthProvider.apple:
        return AppColors.apple;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onPressed,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.border,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: widget.provider == SocialAuthProvider.google
                ? Image.asset(
                    Assets.imagesGoogleLogo,
                    width: 28,
                    height: 28,
                  )
                : Icon(
                    _getIcon(),
                    color: _getColor(),
                    size: 28,
                  ),
          ),
        ),
      ),
    );
  }
}
