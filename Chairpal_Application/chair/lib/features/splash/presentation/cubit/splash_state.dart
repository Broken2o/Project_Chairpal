import 'package:equatable/equatable.dart';

abstract class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object> get props => [];
}

class SplashInitial extends SplashState {}

class SplashNavigateToLanguageSelection extends SplashState {}

class SplashNavigateToOnboarding extends SplashState {}

class SplashNavigateToHome extends SplashState {}

class SplashNavigateToLogin extends SplashState {}

class SplashNavigateToAdminHome extends SplashState {}
