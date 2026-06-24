import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chair_pal/core/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localization/locale_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../l10n/l10n.dart';
import '../../../../core/di/injection_container.dart';
import '../../../profile/domain/usecases/update_language_usecase.dart';
import '../../../onboarding/presentation/screens/onboarding_screen.dart';
import '../cubit/language_selection_cubit.dart';
import '../cubit/language_selection_state.dart';
import '../widgets/language_card.dart';
import 'package:chair_pal/core/widgets/custom_snackbar.dart';

class LanguageSelectionScreen extends StatefulWidget {
  final bool isFromSettings;

  const LanguageSelectionScreen({super.key, this.isFromSettings = false});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _handleContinue(BuildContext context) {
    final cubit = context.read<LanguageSelectionCubit>();
    final selectedLanguage = cubit.selectedLanguage;

    if (selectedLanguage == null) {
      CustomSnackBar.showError(context: context, message: S.of(context)!.selectLanguageFirst);
      return;
    }

    // Update locale
    context.read<LocaleProvider>().setLocale(Locale(selectedLanguage.code));

    // Confirm selection
    cubit.confirmSelection();

    if (widget.isFromSettings) {
      // Fire and forget API call to update native language on the backend
      sl<UpdateLanguageUseCase>().call(selectedLanguage.code).catchError((_) {
        // ignore errors silently or log them
      });

      Navigator.of(context).pop();
    } else {
      // Navigate to onboarding
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const OnboardingScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: false, title: CustomAppbar()),
      body: Padding(
        padding: EdgeInsets.all(24.0.r),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  S.of(context)!.languageSelectionTitle,
                  style: AppStyles.h2.copyWith(color: AppColors.primaryDark),
                ),
                SizedBox(height: 8.h),
                Text(
                  S.of(context)!.languageSelectionSubtitle,
                  style: AppStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 15.h),
                // Search bar
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: S.of(context)!.search,
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.textSecondary,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                // Language Cards
                Expanded(
                  child:
                      BlocBuilder<
                        LanguageSelectionCubit,
                        LanguageSelectionState
                      >(
                        builder: (context, state) {
                          var languages = state is LanguageSelectionInitial
                              ? state.availableLanguages
                              : state is LanguageSelected
                              ? state.availableLanguages
                              : [];

                          if (_searchQuery.isNotEmpty) {
                            languages = languages
                                .where(
                                  (lang) =>
                                      lang.name.toLowerCase().contains(
                                        _searchQuery,
                                      ) ||
                                      lang.nativeName.toLowerCase().contains(
                                        _searchQuery,
                                      ),
                                )
                                .toList();
                          }

                          return ListView.separated(
                            physics: BouncingScrollPhysics(),
                            itemCount: languages.length,
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 8.h),
                            itemBuilder: (context, index) {
                              final language = languages[index];
                              final isSelected =
                                  state is LanguageSelected &&
                                  state.selectedLanguage == language;

                              return TweenAnimationBuilder<double>(
                                duration: Duration(
                                  milliseconds: 300 + (index * 100),
                                ),
                                tween: Tween(begin: 0.0, end: 1.0),
                                curve: Curves.easeOutCubic,
                                builder: (context, value, child) {
                                  return Opacity(
                                    opacity: value,
                                    child: Transform.translate(
                                      offset: Offset(0, 20 * (1 - value)),
                                      child: child,
                                    ),
                                  );
                                },
                                child: LanguageCard(
                                  language: language,
                                  isSelected: isSelected,
                                  onTap: () {
                                    context
                                        .read<LanguageSelectionCubit>()
                                        .selectLanguage(language);
                                  },
                                ),
                              );
                            },
                          );
                        },
                      ),
                ),
                // Continue Button
                BlocBuilder<LanguageSelectionCubit, LanguageSelectionState>(
                  builder: (context, state) {
                    final hasSelection = state is LanguageSelected;
                    return AnimatedScale(
                      duration: const Duration(milliseconds: 300),
                      scale: hasSelection ? 1.0 : 0.95,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: hasSelection ? 1.0 : 0.5,
                        child: SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: hasSelection
                                ? () => _handleContinue(context)
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              elevation: hasSelection ? 4 : 0,
                              shadowColor: AppColors.primary.withValues(
                                alpha: 0.5,
                              ),
                            ),
                            child: Text(
                              S.of(context)!.continueButton,
                              style: AppStyles.button.copyWith(fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
