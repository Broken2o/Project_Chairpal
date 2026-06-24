import 'package:flutter_bloc/flutter_bloc.dart';
import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(const OnboardingPageChanged(0));

  void onPageChanged(int page) {
    emit(OnboardingPageChanged(page));
  }

  void navigateToLogin() {
    emit(OnboardingNavigateToLogin());
  }

  void navigateToSignup() {
    emit(OnboardingNavigateToSignup());
  }
}
