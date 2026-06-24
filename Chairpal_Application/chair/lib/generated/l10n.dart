// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Chair Pal`
  String get appName {
    return Intl.message('Chair Pal', name: 'appName', desc: '', args: []);
  }

  /// `Back`
  String get back {
    return Intl.message('Back', name: 'back', desc: '', args: []);
  }

  /// `Password changed successfully.`
  String get passwordChangedSuccessfully {
    return Intl.message(
      'Password changed successfully.',
      name: 'passwordChangedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Enter your current password and a new password.`
  String get enterCurrentAndNewPassword {
    return Intl.message(
      'Enter your current password and a new password.',
      name: 'enterCurrentAndNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Current Password`
  String get currentPassword {
    return Intl.message(
      'Current Password',
      name: 'currentPassword',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your current password`
  String get pleaseEnterCurrentPassword {
    return Intl.message(
      'Please enter your current password',
      name: 'pleaseEnterCurrentPassword',
      desc: '',
      args: [],
    );
  }

  /// `Please confirm your new password`
  String get pleaseConfirmNewPassword {
    return Intl.message(
      'Please confirm your new password',
      name: 'pleaseConfirmNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Update Password`
  String get updatePassword {
    return Intl.message(
      'Update Password',
      name: 'updatePassword',
      desc: '',
      args: [],
    );
  }

  /// `Choose Your Language`
  String get languageSelectionTitle {
    return Intl.message(
      'Choose Your Language',
      name: 'languageSelectionTitle',
      desc: '',
      args: [],
    );
  }

  /// `Select your preferred language below, this helps us serve you better.`
  String get languageSelectionSubtitle {
    return Intl.message(
      'Select your preferred language below, this helps us serve you better.',
      name: 'languageSelectionSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get continueButton {
    return Intl.message('Continue', name: 'continueButton', desc: '', args: []);
  }

  /// `Please select a language first`
  String get selectLanguageFirst {
    return Intl.message(
      'Please select a language first',
      name: 'selectLanguageFirst',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get english {
    return Intl.message('English', name: 'english', desc: '', args: []);
  }

  /// `Arabic`
  String get arabic {
    return Intl.message('Arabic', name: 'arabic', desc: '', args: []);
  }

  /// `Welcome to Wheelchair Buddy`
  String get onboardingTitle1 {
    return Intl.message(
      'Welcome to Wheelchair Buddy',
      name: 'onboardingTitle1',
      desc: '',
      args: [],
    );
  }

  /// `Your perfect companion for navigating places with your wheelchair. We help you find accessible locations and connect with a supportive community.`
  String get onboardingDescription1 {
    return Intl.message(
      'Your perfect companion for navigating places with your wheelchair. We help you find accessible locations and connect with a supportive community.',
      name: 'onboardingDescription1',
      desc: '',
      args: [],
    );
  }

  /// `Find Accessible Places`
  String get onboardingTitle2 {
    return Intl.message(
      'Find Accessible Places',
      name: 'onboardingTitle2',
      desc: '',
      args: [],
    );
  }

  /// `Discover wheelchair-friendly places near you. Read reviews from other users to make informed decisions.`
  String get onboardingDescription2 {
    return Intl.message(
      'Discover wheelchair-friendly places near you. Read reviews from other users to make informed decisions.',
      name: 'onboardingDescription2',
      desc: '',
      args: [],
    );
  }

  /// `Join Our Community`
  String get onboardingTitle3 {
    return Intl.message(
      'Join Our Community',
      name: 'onboardingTitle3',
      desc: '',
      args: [],
    );
  }

  /// `Connect with others, share your experiences, and help build a more accessible world together.`
  String get onboardingDescription3 {
    return Intl.message(
      'Connect with others, share your experiences, and help build a more accessible world together.',
      name: 'onboardingDescription3',
      desc: '',
      args: [],
    );
  }

  /// `Skip`
  String get skip {
    return Intl.message('Skip', name: 'skip', desc: '', args: []);
  }

  /// `Next`
  String get next {
    return Intl.message('Next', name: 'next', desc: '', args: []);
  }

  /// `Get Started`
  String get getStarted {
    return Intl.message('Get Started', name: 'getStarted', desc: '', args: []);
  }

  /// `Welcome Back`
  String get loginTitle {
    return Intl.message('Welcome Back', name: 'loginTitle', desc: '', args: []);
  }

  /// `Log in to continue`
  String get loginSubtitle {
    return Intl.message(
      'Log in to continue',
      name: 'loginSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get phoneNumber {
    return Intl.message(
      'Phone Number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Enter your phone number`
  String get enterPhoneNumber {
    return Intl.message(
      'Enter your phone number',
      name: 'enterPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `Or continue with`
  String get orContinueWith {
    return Intl.message(
      'Or continue with',
      name: 'orContinueWith',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account?`
  String get dontHaveAccount {
    return Intl.message(
      'Don\'t have an account?',
      name: 'dontHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get signUp {
    return Intl.message('Sign Up', name: 'signUp', desc: '', args: []);
  }

  /// `Verification`
  String get verificationTitle {
    return Intl.message(
      'Verification',
      name: 'verificationTitle',
      desc: '',
      args: [],
    );
  }

  /// `Enter the code sent to`
  String get verificationSubtitle {
    return Intl.message(
      'Enter the code sent to',
      name: 'verificationSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Verify`
  String get verify {
    return Intl.message('Verify', name: 'verify', desc: '', args: []);
  }

  /// `Resend Code`
  String get resendCode {
    return Intl.message('Resend Code', name: 'resendCode', desc: '', args: []);
  }

  /// `Didn't receive the code?`
  String get didNotReceiveCode {
    return Intl.message(
      'Didn\'t receive the code?',
      name: 'didNotReceiveCode',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your phone number`
  String get pleaseEnterPhoneNumber {
    return Intl.message(
      'Please enter your phone number',
      name: 'pleaseEnterPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid phone number`
  String get pleaseEnterValidPhoneNumber {
    return Intl.message(
      'Please enter a valid phone number',
      name: 'pleaseEnterValidPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the verification code`
  String get pleaseEnterVerificationCode {
    return Intl.message(
      'Please enter the verification code',
      name: 'pleaseEnterVerificationCode',
      desc: '',
      args: [],
    );
  }

  /// `Verification code must be 6 digits`
  String get verificationCodeMustBe4Digits {
    return Intl.message(
      'Verification code must be 6 digits',
      name: 'verificationCodeMustBe4Digits',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `example@gmail.com`
  String get emailHint {
    return Intl.message(
      'example@gmail.com',
      name: 'emailHint',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `••••••••`
  String get passwordHint {
    return Intl.message('••••••••', name: 'passwordHint', desc: '', args: []);
  }

  /// `Forgot Password?`
  String get forgotPassword {
    return Intl.message(
      'Forgot Password?',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Log in to Your Account`
  String get loginScreenTitle {
    return Intl.message(
      'Log in to Your Account',
      name: 'loginScreenTitle',
      desc: '',
      args: [],
    );
  }

  /// `Access your account to control your wheelchair and enjoy community features.`
  String get loginScreenSubtitle {
    return Intl.message(
      'Access your account to control your wheelchair and enjoy community features.',
      name: 'loginScreenSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Enter Verification Code`
  String get enterVerificationCode {
    return Intl.message(
      'Enter Verification Code',
      name: 'enterVerificationCode',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the 4-digit code sent to\nyour email to verify your account.`
  String get verificationDescription {
    return Intl.message(
      'Please enter the 4-digit code sent to\\nyour email to verify your account.',
      name: 'verificationDescription',
      desc: '',
      args: [],
    );
  }

  /// `Resend code • 00:30`
  String get resendCodeTimer {
    return Intl.message(
      'Resend code • 00:30',
      name: 'resendCodeTimer',
      desc: '',
      args: [],
    );
  }

  /// `Verification Successful!`
  String get verificationSuccessful {
    return Intl.message(
      'Verification Successful!',
      name: 'verificationSuccessful',
      desc: '',
      args: [],
    );
  }

  /// `Verification code has been resent!`
  String get verificationCodeResent {
    return Intl.message(
      'Verification code has been resent!',
      name: 'verificationCodeResent',
      desc: '',
      args: [],
    );
  }

  /// `Smart Mobility and Control for Every User`
  String get onboardingPage1Title {
    return Intl.message(
      'Smart Mobility and Control for Every User',
      name: 'onboardingPage1Title',
      desc: '',
      args: [],
    );
  }

  /// `Smart features designed for users, companions, doctors, and organizations.`
  String get onboardingPage1Description {
    return Intl.message(
      'Smart features designed for users, companions, doctors, and organizations.',
      name: 'onboardingPage1Description',
      desc: '',
      args: [],
    );
  }

  /// `Explore and Create Accessible Places`
  String get onboardingPage2Title {
    return Intl.message(
      'Explore and Create Accessible Places',
      name: 'onboardingPage2Title',
      desc: '',
      args: [],
    );
  }

  /// `Discover accessible places created by organizations, or create your own`
  String get onboardingPage2Description {
    return Intl.message(
      'Discover accessible places created by organizations, or create your own',
      name: 'onboardingPage2Description',
      desc: '',
      args: [],
    );
  }

  /// `Connect with a Supportive Community`
  String get onboardingPage3Title {
    return Intl.message(
      'Connect with a Supportive Community',
      name: 'onboardingPage3Title',
      desc: '',
      args: [],
    );
  }

  /// `connected with users and companions in one supportive environment`
  String get onboardingPage3Description {
    return Intl.message(
      'connected with users and companions in one supportive environment',
      name: 'onboardingPage3Description',
      desc: '',
      args: [],
    );
  }

  /// `All Languages`
  String get allLanguages {
    return Intl.message(
      'All Languages',
      name: 'allLanguages',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your email`
  String get pleaseEnterEmail {
    return Intl.message(
      'Please enter your email',
      name: 'pleaseEnterEmail',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email`
  String get pleaseEnterValidEmail {
    return Intl.message(
      'Please enter a valid email',
      name: 'pleaseEnterValidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your password`
  String get pleaseEnterPassword {
    return Intl.message(
      'Please enter your password',
      name: 'pleaseEnterPassword',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 6 characters`
  String get passwordTooShort {
    return Intl.message(
      'Password must be at least 6 characters',
      name: 'passwordTooShort',
      desc: '',
      args: [],
    );
  }

  /// `Create Account`
  String get signupTitle {
    return Intl.message(
      'Create Account',
      name: 'signupTitle',
      desc: '',
      args: [],
    );
  }

  /// `Sign up to get started`
  String get signupSubtitle {
    return Intl.message(
      'Sign up to get started',
      name: 'signupSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Full Name`
  String get name {
    return Intl.message('Full Name', name: 'name', desc: '', args: []);
  }

  /// `John Doe`
  String get nameHint {
    return Intl.message('John Doe', name: 'nameHint', desc: '', args: []);
  }

  /// `Please enter your full name`
  String get pleaseEnterName {
    return Intl.message(
      'Please enter your full name',
      name: 'pleaseEnterName',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account?`
  String get alreadyHaveAccount {
    return Intl.message(
      'Already have an account?',
      name: 'alreadyHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Create Account`
  String get createAccount {
    return Intl.message(
      'Create Account',
      name: 'createAccount',
      desc: '',
      args: [],
    );
  }

  /// `Choose how you'll use app`
  String get roleSelectionTitle {
    return Intl.message(
      'Choose how you\'ll use app',
      name: 'roleSelectionTitle',
      desc: '',
      args: [],
    );
  }

  /// `Choose your role so we can customize the app experience for you.`
  String get roleSelectionSubtitle {
    return Intl.message(
      'Choose your role so we can customize the app experience for you.',
      name: 'roleSelectionSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `User`
  String get roleUser {
    return Intl.message('User', name: 'roleUser', desc: '', args: []);
  }

  /// `Access your account to use available features.`
  String get roleUserDescription {
    return Intl.message(
      'Access your account to use available features.',
      name: 'roleUserDescription',
      desc: '',
      args: [],
    );
  }

  /// `Organization`
  String get roleOrganization {
    return Intl.message(
      'Organization',
      name: 'roleOrganization',
      desc: '',
      args: [],
    );
  }

  /// `Access your account to manage system features.`
  String get roleOrganizationDescription {
    return Intl.message(
      'Access your account to manage system features.',
      name: 'roleOrganizationDescription',
      desc: '',
      args: [],
    );
  }

  /// `Companion`
  String get roleCompanion {
    return Intl.message('Companion', name: 'roleCompanion', desc: '', args: []);
  }

  /// `Doctor`
  String get roleDoctor {
    return Intl.message('Doctor', name: 'roleDoctor', desc: '', args: []);
  }

  /// `Choose`
  String get choose {
    return Intl.message('Choose', name: 'choose', desc: '', args: []);
  }

  /// `Create New Account`
  String get signupTitleUser {
    return Intl.message(
      'Create New Account',
      name: 'signupTitleUser',
      desc: '',
      args: [],
    );
  }

  /// `Create a new account to control wheelchair and discover accessible places.`
  String get signupSubtitleUser {
    return Intl.message(
      'Create a new account to control wheelchair and discover accessible places.',
      name: 'signupSubtitleUser',
      desc: '',
      args: [],
    );
  }

  /// `Create New Account`
  String get signupTitleOrg {
    return Intl.message(
      'Create New Account',
      name: 'signupTitleOrg',
      desc: '',
      args: [],
    );
  }

  /// `Create a new account to manage users and track system activity.`
  String get signupSubtitleOrg {
    return Intl.message(
      'Create a new account to manage users and track system activity.',
      name: 'signupSubtitleOrg',
      desc: '',
      args: [],
    );
  }

  /// `Age`
  String get age {
    return Intl.message('Age', name: 'age', desc: '', args: []);
  }

  /// `18`
  String get enterAge {
    return Intl.message('18', name: 'enterAge', desc: '', args: []);
  }

  /// `Follow Doctor?`
  String get followDoctor {
    return Intl.message(
      'Follow Doctor?',
      name: 'followDoctor',
      desc: '',
      args: [],
    );
  }

  /// `Location`
  String get location {
    return Intl.message('Location', name: 'location', desc: '', args: []);
  }

  /// `Enter your location`
  String get enterLocation {
    return Intl.message(
      'Enter your location',
      name: 'enterLocation',
      desc: '',
      args: [],
    );
  }

  /// `Drag & drop image or Browse`
  String get dragDropImage {
    return Intl.message(
      'Drag & drop image or Browse',
      name: 'dragDropImage',
      desc: '',
      args: [],
    );
  }

  /// `Remember Me`
  String get rememberMe {
    return Intl.message('Remember Me', name: 'rememberMe', desc: '', args: []);
  }

  /// `Confirm Password`
  String get confirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Unauthorized to view other users.`
  String get unauthorizedToViewOtherUsers {
    return Intl.message(
      'Unauthorized to view other users.',
      name: 'unauthorizedToViewOtherUsers',
      desc: '',
      args: [],
    );
  }

  /// `System alerts and emergency notifications will appear here.`
  String get systemAlertsNotificationsWillAppearHere {
    return Intl.message(
      'System alerts and emergency notifications will appear here.',
      name: 'systemAlertsNotificationsWillAppearHere',
      desc: '',
      args: [],
    );
  }

  /// `Add Category`
  String get addCategory {
    return Intl.message(
      'Add Category',
      name: 'addCategory',
      desc: '',
      args: [],
    );
  }

  /// `Add new organization`
  String get addNewOrganization {
    return Intl.message(
      'Add new organization',
      name: 'addNewOrganization',
      desc: '',
      args: [],
    );
  }

  /// `No Organizations Yet`
  String get noOrganizationsYet {
    return Intl.message(
      'No Organizations Yet',
      name: 'noOrganizationsYet',
      desc: '',
      args: [],
    );
  }

  /// `No organizations are available in this category right now. Be the first to add an organization to this category`
  String get noOrganizationsYetDesc {
    return Intl.message(
      'No organizations are available in this category right now. Be the first to add an organization to this category',
      name: 'noOrganizationsYetDesc',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a category name`
  String get pleaseEnterCategoryName {
    return Intl.message(
      'Please enter a category name',
      name: 'pleaseEnterCategoryName',
      desc: '',
      args: [],
    );
  }

  /// `Category added successfully!`
  String get categoryAddedSuccessfully {
    return Intl.message(
      'Category added successfully!',
      name: 'categoryAddedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Logo`
  String get logo {
    return Intl.message('Logo', name: 'logo', desc: '', args: []);
  }

  /// `Please confirm your password`
  String get pleaseConfirmPassword {
    return Intl.message(
      'Please confirm your password',
      name: 'pleaseConfirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get passwordsDoNotMatch {
    return Intl.message(
      'Passwords do not match',
      name: 'passwordsDoNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `I agree to the policies`
  String get agreeToPolicy {
    return Intl.message(
      'I agree to the policies',
      name: 'agreeToPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Please upload a logo`
  String get pleaseUploadLogo {
    return Intl.message(
      'Please upload a logo',
      name: 'pleaseUploadLogo',
      desc: '',
      args: [],
    );
  }

  /// `Please agree to policies`
  String get pleaseAgreeToPolicy {
    return Intl.message(
      'Please agree to policies',
      name: 'pleaseAgreeToPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Awesome! Your Email has been verified successfully.`
  String get emailVerifiedSuccess {
    return Intl.message(
      'Awesome! Your Email has been verified successfully.',
      name: 'emailVerifiedSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Code has been resent successfully.`
  String get codeResentSuccess {
    return Intl.message(
      'Code has been resent successfully.',
      name: 'codeResentSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Logged in successfully.`
  String get loggedInSuccess {
    return Intl.message(
      'Logged in successfully.',
      name: 'loggedInSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Your password has been reset successfully.`
  String get passwordResetSuccess {
    return Intl.message(
      'Your password has been reset successfully.',
      name: 'passwordResetSuccess',
      desc: '',
      args: [],
    );
  }

  /// `OTP sent to your email successfully.`
  String get otpSentSuccess {
    return Intl.message(
      'OTP sent to your email successfully.',
      name: 'otpSentSuccess',
      desc: '',
      args: [],
    );
  }

  /// `OTP verified successfully.`
  String get otpVerifiedSuccess {
    return Intl.message(
      'OTP verified successfully.',
      name: 'otpVerifiedSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password?`
  String get forgotPasswordTitle {
    return Intl.message(
      'Forgot Password?',
      name: 'forgotPasswordTitle',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email address and we'll send you a verification code to reset your password.`
  String get forgotPasswordSubtitle {
    return Intl.message(
      'Enter your email address and we\'ll send you a verification code to reset your password.',
      name: 'forgotPasswordSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Send OTP`
  String get sendOtp {
    return Intl.message('Send OTP', name: 'sendOtp', desc: '', args: []);
  }

  /// `Please enter your email`
  String get pleaseEnterYourEmail {
    return Intl.message(
      'Please enter your email',
      name: 'pleaseEnterYourEmail',
      desc: '',
      args: [],
    );
  }

  /// `Enter OTP Code`
  String get enterOtpCode {
    return Intl.message(
      'Enter OTP Code',
      name: 'enterOtpCode',
      desc: '',
      args: [],
    );
  }

  /// `We've sent a 4-digit code to`
  String get otpSentTo {
    return Intl.message(
      'We\'ve sent a 4-digit code to',
      name: 'otpSentTo',
      desc: '',
      args: [],
    );
  }

  /// `Verify OTP`
  String get verifyOtp {
    return Intl.message('Verify OTP', name: 'verifyOtp', desc: '', args: []);
  }

  /// `OTP must be 6 digits`
  String get otpMustBe4Digits {
    return Intl.message(
      'OTP must be 6 digits',
      name: 'otpMustBe4Digits',
      desc: '',
      args: [],
    );
  }

  /// `Reset Password`
  String get resetPasswordTitle {
    return Intl.message(
      'Reset Password',
      name: 'resetPasswordTitle',
      desc: '',
      args: [],
    );
  }

  /// `Enter your new password below.`
  String get resetPasswordSubtitle {
    return Intl.message(
      'Enter your new password below.',
      name: 'resetPasswordSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get newPassword {
    return Intl.message(
      'New Password',
      name: 'newPassword',
      desc: '',
      args: [],
    );
  }

  /// `Confirm New Password`
  String get confirmNewPassword {
    return Intl.message(
      'Confirm New Password',
      name: 'confirmNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Please enter new password`
  String get pleaseEnterNewPassword {
    return Intl.message(
      'Please enter new password',
      name: 'pleaseEnterNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 6 characters`
  String get passwordMinLength {
    return Intl.message(
      'Password must be at least 6 characters',
      name: 'passwordMinLength',
      desc: '',
      args: [],
    );
  }

  /// `Reset Password`
  String get resetPassword {
    return Intl.message(
      'Reset Password',
      name: 'resetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Pick Location`
  String get pickLocationTitle {
    return Intl.message(
      'Pick Location',
      name: 'pickLocationTitle',
      desc: '',
      args: [],
    );
  }

  /// `Tap on the map to select location`
  String get pickLocationTapHint {
    return Intl.message(
      'Tap on the map to select location',
      name: 'pickLocationTapHint',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Location`
  String get confirmLocation {
    return Intl.message(
      'Confirm Location',
      name: 'confirmLocation',
      desc: '',
      args: [],
    );
  }

  /// `Search for a location`
  String get searchLocation {
    return Intl.message(
      'Search for a location',
      name: 'searchLocation',
      desc: '',
      args: [],
    );
  }

  /// `Enter address or place name`
  String get searchHint {
    return Intl.message(
      'Enter address or place name',
      name: 'searchHint',
      desc: '',
      args: [],
    );
  }

  /// `Loading...`
  String get loading {
    return Intl.message('Loading...', name: 'loading', desc: '', args: []);
  }

  /// `No results found`
  String get noResults {
    return Intl.message(
      'No results found',
      name: 'noResults',
      desc: '',
      args: [],
    );
  }

  /// `Current Location`
  String get currentLocation {
    return Intl.message(
      'Current Location',
      name: 'currentLocation',
      desc: '',
      args: [],
    );
  }

  /// `Search Results`
  String get searchResults {
    return Intl.message(
      'Search Results',
      name: 'searchResults',
      desc: '',
      args: [],
    );
  }

  /// `Hi, {name}`
  String hiUser(String name) {
    return Intl.message('Hi, $name', name: 'hiUser', desc: '', args: [name]);
  }

  /// `Location not set`
  String get locationNotSet {
    return Intl.message(
      'Location not set',
      name: 'locationNotSet',
      desc: '',
      args: [],
    );
  }

  /// `Categories`
  String get categories {
    return Intl.message('Categories', name: 'categories', desc: '', args: []);
  }

  /// `No Categories`
  String get noCategoriesTitle {
    return Intl.message(
      'No Categories',
      name: 'noCategoriesTitle',
      desc: '',
      args: [],
    );
  }

  /// `We couldn't find any categories at the moment.`
  String get noCategoriesSubtitle {
    return Intl.message(
      'We couldn\'t find any categories at the moment.',
      name: 'noCategoriesSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Oops!`
  String get oops {
    return Intl.message('Oops!', name: 'oops', desc: '', args: []);
  }

  /// `Something went wrong.`
  String get somethingWentWrong {
    return Intl.message(
      'Something went wrong.',
      name: 'somethingWentWrong',
      desc: '',
      args: [],
    );
  }

  /// `Popular in {category}`
  String popularIn(String category) {
    return Intl.message(
      'Popular in $category',
      name: 'popularIn',
      desc: '',
      args: [category],
    );
  }

  /// `Popular Places`
  String get popularPlaces {
    return Intl.message(
      'Popular Places',
      name: 'popularPlaces',
      desc: '',
      args: [],
    );
  }

  /// `View all`
  String get viewAll {
    return Intl.message('View all', name: 'viewAll', desc: '', args: []);
  }

  /// `No Places Found`
  String get noPlacesFoundTitle {
    return Intl.message(
      'No Places Found',
      name: 'noPlacesFoundTitle',
      desc: '',
      args: [],
    );
  }

  /// `We couldn't find any popular places nearby.`
  String get noPlacesFoundSubtitle {
    return Intl.message(
      'We couldn\'t find any popular places nearby.',
      name: 'noPlacesFoundSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message('Search', name: 'search', desc: '', args: []);
  }

  /// `My Profile`
  String get myProfile {
    return Intl.message('My Profile', name: 'myProfile', desc: '', args: []);
  }

  /// `Joined {date}`
  String joinedDate(String date) {
    return Intl.message(
      'Joined $date',
      name: 'joinedDate',
      desc: '',
      args: [date],
    );
  }

  /// `Language`
  String get languageSetting {
    return Intl.message(
      'Language',
      name: 'languageSetting',
      desc: '',
      args: [],
    );
  }

  /// `My Favorites`
  String get myFavorites {
    return Intl.message(
      'My Favorites',
      name: 'myFavorites',
      desc: '',
      args: [],
    );
  }

  /// `Change Password`
  String get changePassword {
    return Intl.message(
      'Change Password',
      name: 'changePassword',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Change my e-chair`
  String get changeMyEChair {
    return Intl.message(
      'Change my e-chair',
      name: 'changeMyEChair',
      desc: '',
      args: [],
    );
  }

  /// `Help & Support`
  String get helpSupport {
    return Intl.message(
      'Help & Support',
      name: 'helpSupport',
      desc: '',
      args: [],
    );
  }

  /// `Log out`
  String get logOut {
    return Intl.message('Log out', name: 'logOut', desc: '', args: []);
  }

  /// `Delete Account`
  String get deleteAccount {
    return Intl.message(
      'Delete Account',
      name: 'deleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `No Favorites Yet`
  String get noFavoritesYet {
    return Intl.message(
      'No Favorites Yet',
      name: 'noFavoritesYet',
      desc: '',
      args: [],
    );
  }

  /// `Places you save as favorites will appear here for quick access`
  String get noFavoritesSubtitle {
    return Intl.message(
      'Places you save as favorites will appear here for quick access',
      name: 'noFavoritesSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Oh! You are leaving. Are you sure?`
  String get logoutDialogTitle {
    return Intl.message(
      'Oh! You are leaving. Are you sure?',
      name: 'logoutDialogTitle',
      desc: '',
      args: [],
    );
  }

  /// `No, Cancel`
  String get noCancel {
    return Intl.message('No, Cancel', name: 'noCancel', desc: '', args: []);
  }

  /// `Yes, Log out`
  String get yesLogout {
    return Intl.message('Yes, Log out', name: 'yesLogout', desc: '', args: []);
  }

  /// `Are you sure you want to delete your account?`
  String get deleteAccountDialogTitle {
    return Intl.message(
      'Are you sure you want to delete your account?',
      name: 'deleteAccountDialogTitle',
      desc: '',
      args: [],
    );
  }

  /// `Yes, Delete`
  String get yesDelete {
    return Intl.message('Yes, Delete', name: 'yesDelete', desc: '', args: []);
  }

  /// `Admin Dashboard`
  String get adminPanelTitle {
    return Intl.message(
      'Admin Dashboard',
      name: 'adminPanelTitle',
      desc: '',
      args: [],
    );
  }

  /// `Welcome back`
  String get adminWelcomeBack {
    return Intl.message(
      'Welcome back',
      name: 'adminWelcomeBack',
      desc: '',
      args: [],
    );
  }

  /// `Here you can manage your places easily`
  String get adminManagePlacesSubtitle {
    return Intl.message(
      'Here you can manage your places easily',
      name: 'adminManagePlacesSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Quick Actions`
  String get adminQuickActions {
    return Intl.message(
      'Quick Actions',
      name: 'adminQuickActions',
      desc: '',
      args: [],
    );
  }

  /// `Add Place`
  String get adminAddPlace {
    return Intl.message('Add Place', name: 'adminAddPlace', desc: '', args: []);
  }

  /// `Add Category`
  String get adminAddCategory {
    return Intl.message(
      'Add Category',
      name: 'adminAddCategory',
      desc: '',
      args: [],
    );
  }

  /// `Edit Info`
  String get adminEditInfo {
    return Intl.message('Edit Info', name: 'adminEditInfo', desc: '', args: []);
  }

  /// `Overview`
  String get adminOverview {
    return Intl.message('Overview', name: 'adminOverview', desc: '', args: []);
  }

  /// `Total Places`
  String get adminTotalPlaces {
    return Intl.message(
      'Total Places',
      name: 'adminTotalPlaces',
      desc: '',
      args: [],
    );
  }

  /// `{count} Categories`
  String adminTotalCategories(int count) {
    return Intl.message(
      '$count Categories',
      name: 'adminTotalCategories',
      desc: '',
      args: [count],
    );
  }

  /// `Your Places`
  String get adminYourPlaces {
    return Intl.message(
      'Your Places',
      name: 'adminYourPlaces',
      desc: '',
      args: [],
    );
  }

  /// `View all`
  String get adminViewAll {
    return Intl.message('View all', name: 'adminViewAll', desc: '', args: []);
  }

  /// `Recent Activity`
  String get adminRecentActivity {
    return Intl.message(
      'Recent Activity',
      name: 'adminRecentActivity',
      desc: '',
      args: [],
    );
  }

  /// `Damietta University`
  String get adminMockPlaceUniversity {
    return Intl.message(
      'Damietta University',
      name: 'adminMockPlaceUniversity',
      desc: '',
      args: [],
    );
  }

  /// `University`
  String get adminMockTypeUniversity {
    return Intl.message(
      'University',
      name: 'adminMockTypeUniversity',
      desc: '',
      args: [],
    );
  }

  /// `Green Valley Restaurant`
  String get adminMockPlaceRestaurant {
    return Intl.message(
      'Green Valley Restaurant',
      name: 'adminMockPlaceRestaurant',
      desc: '',
      args: [],
    );
  }

  /// `Restaurant`
  String get adminMockTypeRestaurant {
    return Intl.message(
      'Restaurant',
      name: 'adminMockTypeRestaurant',
      desc: '',
      args: [],
    );
  }

  /// `7 Star Hotel`
  String get adminMockPlaceHotel {
    return Intl.message(
      '7 Star Hotel',
      name: 'adminMockPlaceHotel',
      desc: '',
      args: [],
    );
  }

  /// `Hotel`
  String get adminMockTypeHotel {
    return Intl.message(
      'Hotel',
      name: 'adminMockTypeHotel',
      desc: '',
      args: [],
    );
  }

  /// `New place added`
  String get adminActivityNewPlace {
    return Intl.message(
      'New place added',
      name: 'adminActivityNewPlace',
      desc: '',
      args: [],
    );
  }

  /// `{placeName} was added to {categoryName}`
  String adminActivityNewPlaceSub(String placeName, String categoryName) {
    return Intl.message(
      '$placeName was added to $categoryName',
      name: 'adminActivityNewPlaceSub',
      desc: '',
      args: [placeName, categoryName],
    );
  }

  /// `Place updated`
  String get adminActivityPlaceUpdated {
    return Intl.message(
      'Place updated',
      name: 'adminActivityPlaceUpdated',
      desc: '',
      args: [],
    );
  }

  /// `{placeName} details updated`
  String adminActivityPlaceUpdatedSub(String placeName) {
    return Intl.message(
      '$placeName details updated',
      name: 'adminActivityPlaceUpdatedSub',
      desc: '',
      args: [placeName],
    );
  }

  /// `New category created`
  String get adminActivityNewCategory {
    return Intl.message(
      'New category created',
      name: 'adminActivityNewCategory',
      desc: '',
      args: [],
    );
  }

  /// `{categoryName} category added`
  String adminActivityNewCategorySub(String categoryName) {
    return Intl.message(
      '$categoryName category added',
      name: 'adminActivityNewCategorySub',
      desc: '',
      args: [categoryName],
    );
  }

  /// `{count} hours ago`
  String adminTimeHoursAgo(int count) {
    return Intl.message(
      '$count hours ago',
      name: 'adminTimeHoursAgo',
      desc: '',
      args: [count],
    );
  }

  /// `{count} day ago`
  String adminTimeDaysAgo(int count) {
    return Intl.message(
      '$count day ago',
      name: 'adminTimeDaysAgo',
      desc: '',
      args: [count],
    );
  }

  /// `My Community`
  String get myCommunity {
    return Intl.message(
      'My Community',
      name: 'myCommunity',
      desc: '',
      args: [],
    );
  }

  /// `Add New Post?`
  String get addNewPostPrompt {
    return Intl.message(
      'Add New Post?',
      name: 'addNewPostPrompt',
      desc: '',
      args: [],
    );
  }

  /// `Recommended posts`
  String get recommendedPosts {
    return Intl.message(
      'Recommended posts',
      name: 'recommendedPosts',
      desc: '',
      args: [],
    );
  }

  /// `read more..`
  String get readMore {
    return Intl.message('read more..', name: 'readMore', desc: '', args: []);
  }

  /// `View less..`
  String get viewLess {
    return Intl.message('View less..', name: 'viewLess', desc: '', args: []);
  }

  /// `Love`
  String get love {
    return Intl.message('Love', name: 'love', desc: '', args: []);
  }

  /// `Comment`
  String get comment {
    return Intl.message('Comment', name: 'comment', desc: '', args: []);
  }

  /// `Share`
  String get share {
    return Intl.message('Share', name: 'share', desc: '', args: []);
  }

  /// `Shares`
  String get shares {
    return Intl.message('Shares', name: 'shares', desc: '', args: []);
  }

  /// `No Posts Yet`
  String get noPostsYetTitle {
    return Intl.message(
      'No Posts Yet',
      name: 'noPostsYetTitle',
      desc: '',
      args: [],
    );
  }

  /// `There are no posts to display right now. Posts will appear here once they are shared`
  String get noPostsYetDesc {
    return Intl.message(
      'There are no posts to display right now. Posts will appear here once they are shared',
      name: 'noPostsYetDesc',
      desc: '',
      args: [],
    );
  }

  /// `posts`
  String get postsTabTitle {
    return Intl.message('posts', name: 'postsTabTitle', desc: '', args: []);
  }

  /// `Add Friend`
  String get addFriend {
    return Intl.message('Add Friend', name: 'addFriend', desc: '', args: []);
  }

  /// `Message`
  String get messageAction {
    return Intl.message('Message', name: 'messageAction', desc: '', args: []);
  }

  /// `My Posts`
  String get myPosts {
    return Intl.message('My Posts', name: 'myPosts', desc: '', args: []);
  }

  /// `Post hidden`
  String get postHidden {
    return Intl.message('Post hidden', name: 'postHidden', desc: '', args: []);
  }

  /// `Undo`
  String get undo {
    return Intl.message('Undo', name: 'undo', desc: '', args: []);
  }

  /// `E-Chair`
  String get eChairTitle {
    return Intl.message('E-Chair', name: 'eChairTitle', desc: '', args: []);
  }

  /// `Manage and monitor your e-chair using the options below`
  String get eChairSubtitle {
    return Intl.message(
      'Manage and monitor your e-chair using the options below',
      name: 'eChairSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Emergency`
  String get emergency {
    return Intl.message('Emergency', name: 'emergency', desc: '', args: []);
  }

  /// `Alarm`
  String get alarm {
    return Intl.message('Alarm', name: 'alarm', desc: '', args: []);
  }

  /// `Battery`
  String get battery {
    return Intl.message('Battery', name: 'battery', desc: '', args: []);
  }

  /// `Control your e-chair`
  String get controlEChair {
    return Intl.message(
      'Control your e-chair',
      name: 'controlEChair',
      desc: '',
      args: [],
    );
  }

  /// `Connected`
  String get connected {
    return Intl.message('Connected', name: 'connected', desc: '', args: []);
  }

  /// `Disconnected`
  String get disconnected {
    return Intl.message(
      'Disconnected',
      name: 'disconnected',
      desc: '',
      args: [],
    );
  }

  /// `Connecting...`
  String get connecting {
    return Intl.message(
      'Connecting...',
      name: 'connecting',
      desc: '',
      args: [],
    );
  }

  /// `Connection Error`
  String get connectionError {
    return Intl.message(
      'Connection Error',
      name: 'connectionError',
      desc: '',
      args: [],
    );
  }

  /// `Stay Updated with Real Time Health Monitoring`
  String get onboardingPage4Title {
    return Intl.message(
      'Stay Updated with Real Time Health Monitoring',
      name: 'onboardingPage4Title',
      desc: '',
      args: [],
    );
  }

  /// `Track health status, receive emergency alerts, and stay updated`
  String get onboardingPage4Description {
    return Intl.message(
      'Track health status, receive emergency alerts, and stay updated',
      name: 'onboardingPage4Description',
      desc: '',
      args: [],
    );
  }

  /// `Hi, I'm your health assistant!`
  String get healthAssistantIntroTitle {
    return Intl.message(
      'Hi, I\'m your health assistant!',
      name: 'healthAssistantIntroTitle',
      desc: '',
      args: [],
    );
  }

  /// `Before we begin, answer a few quick questions to personalize your health monitoring.`
  String get healthAssistantIntroMessage {
    return Intl.message(
      'Before we begin, answer a few quick questions to personalize your health monitoring.',
      name: 'healthAssistantIntroMessage',
      desc: '',
      args: [],
    );
  }

  /// `Let's Go`
  String get letsGo {
    return Intl.message('Let\'s Go', name: 'letsGo', desc: '', args: []);
  }

  /// `Tell us about your health condition so we can provide smarter monitoring.`
  String get healthConditionTitle {
    return Intl.message(
      'Tell us about your health condition so we can provide smarter monitoring.',
      name: 'healthConditionTitle',
      desc: '',
      args: [],
    );
  }

  /// `High Blood Pressure`
  String get conditionHighBloodPressure {
    return Intl.message(
      'High Blood Pressure',
      name: 'conditionHighBloodPressure',
      desc: '',
      args: [],
    );
  }

  /// `Heart Disease`
  String get conditionHeartDisease {
    return Intl.message(
      'Heart Disease',
      name: 'conditionHeartDisease',
      desc: '',
      args: [],
    );
  }

  /// `Diabetes`
  String get conditionDiabetes {
    return Intl.message(
      'Diabetes',
      name: 'conditionDiabetes',
      desc: '',
      args: [],
    );
  }

  /// `Epilepsy`
  String get conditionEpilepsy {
    return Intl.message(
      'Epilepsy',
      name: 'conditionEpilepsy',
      desc: '',
      args: [],
    );
  }

  /// `Elderly`
  String get conditionElderly {
    return Intl.message(
      'Elderly',
      name: 'conditionElderly',
      desc: '',
      args: [],
    );
  }

  /// `None of the above`
  String get conditionNone {
    return Intl.message(
      'None of the above',
      name: 'conditionNone',
      desc: '',
      args: [],
    );
  }

  /// `What's your location?`
  String get whatsYourLocation {
    return Intl.message(
      'What\'s your location?',
      name: 'whatsYourLocation',
      desc: '',
      args: [],
    );
  }

  /// `Unknown Location`
  String get unknownLocation {
    return Intl.message(
      'Unknown Location',
      name: 'unknownLocation',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message('Confirm', name: 'confirm', desc: '', args: []);
  }

  /// `Loading address...`
  String get loadingAddress {
    return Intl.message(
      'Loading address...',
      name: 'loadingAddress',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get username {
    return Intl.message('Username', name: 'username', desc: '', args: []);
  }

  /// `Please enter username`
  String get pleaseEnterUsername {
    return Intl.message(
      'Please enter username',
      name: 'pleaseEnterUsername',
      desc: '',
      args: [],
    );
  }

  /// `Gender`
  String get gender {
    return Intl.message('Gender', name: 'gender', desc: '', args: []);
  }

  /// `Male`
  String get male {
    return Intl.message('Male', name: 'male', desc: '', args: []);
  }

  /// `Female`
  String get female {
    return Intl.message('Female', name: 'female', desc: '', args: []);
  }

  /// `Please select gender`
  String get pleaseSelectGender {
    return Intl.message(
      'Please select gender',
      name: 'pleaseSelectGender',
      desc: '',
      args: [],
    );
  }

  /// `Birth Date`
  String get birthDate {
    return Intl.message('Birth Date', name: 'birthDate', desc: '', args: []);
  }

  /// `YYYY-MM-DD`
  String get birthDateHint {
    return Intl.message(
      'YYYY-MM-DD',
      name: 'birthDateHint',
      desc: '',
      args: [],
    );
  }

  /// `Please select birth date`
  String get pleaseSelectBirthDate {
    return Intl.message(
      'Please select birth date',
      name: 'pleaseSelectBirthDate',
      desc: '',
      args: [],
    );
  }

  /// `Weight (kg)`
  String get weightKg {
    return Intl.message('Weight (kg)', name: 'weightKg', desc: '', args: []);
  }

  /// `Weight`
  String get weight {
    return Intl.message('Weight', name: 'weight', desc: '', args: []);
  }

  /// `Height (cm)`
  String get heightCm {
    return Intl.message('Height (cm)', name: 'heightCm', desc: '', args: []);
  }

  /// `Height`
  String get height {
    return Intl.message('Height', name: 'height', desc: '', args: []);
  }

  /// `Required`
  String get required {
    return Intl.message('Required', name: 'required', desc: '', args: []);
  }

  /// `Medical Condition IDs (comma separated)`
  String get medicalConditionIds {
    return Intl.message(
      'Medical Condition IDs (comma separated)',
      name: 'medicalConditionIds',
      desc: '',
      args: [],
    );
  }

  /// `e.g. 1, 2`
  String get medicalConditionIdsHint {
    return Intl.message(
      'e.g. 1, 2',
      name: 'medicalConditionIdsHint',
      desc: '',
      args: [],
    );
  }

  /// `Doctor Username`
  String get doctorUsername {
    return Intl.message(
      'Doctor Username',
      name: 'doctorUsername',
      desc: '',
      args: [],
    );
  }

  /// `Target Username`
  String get targetUsername {
    return Intl.message(
      'Target Username',
      name: 'targetUsername',
      desc: '',
      args: [],
    );
  }

  /// `Category Name`
  String get categoryName {
    return Intl.message(
      'Category Name',
      name: 'categoryName',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get description {
    return Intl.message('Description', name: 'description', desc: '', args: []);
  }

  /// `Hi, {name}`
  String greeting(String name) {
    return Intl.message('Hi, $name', name: 'greeting', desc: '', args: [name]);
  }

  /// `Overview`
  String get overview {
    return Intl.message('Overview', name: 'overview', desc: '', args: []);
  }

  /// `Heart Rate`
  String get heartRate {
    return Intl.message('Heart Rate', name: 'heartRate', desc: '', args: []);
  }

  /// `Temperature`
  String get temperature {
    return Intl.message('Temperature', name: 'temperature', desc: '', args: []);
  }

  /// `Movement`
  String get movement {
    return Intl.message('Movement', name: 'movement', desc: '', args: []);
  }

  /// `Today`
  String get today {
    return Intl.message('Today', name: 'today', desc: '', args: []);
  }

  /// `Live Health Monitoring`
  String get liveHealthMonitoring {
    return Intl.message(
      'Live Health Monitoring',
      name: 'liveHealthMonitoring',
      desc: '',
      args: [],
    );
  }

  /// `BPM`
  String get bpm {
    return Intl.message('BPM', name: 'bpm', desc: '', args: []);
  }

  /// `Normal range: 60-100`
  String get normalRangeHeartRate {
    return Intl.message(
      'Normal range: 60-100',
      name: 'normalRangeHeartRate',
      desc: '',
      args: [],
    );
  }

  /// `°C`
  String get celsius {
    return Intl.message('°C', name: 'celsius', desc: '', args: []);
  }

  /// `Normal range: 36.1-37.2`
  String get normalRangeTemperature {
    return Intl.message(
      'Normal range: 36.1-37.2',
      name: 'normalRangeTemperature',
      desc: '',
      args: [],
    );
  }

  /// `Steps`
  String get steps {
    return Intl.message('Steps', name: 'steps', desc: '', args: []);
  }

  /// `Normal Activity`
  String get normalActivity {
    return Intl.message(
      'Normal Activity',
      name: 'normalActivity',
      desc: '',
      args: [],
    );
  }

  /// `AI Health Insight`
  String get aiHealthInsight {
    return Intl.message(
      'AI Health Insight',
      name: 'aiHealthInsight',
      desc: '',
      args: [],
    );
  }

  /// `Your health status is `
  String get healthStatusIs {
    return Intl.message(
      'Your health status is ',
      name: 'healthStatusIs',
      desc: '',
      args: [],
    );
  }

  /// `stable`
  String get stable {
    return Intl.message('stable', name: 'stable', desc: '', args: []);
  }

  /// `. All vital signs are within normal ranges.`
  String get vitalSignsNormal {
    return Intl.message(
      '. All vital signs are within normal ranges.',
      name: 'vitalSignsNormal',
      desc: '',
      args: [],
    );
  }

  /// `Recent Alerts`
  String get recentAlerts {
    return Intl.message(
      'Recent Alerts',
      name: 'recentAlerts',
      desc: '',
      args: [],
    );
  }

  /// `No recent alerts`
  String get noRecentAlerts {
    return Intl.message(
      'No recent alerts',
      name: 'noRecentAlerts',
      desc: '',
      args: [],
    );
  }

  /// `No AI insights generated yet. Waiting for more data...`
  String get noAiInsights {
    return Intl.message(
      'No AI insights generated yet. Waiting for more data...',
      name: 'noAiInsights',
      desc: '',
      args: [],
    );
  }

  /// `No chart data available`
  String get noChartData {
    return Intl.message(
      'No chart data available',
      name: 'noChartData',
      desc: '',
      args: [],
    );
  }

  /// `High heart rate`
  String get highHeartRate {
    return Intl.message(
      'High heart rate',
      name: 'highHeartRate',
      desc: '',
      args: [],
    );
  }

  /// `Today, 08:47 AM`
  String get today847am {
    return Intl.message(
      'Today, 08:47 AM',
      name: 'today847am',
      desc: '',
      args: [],
    );
  }

  /// `Medium`
  String get medium {
    return Intl.message('Medium', name: 'medium', desc: '', args: []);
  }

  /// `Fall Detected`
  String get fallDetected {
    return Intl.message(
      'Fall Detected',
      name: 'fallDetected',
      desc: '',
      args: [],
    );
  }

  /// `Yesterday, 06:15 PM`
  String get yesterday615pm {
    return Intl.message(
      'Yesterday, 06:15 PM',
      name: 'yesterday615pm',
      desc: '',
      args: [],
    );
  }

  /// `High`
  String get high {
    return Intl.message('High', name: 'high', desc: '', args: []);
  }

  /// `Add New`
  String get addNew {
    return Intl.message('Add New', name: 'addNew', desc: '', args: []);
  }

  /// `SOS button pressed`
  String get sosButtonPressed {
    return Intl.message(
      'SOS button pressed',
      name: 'sosButtonPressed',
      desc: '',
      args: [],
    );
  }

  /// `2 days ago, 11:32 AM`
  String get daysAgo2_1132am {
    return Intl.message(
      '2 days ago, 11:32 AM',
      name: 'daysAgo2_1132am',
      desc: '',
      args: [],
    );
  }

  /// `Low`
  String get low {
    return Intl.message('Low', name: 'low', desc: '', args: []);
  }

  /// `Last Visited`
  String get lastVisited {
    return Intl.message(
      'Last Visited',
      name: 'lastVisited',
      desc: '',
      args: [],
    );
  }

  /// `Unknown`
  String get unknownDistance {
    return Intl.message('Unknown', name: 'unknownDistance', desc: '', args: []);
  }

  /// `Sensors Disconnected`
  String get sensorsDisconnected {
    return Intl.message(
      'Sensors Disconnected',
      name: 'sensorsDisconnected',
      desc: '',
      args: [],
    );
  }

  /// `Unable to retrieve live sensor readings right now. Please check the sensor connection and try again.`
  String get sensorsDisconnectedDesc {
    return Intl.message(
      'Unable to retrieve live sensor readings right now. Please check the sensor connection and try again.',
      name: 'sensorsDisconnectedDesc',
      desc: '',
      args: [],
    );
  }

  /// `Hello! I'm your ChairPal AI assistant 🌍\nAsk me anything about places, travel tips, or nearby spots!`
  String get chatbotWelcomeMessage {
    return Intl.message(
      'Hello! I\'m your ChairPal AI assistant 🌍\\nAsk me anything about places, travel tips, or nearby spots!',
      name: 'chatbotWelcomeMessage',
      desc: '',
      args: [],
    );
  }

  /// `Chat cleared. How can I help you?`
  String get chatClearedMessage {
    return Intl.message(
      'Chat cleared. How can I help you?',
      name: 'chatClearedMessage',
      desc: '',
      args: [],
    );
  }

  /// `New Chat`
  String get newChat {
    return Intl.message('New Chat', name: 'newChat', desc: '', args: []);
  }

  /// `History`
  String get history {
    return Intl.message('History', name: 'history', desc: '', args: []);
  }

  /// `ChairPal AI`
  String get chairPalAI {
    return Intl.message('ChairPal AI', name: 'chairPalAI', desc: '', args: []);
  }

  /// `Online`
  String get online {
    return Intl.message('Online', name: 'online', desc: '', args: []);
  }

  /// `No sessions found.`
  String get noSessionsFound {
    return Intl.message(
      'No sessions found.',
      name: 'noSessionsFound',
      desc: '',
      args: [],
    );
  }

  /// `Type your message...`
  String get typeYourMessage {
    return Intl.message(
      'Type your message...',
      name: 'typeYourMessage',
      desc: '',
      args: [],
    );
  }

  /// `Description (Optional)`
  String get descriptionOptional {
    return Intl.message(
      'Description (Optional)',
      name: 'descriptionOptional',
      desc: '',
      args: [],
    );
  }

  /// `Buildings`
  String get buildings {
    return Intl.message('Buildings', name: 'buildings', desc: '', args: []);
  }

  /// `Add Building`
  String get addBuilding {
    return Intl.message(
      'Add Building',
      name: 'addBuilding',
      desc: '',
      args: [],
    );
  }

  /// `Add New Building`
  String get addNewBuilding {
    return Intl.message(
      'Add New Building',
      name: 'addNewBuilding',
      desc: '',
      args: [],
    );
  }

  /// `Building Name`
  String get buildingName {
    return Intl.message(
      'Building Name',
      name: 'buildingName',
      desc: '',
      args: [],
    );
  }

  /// `Upload Building Main Image`
  String get uploadBuildingImage {
    return Intl.message(
      'Upload Building Main Image',
      name: 'uploadBuildingImage',
      desc: '',
      args: [],
    );
  }

  /// `Building added successfully!`
  String get buildingAddedSuccessfully {
    return Intl.message(
      'Building added successfully!',
      name: 'buildingAddedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `No buildings found.`
  String get noBuildingsFound {
    return Intl.message(
      'No buildings found.',
      name: 'noBuildingsFound',
      desc: '',
      args: [],
    );
  }

  /// `About Building`
  String get aboutBuilding {
    return Intl.message(
      'About Building',
      name: 'aboutBuilding',
      desc: '',
      args: [],
    );
  }

  /// `Rate this building`
  String get rateThisBuilding {
    return Intl.message(
      'Rate this building',
      name: 'rateThisBuilding',
      desc: '',
      args: [],
    );
  }

  /// `Floors`
  String get floors {
    return Intl.message('Floors', name: 'floors', desc: '', args: []);
  }

  /// `Add Floor`
  String get addFloor {
    return Intl.message('Add Floor', name: 'addFloor', desc: '', args: []);
  }

  /// `Add New Floor`
  String get addNewFloor {
    return Intl.message(
      'Add New Floor',
      name: 'addNewFloor',
      desc: '',
      args: [],
    );
  }

  /// `Floor Name`
  String get floorName {
    return Intl.message('Floor Name', name: 'floorName', desc: '', args: []);
  }

  /// `Level`
  String get floorLevel {
    return Intl.message('Level', name: 'floorLevel', desc: '', args: []);
  }

  /// `Upload Floor Image (Optional)`
  String get uploadFloorImage {
    return Intl.message(
      'Upload Floor Image (Optional)',
      name: 'uploadFloorImage',
      desc: '',
      args: [],
    );
  }

  /// `Floor added successfully!`
  String get floorAddedSuccessfully {
    return Intl.message(
      'Floor added successfully!',
      name: 'floorAddedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `No floors found.`
  String get noFloorsFound {
    return Intl.message(
      'No floors found.',
      name: 'noFloorsFound',
      desc: '',
      args: [],
    );
  }

  /// `About Floor`
  String get aboutFloor {
    return Intl.message('About Floor', name: 'aboutFloor', desc: '', args: []);
  }

  /// `Rate this floor`
  String get rateThisFloor {
    return Intl.message(
      'Rate this floor',
      name: 'rateThisFloor',
      desc: '',
      args: [],
    );
  }

  /// `Places`
  String get places {
    return Intl.message('Places', name: 'places', desc: '', args: []);
  }

  /// `Add Place`
  String get addPlace {
    return Intl.message('Add Place', name: 'addPlace', desc: '', args: []);
  }

  /// `Add New Place`
  String get addNewPlace {
    return Intl.message(
      'Add New Place',
      name: 'addNewPlace',
      desc: '',
      args: [],
    );
  }

  /// `Place Name`
  String get placeName {
    return Intl.message('Place Name', name: 'placeName', desc: '', args: []);
  }

  /// `Upload Place Image (Optional)`
  String get uploadPlaceImage {
    return Intl.message(
      'Upload Place Image (Optional)',
      name: 'uploadPlaceImage',
      desc: '',
      args: [],
    );
  }

  /// `Place added successfully!`
  String get placeAddedSuccessfully {
    return Intl.message(
      'Place added successfully!',
      name: 'placeAddedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `No places found.`
  String get noPlacesFound {
    return Intl.message(
      'No places found.',
      name: 'noPlacesFound',
      desc: '',
      args: [],
    );
  }

  /// `{count} Buildings`
  String buildingsCount(int count) {
    return Intl.message(
      '$count Buildings',
      name: 'buildingsCount',
      desc: '',
      args: [count],
    );
  }

  /// `{count} Floors`
  String floorsCount(int count) {
    return Intl.message(
      '$count Floors',
      name: 'floorsCount',
      desc: '',
      args: [count],
    );
  }

  /// `{count} Places`
  String placesCount(int count) {
    return Intl.message(
      '$count Places',
      name: 'placesCount',
      desc: '',
      args: [count],
    );
  }

  /// `About`
  String get about {
    return Intl.message('About', name: 'about', desc: '', args: []);
  }

  /// `Rate this place`
  String get rateThisPlace {
    return Intl.message(
      'Rate this place',
      name: 'rateThisPlace',
      desc: '',
      args: [],
    );
  }

  /// `Add Organization`
  String get addOrganization {
    return Intl.message(
      'Add Organization',
      name: 'addOrganization',
      desc: '',
      args: [],
    );
  }

  /// `Organization Name`
  String get organizationName {
    return Intl.message(
      'Organization Name',
      name: 'organizationName',
      desc: '',
      args: [],
    );
  }

  /// `Upload Organization Main Image`
  String get uploadOrganizationImage {
    return Intl.message(
      'Upload Organization Main Image',
      name: 'uploadOrganizationImage',
      desc: '',
      args: [],
    );
  }

  /// `Organization added successfully!`
  String get organizationAddedSuccessfully {
    return Intl.message(
      'Organization added successfully!',
      name: 'organizationAddedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Country`
  String get country {
    return Intl.message('Country', name: 'country', desc: '', args: []);
  }

  /// `City`
  String get city {
    return Intl.message('City', name: 'city', desc: '', args: []);
  }

  /// `Required`
  String get requiredField {
    return Intl.message('Required', name: 'requiredField', desc: '', args: []);
  }

  /// `e.g. Main Building`
  String get buildingNameHint {
    return Intl.message(
      'e.g. Main Building',
      name: 'buildingNameHint',
      desc: '',
      args: [],
    );
  }

  /// `Describe the building...`
  String get buildingDescriptionHint {
    return Intl.message(
      'Describe the building...',
      name: 'buildingDescriptionHint',
      desc: '',
      args: [],
    );
  }

  /// `e.g. Universities`
  String get categoryNameHint {
    return Intl.message(
      'e.g. Universities',
      name: 'categoryNameHint',
      desc: '',
      args: [],
    );
  }

  /// `e.g. Ground Floor`
  String get floorNameHint {
    return Intl.message(
      'e.g. Ground Floor',
      name: 'floorNameHint',
      desc: '',
      args: [],
    );
  }

  /// `e.g. 0 or 1`
  String get floorLevelHint {
    return Intl.message(
      'e.g. 0 or 1',
      name: 'floorLevelHint',
      desc: '',
      args: [],
    );
  }

  /// `Describe the floor...`
  String get floorDescriptionHint {
    return Intl.message(
      'Describe the floor...',
      name: 'floorDescriptionHint',
      desc: '',
      args: [],
    );
  }

  /// `e.g. FCAI Faculty`
  String get organizationNameHint {
    return Intl.message(
      'e.g. FCAI Faculty',
      name: 'organizationNameHint',
      desc: '',
      args: [],
    );
  }

  /// `e.g. Egypt`
  String get countryHint {
    return Intl.message('e.g. Egypt', name: 'countryHint', desc: '', args: []);
  }

  /// `e.g. Banha`
  String get cityHint {
    return Intl.message('e.g. Banha', name: 'cityHint', desc: '', args: []);
  }

  /// `Describe the organization...`
  String get organizationDescriptionHint {
    return Intl.message(
      'Describe the organization...',
      name: 'organizationDescriptionHint',
      desc: '',
      args: [],
    );
  }

  /// `e.g. Room 101, Cafeteria`
  String get placeNameHint {
    return Intl.message(
      'e.g. Room 101, Cafeteria',
      name: 'placeNameHint',
      desc: '',
      args: [],
    );
  }

  /// `Describe the place...`
  String get placeDescriptionHint {
    return Intl.message(
      'Describe the place...',
      name: 'placeDescriptionHint',
      desc: '',
      args: [],
    );
  }

  /// `Type your opinion (Optional).. `
  String get rateAppHint {
    return Intl.message(
      'Type your opinion (Optional).. ',
      name: 'rateAppHint',
      desc: '',
      args: [],
    );
  }

  /// `Location services are disabled.`
  String get locationServicesDisabled {
    return Intl.message(
      'Location services are disabled.',
      name: 'locationServicesDisabled',
      desc: '',
      args: [],
    );
  }

  /// `Location permissions are denied.`
  String get locationPermissionsDenied {
    return Intl.message(
      'Location permissions are denied.',
      name: 'locationPermissionsDenied',
      desc: '',
      args: [],
    );
  }

  /// `Location permissions are permanently denied.`
  String get locationPermissionsPermanentlyDenied {
    return Intl.message(
      'Location permissions are permanently denied.',
      name: 'locationPermissionsPermanentlyDenied',
      desc: '',
      args: [],
    );
  }

  /// `Fetching location...`
  String get fetchingLocation {
    return Intl.message(
      'Fetching location...',
      name: 'fetchingLocation',
      desc: '',
      args: [],
    );
  }

  /// `Location fetched`
  String get locationFetched {
    return Intl.message(
      'Location fetched',
      name: 'locationFetched',
      desc: '',
      args: [],
    );
  }

  /// `Please set the location first.`
  String get pleaseSetLocationFirst {
    return Intl.message(
      'Please set the location first.',
      name: 'pleaseSetLocationFirst',
      desc: '',
      args: [],
    );
  }

  /// `Enter organization's location`
  String get enterOrganizationLocationHint {
    return Intl.message(
      'Enter organization\'s location',
      name: 'enterOrganizationLocationHint',
      desc: '',
      args: [],
    );
  }

  /// `Image of Organization`
  String get imageOfOrganization {
    return Intl.message(
      'Image of Organization',
      name: 'imageOfOrganization',
      desc: '',
      args: [],
    );
  }

  /// `Type the description here..`
  String get typeDescriptionHere {
    return Intl.message(
      'Type the description here..',
      name: 'typeDescriptionHere',
      desc: '',
      args: [],
    );
  }

  /// `Floors number/ Levels`
  String get floorsNumberLevels {
    return Intl.message(
      'Floors number/ Levels',
      name: 'floorsNumberLevels',
      desc: '',
      args: [],
    );
  }

  /// `Recent Activity`
  String get recentActivity {
    return Intl.message(
      'Recent Activity',
      name: 'recentActivity',
      desc: '',
      args: [],
    );
  }

  /// `No recent activity.`
  String get noRecentActivity {
    return Intl.message(
      'No recent activity.',
      name: 'noRecentActivity',
      desc: '',
      args: [],
    );
  }

  /// `Your Places`
  String get yourPlaces {
    return Intl.message('Your Places', name: 'yourPlaces', desc: '', args: []);
  }

  /// `Patients`
  String get patients {
    return Intl.message('Patients', name: 'patients', desc: '', args: []);
  }

  /// `Total`
  String get totalPatients {
    return Intl.message('Total', name: 'totalPatients', desc: '', args: []);
  }

  /// `Normal`
  String get normal {
    return Intl.message('Normal', name: 'normal', desc: '', args: []);
  }

  /// `Critical`
  String get critical {
    return Intl.message('Critical', name: 'critical', desc: '', args: []);
  }

  /// `No patients assigned yet.`
  String get noPatientsAssigned {
    return Intl.message(
      'No patients assigned yet.',
      name: 'noPatientsAssigned',
      desc: '',
      args: [],
    );
  }

  /// `Total Places`
  String get totalPlaces {
    return Intl.message(
      'Total Places',
      name: 'totalPlaces',
      desc: '',
      args: [],
    );
  }

  /// `Companion Request Pending`
  String get companionRequestPending {
    return Intl.message(
      'Companion Request Pending',
      name: 'companionRequestPending',
      desc: '',
      args: [],
    );
  }

  /// `Your companion request is currently waiting for the user's approval. You'll gain access once the request is accepted.`
  String get companionRequestPendingDesc {
    return Intl.message(
      'Your companion request is currently waiting for the user\'s approval. You\'ll gain access once the request is accepted.',
      name: 'companionRequestPendingDesc',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get retry {
    return Intl.message('Retry', name: 'retry', desc: '', args: []);
  }

  /// `Request Accepted Successfully`
  String get requestAcceptedSuccessfully {
    return Intl.message(
      'Request Accepted Successfully',
      name: 'requestAcceptedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Welcome aboard! Your companion request has been accepted. You can now start monitoring and supporting the user.`
  String get requestAcceptedDesc {
    return Intl.message(
      'Welcome aboard! Your companion request has been accepted. You can now start monitoring and supporting the user.',
      name: 'requestAcceptedDesc',
      desc: '',
      args: [],
    );
  }

  /// `Companion Request Rejected`
  String get companionRequestRejected {
    return Intl.message(
      'Companion Request Rejected',
      name: 'companionRequestRejected',
      desc: '',
      args: [],
    );
  }

  /// `Your companion request was declined by the user. Please check the username and try sending a new request.`
  String get companionRequestRejectedDesc {
    return Intl.message(
      'Your companion request was declined by the user. Please check the username and try sending a new request.',
      name: 'companionRequestRejectedDesc',
      desc: '',
      args: [],
    );
  }

  /// `Back to login`
  String get backToLogin {
    return Intl.message(
      'Back to login',
      name: 'backToLogin',
      desc: '',
      args: [],
    );
  }

  /// `Companions`
  String get companions {
    return Intl.message('Companions', name: 'companions', desc: '', args: []);
  }

  /// `Help Is On The Way`
  String get helpIsOnTheWay {
    return Intl.message(
      'Help Is On The Way',
      name: 'helpIsOnTheWay',
      desc: '',
      args: [],
    );
  }

  /// `Your emergency alert and live location have been sent to your companions.`
  String get emergencyAlertSent {
    return Intl.message(
      'Your emergency alert and live location have been sent to your companions.',
      name: 'emergencyAlertSent',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this Companion?`
  String get deleteCompanion {
    return Intl.message(
      'Are you sure you want to delete this Companion?',
      name: 'deleteCompanion',
      desc: '',
      args: [],
    );
  }

  /// `New Companion Request`
  String get newCompanionRequest {
    return Intl.message(
      'New Companion Request',
      name: 'newCompanionRequest',
      desc: '',
      args: [],
    );
  }

  /// `wants to follow your status and receive emergency alerts.`
  String get wantsToFollow {
    return Intl.message(
      'wants to follow your status and receive emergency alerts.',
      name: 'wantsToFollow',
      desc: '',
      args: [],
    );
  }

  /// `Accept`
  String get accept {
    return Intl.message('Accept', name: 'accept', desc: '', args: []);
  }

  /// `Decline`
  String get decline {
    return Intl.message('Decline', name: 'decline', desc: '', args: []);
  }

  /// `No Emergency Companions added`
  String get noEmergencyCompanions {
    return Intl.message(
      'No Emergency Companions added',
      name: 'noEmergencyCompanions',
      desc: '',
      args: [],
    );
  }

  /// `Give your username to emergency companions you want so they can receive alerts and your location when needed`
  String get giveYourUsernameDesc {
    return Intl.message(
      'Give your username to emergency companions you want so they can receive alerts and your location when needed',
      name: 'giveYourUsernameDesc',
      desc: '',
      args: [],
    );
  }

  /// `Manage trusted companions to receive alerts and your location`
  String get manageTrustedCompanions {
    return Intl.message(
      'Manage trusted companions to receive alerts and your location',
      name: 'manageTrustedCompanions',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Press the SOS button to send alerts and your location`
  String get pressSOS {
    return Intl.message(
      'Press the SOS button to send alerts and your location',
      name: 'pressSOS',
      desc: '',
      args: [],
    );
  }

  /// `No Connections`
  String get noConnections {
    return Intl.message(
      'No Connections',
      name: 'noConnections',
      desc: '',
      args: [],
    );
  }

  /// `Enter a patients username to send a connection request.`
  String get enterPatientUsernameToSendConnectionRequest {
    return Intl.message(
      'Enter a patients username to send a connection request.',
      name: 'enterPatientUsernameToSendConnectionRequest',
      desc: '',
      args: [],
    );
  }

  /// `Patients Username`
  String get patientUsername {
    return Intl.message(
      'Patients Username',
      name: 'patientUsername',
      desc: '',
      args: [],
    );
  }

  /// `Send Request`
  String get sendRequest {
    return Intl.message(
      'Send Request',
      name: 'sendRequest',
      desc: '',
      args: [],
    );
  }

  /// `Need assistance? The ChairPal team is ready to help you.`
  String get helpSupportAssistance {
    return Intl.message(
      'Need assistance? The ChairPal team is ready to help you.',
      name: 'helpSupportAssistance',
      desc: '',
      args: [],
    );
  }

  /// `Contact Info`
  String get helpSupportContactInfo {
    return Intl.message(
      'Contact Info',
      name: 'helpSupportContactInfo',
      desc: '',
      args: [],
    );
  }

  /// `Message`
  String get helpSupportMessage {
    return Intl.message(
      'Message',
      name: 'helpSupportMessage',
      desc: '',
      args: [],
    );
  }

  /// `Type the message here..`
  String get helpSupportMessageHint {
    return Intl.message(
      'Type the message here..',
      name: 'helpSupportMessageHint',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get helpSupportSend {
    return Intl.message('Send', name: 'helpSupportSend', desc: '', args: []);
  }

  /// `Message sent successfully!`
  String get helpSupportSuccessMessage {
    return Intl.message(
      'Message sent successfully!',
      name: 'helpSupportSuccessMessage',
      desc: '',
      args: [],
    );
  }

  /// `Thank you for contacting us. `
  String get helpSupportSuccessDesc1 {
    return Intl.message(
      'Thank you for contacting us. ',
      name: 'helpSupportSuccessDesc1',
      desc: '',
      args: [],
    );
  }

  /// `ChairPal`
  String get helpSupportSuccessDesc2 {
    return Intl.message(
      'ChairPal',
      name: 'helpSupportSuccessDesc2',
      desc: '',
      args: [],
    );
  }

  /// ` support team will get back to you.`
  String get helpSupportSuccessDesc3 {
    return Intl.message(
      ' support team will get back to you.',
      name: 'helpSupportSuccessDesc3',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancelButton {
    return Intl.message('Cancel', name: 'cancelButton', desc: '', args: []);
  }

  /// `Log out`
  String get logoutButton {
    return Intl.message('Log out', name: 'logoutButton', desc: '', args: []);
  }

  /// `Delete`
  String get deleteButton {
    return Intl.message('Delete', name: 'deleteButton', desc: '', args: []);
  }

  /// `My Account`
  String get myAccount {
    return Intl.message('My Account', name: 'myAccount', desc: '', args: []);
  }

  /// `Update Profile`
  String get updateProfile {
    return Intl.message(
      'Update Profile',
      name: 'updateProfile',
      desc: '',
      args: [],
    );
  }

  /// `Date of Birth`
  String get dateOfBirth {
    return Intl.message(
      'Date of Birth',
      name: 'dateOfBirth',
      desc: '',
      args: [],
    );
  }

  /// `Select Date of Birth`
  String get dateOfBirthHint {
    return Intl.message(
      'Select Date of Birth',
      name: 'dateOfBirthHint',
      desc: '',
      args: [],
    );
  }

  /// `Logout other devices`
  String get logoutOtherDevices {
    return Intl.message(
      'Logout other devices',
      name: 'logoutOtherDevices',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get update {
    return Intl.message('Update', name: 'update', desc: '', args: []);
  }

  /// `Camera`
  String get camera {
    return Intl.message('Camera', name: 'camera', desc: '', args: []);
  }

  /// `Gallery`
  String get gallery {
    return Intl.message('Gallery', name: 'gallery', desc: '', args: []);
  }

  /// `cm`
  String get cm {
    return Intl.message('cm', name: 'cm', desc: '', args: []);
  }

  /// `kg`
  String get kg {
    return Intl.message('kg', name: 'kg', desc: '', args: []);
  }

  /// `Medical Info`
  String get medicalInfo {
    return Intl.message(
      'Medical Info',
      name: 'medicalInfo',
      desc: '',
      args: [],
    );
  }

  /// `Profile updated successfully`
  String get profileUpdatedSuccessfully {
    return Intl.message(
      'Profile updated successfully',
      name: 'profileUpdatedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Please connect from Doctor Search`
  String get pleaseConnectFromDoctorSearch {
    return Intl.message(
      'Please connect from Doctor Search',
      name: 'pleaseConnectFromDoctorSearch',
      desc: '',
      args: [],
    );
  }

  /// `Message`
  String get messageButton {
    return Intl.message('Message', name: 'messageButton', desc: '', args: []);
  }

  /// `Add friend`
  String get addFriendButton {
    return Intl.message(
      'Add friend',
      name: 'addFriendButton',
      desc: '',
      args: [],
    );
  }

  /// `Pending`
  String get pendingButton {
    return Intl.message('Pending', name: 'pendingButton', desc: '', args: []);
  }

  /// `Chats`
  String get chatsTitle {
    return Intl.message('Chats', name: 'chatsTitle', desc: '', args: []);
  }

  /// `No Chats Yet`
  String get noChatsYet {
    return Intl.message('No Chats Yet', name: 'noChatsYet', desc: '', args: []);
  }

  /// `Friend request sent successfully.`
  String get friendRequestSentSuccess {
    return Intl.message(
      'Friend request sent successfully.',
      name: 'friendRequestSentSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Failed to send friend request.`
  String get friendRequestSentFail {
    return Intl.message(
      'Failed to send friend request.',
      name: 'friendRequestSentFail',
      desc: '',
      args: [],
    );
  }

  /// `Say something about this...`
  String get saySomethingAboutThis {
    return Intl.message(
      'Say something about this...',
      name: 'saySomethingAboutThis',
      desc: '',
      args: [],
    );
  }

  /// `Share Now`
  String get shareNow {
    return Intl.message('Share Now', name: 'shareNow', desc: '', args: []);
  }

  /// `Write a comment...`
  String get writeAComment {
    return Intl.message(
      'Write a comment...',
      name: 'writeAComment',
      desc: '',
      args: [],
    );
  }

  /// `Type a message...`
  String get typeAMessage {
    return Intl.message(
      'Type a message...',
      name: 'typeAMessage',
      desc: '',
      args: [],
    );
  }

  /// `No comments yet.`
  String get noCommentsYet {
    return Intl.message(
      'No comments yet.',
      name: 'noCommentsYet',
      desc: '',
      args: [],
    );
  }

  /// `Warning`
  String get warningLabel {
    return Intl.message('Warning', name: 'warningLabel', desc: '', args: []);
  }

  /// `You don't have any connected patients.\nApproved patient connections will appear here.`
  String get youDontHaveAnyConnectedPatients {
    return Intl.message(
      'You don\'t have any connected patients.\\nApproved patient connections will appear here.',
      name: 'youDontHaveAnyConnectedPatients',
      desc: '',
      args: [],
    );
  }

  /// `No data`
  String get noData {
    return Intl.message('No data', name: 'noData', desc: '', args: []);
  }

  /// `Last update: `
  String get lastUpdate {
    return Intl.message(
      'Last update: ',
      name: 'lastUpdate',
      desc: '',
      args: [],
    );
  }

  /// `No notifications yet.`
  String get noNotificationsYet {
    return Intl.message(
      'No notifications yet.',
      name: 'noNotificationsYet',
      desc: '',
      args: [],
    );
  }

  /// `Request Rejected Successfully`
  String get requestRejectedSuccessfully {
    return Intl.message(
      'Request Rejected Successfully',
      name: 'requestRejectedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `This request has already been handled.`
  String get requestAlreadyHandled {
    return Intl.message(
      'This request has already been handled.',
      name: 'requestAlreadyHandled',
      desc: '',
      args: [],
    );
  }

  /// `You don't have any notifications at the moment.\nAny alerts and updates will appear here`
  String get noNotificationsSubtitle {
    return Intl.message(
      'You don\'t have any notifications at the moment.\nAny alerts and updates will appear here',
      name: 'noNotificationsSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `No Notifications Yet`
  String get noNotificationsTitle {
    return Intl.message(
      'No Notifications Yet',
      name: 'noNotificationsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Edit Place`
  String get editPlace {
    return Intl.message('Edit Place', name: 'editPlace', desc: '', args: []);
  }

  /// `Please select a rating first.`
  String get pleaseSelectRating {
    return Intl.message(
      'Please select a rating first.',
      name: 'pleaseSelectRating',
      desc: '',
      args: [],
    );
  }

  /// `Review posted successfully!`
  String get reviewPostedSuccess {
    return Intl.message(
      'Review posted successfully!',
      name: 'reviewPostedSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Submit Review`
  String get submitReview {
    return Intl.message(
      'Submit Review',
      name: 'submitReview',
      desc: '',
      args: [],
    );
  }

  /// `This place cannot be reviewed.`
  String get cannotReviewPlace {
    return Intl.message(
      'This place cannot be reviewed.',
      name: 'cannotReviewPlace',
      desc: '',
      args: [],
    );
  }

  /// `All users can see your reviews that contain your profile info`
  String get reviewsVisibilityNote {
    return Intl.message(
      'All users can see your reviews that contain your profile info',
      name: 'reviewsVisibilityNote',
      desc: '',
      args: [],
    );
  }

  /// `Rate {name}`
  String ratePlaceTitle(String name) {
    return Intl.message(
      'Rate $name',
      name: 'ratePlaceTitle',
      desc: '',
      args: [name],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'de'),
      Locale.fromSubtags(languageCode: 'fr'),
      Locale.fromSubtags(languageCode: 'hi'),
      Locale.fromSubtags(languageCode: 'ko'),
      Locale.fromSubtags(languageCode: 'vi'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
