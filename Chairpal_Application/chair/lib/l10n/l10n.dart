import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'l10n_ar.dart';
import 'l10n_de.dart';
import 'l10n_en.dart';
import 'l10n_fr.dart';
import 'l10n_hi.dart';
import 'l10n_ko.dart';
import 'l10n_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of S
/// returned by `S.of(context)`.
///
/// Applications need to include `S.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/l10n.dart';
///
/// return MaterialApp(
///   localizationsDelegates: S.localizationsDelegates,
///   supportedLocales: S.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the S.supportedLocales
/// property.
abstract class S {
  S(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static S? of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  static const LocalizationsDelegate<S> delegate = _SDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('fr'),
    Locale('hi'),
    Locale('ko'),
    Locale('vi'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Chair Pal'**
  String get appName;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @passwordChangedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully.'**
  String get passwordChangedSuccessfully;

  /// No description provided for @enterCurrentAndNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your current password and a new password.'**
  String get enterCurrentAndNewPassword;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// No description provided for @pleaseEnterCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your current password'**
  String get pleaseEnterCurrentPassword;

  /// No description provided for @pleaseConfirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your new password'**
  String get pleaseConfirmNewPassword;

  /// No description provided for @updatePassword.
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get updatePassword;

  /// No description provided for @languageSelectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Language'**
  String get languageSelectionTitle;

  /// No description provided for @languageSelectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select your preferred language below, this helps us serve you better.'**
  String get languageSelectionSubtitle;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @selectLanguageFirst.
  ///
  /// In en, this message translates to:
  /// **'Please select a language first'**
  String get selectLanguageFirst;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Wheelchair Buddy'**
  String get onboardingTitle1;

  /// No description provided for @onboardingDescription1.
  ///
  /// In en, this message translates to:
  /// **'Your perfect companion for navigating places with your wheelchair. We help you find accessible locations and connect with a supportive community.'**
  String get onboardingDescription1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Find Accessible Places'**
  String get onboardingTitle2;

  /// No description provided for @onboardingDescription2.
  ///
  /// In en, this message translates to:
  /// **'Discover wheelchair-friendly places near you. Read reviews from other users to make informed decisions.'**
  String get onboardingDescription2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Join Our Community'**
  String get onboardingTitle3;

  /// No description provided for @onboardingDescription3.
  ///
  /// In en, this message translates to:
  /// **'Connect with others, share your experiences, and help build a more accessible world together.'**
  String get onboardingDescription3;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Log in to continue'**
  String get loginSubtitle;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @enterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get enterPhoneNumber;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @orContinueWith.
  ///
  /// In en, this message translates to:
  /// **'Or continue with'**
  String get orContinueWith;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @verificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Verification'**
  String get verificationTitle;

  /// No description provided for @verificationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the code sent to'**
  String get verificationSubtitle;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resendCode;

  /// No description provided for @didNotReceiveCode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the code?'**
  String get didNotReceiveCode;

  /// No description provided for @pleaseEnterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get pleaseEnterPhoneNumber;

  /// No description provided for @pleaseEnterValidPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get pleaseEnterValidPhoneNumber;

  /// No description provided for @pleaseEnterVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Please enter the verification code'**
  String get pleaseEnterVerificationCode;

  /// No description provided for @verificationCodeMustBe4Digits.
  ///
  /// In en, this message translates to:
  /// **'Verification code must be 6 digits'**
  String get verificationCodeMustBe4Digits;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'example@gmail.com'**
  String get emailHint;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'••••••••'**
  String get passwordHint;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @loginScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Log in to Your Account'**
  String get loginScreenTitle;

  /// No description provided for @loginScreenSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Access your account to control your wheelchair and enjoy community features.'**
  String get loginScreenSubtitle;

  /// No description provided for @enterVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Enter Verification Code'**
  String get enterVerificationCode;

  /// No description provided for @verificationDescription.
  ///
  /// In en, this message translates to:
  /// **'Please enter the 4-digit code sent to\\nyour email to verify your account.'**
  String get verificationDescription;

  /// No description provided for @resendCodeTimer.
  ///
  /// In en, this message translates to:
  /// **'Resend code • 00:30'**
  String get resendCodeTimer;

  /// No description provided for @verificationSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Verification Successful!'**
  String get verificationSuccessful;

  /// No description provided for @verificationCodeResent.
  ///
  /// In en, this message translates to:
  /// **'Verification code has been resent!'**
  String get verificationCodeResent;

  /// No description provided for @onboardingPage1Title.
  ///
  /// In en, this message translates to:
  /// **'Smart Mobility and Control for Every User'**
  String get onboardingPage1Title;

  /// No description provided for @onboardingPage1Description.
  ///
  /// In en, this message translates to:
  /// **'Smart features designed for users, companions, doctors, and organizations.'**
  String get onboardingPage1Description;

  /// No description provided for @onboardingPage2Title.
  ///
  /// In en, this message translates to:
  /// **'Explore and Create Accessible Places'**
  String get onboardingPage2Title;

  /// No description provided for @onboardingPage2Description.
  ///
  /// In en, this message translates to:
  /// **'Discover accessible places created by organizations, or create your own'**
  String get onboardingPage2Description;

  /// No description provided for @onboardingPage3Title.
  ///
  /// In en, this message translates to:
  /// **'Connect with a Supportive Community'**
  String get onboardingPage3Title;

  /// No description provided for @onboardingPage3Description.
  ///
  /// In en, this message translates to:
  /// **'connected with users and companions in one supportive environment'**
  String get onboardingPage3Description;

  /// No description provided for @allLanguages.
  ///
  /// In en, this message translates to:
  /// **'All Languages'**
  String get allLanguages;

  /// No description provided for @pleaseEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get pleaseEnterEmail;

  /// No description provided for @pleaseEnterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get pleaseEnterValidEmail;

  /// No description provided for @pleaseEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get pleaseEnterPassword;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// No description provided for @signupTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get signupTitle;

  /// No description provided for @signupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign up to get started'**
  String get signupSubtitle;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get name;

  /// No description provided for @nameHint.
  ///
  /// In en, this message translates to:
  /// **'John Doe'**
  String get nameHint;

  /// No description provided for @pleaseEnterName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your full name'**
  String get pleaseEnterName;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @roleSelectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose how you\'ll use app'**
  String get roleSelectionTitle;

  /// No description provided for @roleSelectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your role so we can customize the app experience for you.'**
  String get roleSelectionSubtitle;

  /// No description provided for @roleUser.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get roleUser;

  /// No description provided for @roleUserDescription.
  ///
  /// In en, this message translates to:
  /// **'Access your account to use available features.'**
  String get roleUserDescription;

  /// No description provided for @roleOrganization.
  ///
  /// In en, this message translates to:
  /// **'Organization'**
  String get roleOrganization;

  /// No description provided for @roleOrganizationDescription.
  ///
  /// In en, this message translates to:
  /// **'Access your account to manage system features.'**
  String get roleOrganizationDescription;

  /// No description provided for @roleCompanion.
  ///
  /// In en, this message translates to:
  /// **'Companion'**
  String get roleCompanion;

  /// No description provided for @roleDoctor.
  ///
  /// In en, this message translates to:
  /// **'Doctor'**
  String get roleDoctor;

  /// No description provided for @choose.
  ///
  /// In en, this message translates to:
  /// **'Choose'**
  String get choose;

  /// No description provided for @signupTitleUser.
  ///
  /// In en, this message translates to:
  /// **'Create New Account'**
  String get signupTitleUser;

  /// No description provided for @signupSubtitleUser.
  ///
  /// In en, this message translates to:
  /// **'Create a new account to control wheelchair and discover accessible places.'**
  String get signupSubtitleUser;

  /// No description provided for @signupTitleOrg.
  ///
  /// In en, this message translates to:
  /// **'Create New Account'**
  String get signupTitleOrg;

  /// No description provided for @signupSubtitleOrg.
  ///
  /// In en, this message translates to:
  /// **'Create a new account to manage users and track system activity.'**
  String get signupSubtitleOrg;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @enterAge.
  ///
  /// In en, this message translates to:
  /// **'18'**
  String get enterAge;

  /// No description provided for @followDoctor.
  ///
  /// In en, this message translates to:
  /// **'Follow Doctor?'**
  String get followDoctor;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @enterLocation.
  ///
  /// In en, this message translates to:
  /// **'Enter your location'**
  String get enterLocation;

  /// No description provided for @dragDropImage.
  ///
  /// In en, this message translates to:
  /// **'Drag & drop image or Browse'**
  String get dragDropImage;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember Me'**
  String get rememberMe;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @unauthorizedToViewOtherUsers.
  ///
  /// In en, this message translates to:
  /// **'Unauthorized to view other users.'**
  String get unauthorizedToViewOtherUsers;

  /// No description provided for @systemAlertsNotificationsWillAppearHere.
  ///
  /// In en, this message translates to:
  /// **'System alerts and emergency notifications will appear here.'**
  String get systemAlertsNotificationsWillAppearHere;

  /// No description provided for @addCategory.
  ///
  /// In en, this message translates to:
  /// **'Add Category'**
  String get addCategory;

  /// No description provided for @addNewOrganization.
  ///
  /// In en, this message translates to:
  /// **'Add new organization'**
  String get addNewOrganization;

  /// No description provided for @noOrganizationsYet.
  ///
  /// In en, this message translates to:
  /// **'No Organizations Yet'**
  String get noOrganizationsYet;

  /// No description provided for @noOrganizationsYetDesc.
  ///
  /// In en, this message translates to:
  /// **'No organizations are available in this category right now. Be the first to add an organization to this category'**
  String get noOrganizationsYetDesc;

  /// No description provided for @pleaseEnterCategoryName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a category name'**
  String get pleaseEnterCategoryName;

  /// No description provided for @categoryAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Category added successfully!'**
  String get categoryAddedSuccessfully;

  /// No description provided for @logo.
  ///
  /// In en, this message translates to:
  /// **'Logo'**
  String get logo;

  /// No description provided for @pleaseConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get pleaseConfirmPassword;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @agreeToPolicy.
  ///
  /// In en, this message translates to:
  /// **'I agree to the policies'**
  String get agreeToPolicy;

  /// No description provided for @pleaseUploadLogo.
  ///
  /// In en, this message translates to:
  /// **'Please upload a logo'**
  String get pleaseUploadLogo;

  /// No description provided for @pleaseAgreeToPolicy.
  ///
  /// In en, this message translates to:
  /// **'Please agree to policies'**
  String get pleaseAgreeToPolicy;

  /// No description provided for @emailVerifiedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Awesome! Your Email has been verified successfully.'**
  String get emailVerifiedSuccess;

  /// No description provided for @codeResentSuccess.
  ///
  /// In en, this message translates to:
  /// **'Code has been resent successfully.'**
  String get codeResentSuccess;

  /// No description provided for @loggedInSuccess.
  ///
  /// In en, this message translates to:
  /// **'Logged in successfully.'**
  String get loggedInSuccess;

  /// No description provided for @passwordResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your password has been reset successfully.'**
  String get passwordResetSuccess;

  /// No description provided for @otpSentSuccess.
  ///
  /// In en, this message translates to:
  /// **'OTP sent to your email successfully.'**
  String get otpSentSuccess;

  /// No description provided for @otpVerifiedSuccess.
  ///
  /// In en, this message translates to:
  /// **'OTP verified successfully.'**
  String get otpVerifiedSuccess;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and we\'ll send you a verification code to reset your password.'**
  String get forgotPasswordSubtitle;

  /// No description provided for @sendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOtp;

  /// No description provided for @pleaseEnterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get pleaseEnterYourEmail;

  /// No description provided for @enterOtpCode.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP Code'**
  String get enterOtpCode;

  /// No description provided for @otpSentTo.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a 4-digit code to'**
  String get otpSentTo;

  /// No description provided for @verifyOtp.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get verifyOtp;

  /// No description provided for @otpMustBe4Digits.
  ///
  /// In en, this message translates to:
  /// **'OTP must be 6 digits'**
  String get otpMustBe4Digits;

  /// No description provided for @resetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPasswordTitle;

  /// No description provided for @resetPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your new password below.'**
  String get resetPasswordSubtitle;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @confirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get confirmNewPassword;

  /// No description provided for @pleaseEnterNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter new password'**
  String get pleaseEnterNewPassword;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMinLength;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @pickLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Pick Location'**
  String get pickLocationTitle;

  /// No description provided for @pickLocationTapHint.
  ///
  /// In en, this message translates to:
  /// **'Tap on the map to select location'**
  String get pickLocationTapHint;

  /// No description provided for @confirmLocation.
  ///
  /// In en, this message translates to:
  /// **'Confirm Location'**
  String get confirmLocation;

  /// No description provided for @searchLocation.
  ///
  /// In en, this message translates to:
  /// **'Search for a location'**
  String get searchLocation;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Enter address or place name'**
  String get searchHint;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResults;

  /// No description provided for @currentLocation.
  ///
  /// In en, this message translates to:
  /// **'Current Location'**
  String get currentLocation;

  /// No description provided for @searchResults.
  ///
  /// In en, this message translates to:
  /// **'Search Results'**
  String get searchResults;

  /// No description provided for @hiUser.
  ///
  /// In en, this message translates to:
  /// **'Hi, {name}'**
  String hiUser(String name);

  /// No description provided for @locationNotSet.
  ///
  /// In en, this message translates to:
  /// **'Location not set'**
  String get locationNotSet;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @noCategoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'No Categories'**
  String get noCategoriesTitle;

  /// No description provided for @noCategoriesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find any categories at the moment.'**
  String get noCategoriesSubtitle;

  /// No description provided for @oops.
  ///
  /// In en, this message translates to:
  /// **'Oops!'**
  String get oops;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong.'**
  String get somethingWentWrong;

  /// No description provided for @popularIn.
  ///
  /// In en, this message translates to:
  /// **'Popular in {category}'**
  String popularIn(String category);

  /// No description provided for @popularPlaces.
  ///
  /// In en, this message translates to:
  /// **'Popular Places'**
  String get popularPlaces;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAll;

  /// No description provided for @noPlacesFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'No Places Found'**
  String get noPlacesFoundTitle;

  /// No description provided for @noPlacesFoundSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find any popular places nearby.'**
  String get noPlacesFoundSubtitle;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// No description provided for @joinedDate.
  ///
  /// In en, this message translates to:
  /// **'Joined {date}'**
  String joinedDate(String date);

  /// No description provided for @languageSetting.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSetting;

  /// No description provided for @myFavorites.
  ///
  /// In en, this message translates to:
  /// **'My Favorites'**
  String get myFavorites;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @changeMyEChair.
  ///
  /// In en, this message translates to:
  /// **'Change my e-chair'**
  String get changeMyEChair;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOut;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @noFavoritesYet.
  ///
  /// In en, this message translates to:
  /// **'No Favorites Yet'**
  String get noFavoritesYet;

  /// No description provided for @noFavoritesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Places you save as favorites will appear here for quick access'**
  String get noFavoritesSubtitle;

  /// No description provided for @logoutDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Oh! You are leaving. Are you sure?'**
  String get logoutDialogTitle;

  /// No description provided for @noCancel.
  ///
  /// In en, this message translates to:
  /// **'No, Cancel'**
  String get noCancel;

  /// No description provided for @yesLogout.
  ///
  /// In en, this message translates to:
  /// **'Yes, Log out'**
  String get yesLogout;

  /// No description provided for @deleteAccountDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account?'**
  String get deleteAccountDialogTitle;

  /// No description provided for @yesDelete.
  ///
  /// In en, this message translates to:
  /// **'Yes, Delete'**
  String get yesDelete;

  /// No description provided for @adminPanelTitle.
  ///
  /// In en, this message translates to:
  /// **'Admin Dashboard'**
  String get adminPanelTitle;

  /// No description provided for @adminWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get adminWelcomeBack;

  /// No description provided for @adminManagePlacesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Here you can manage your places easily'**
  String get adminManagePlacesSubtitle;

  /// No description provided for @adminQuickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get adminQuickActions;

  /// No description provided for @adminAddPlace.
  ///
  /// In en, this message translates to:
  /// **'Add Place'**
  String get adminAddPlace;

  /// No description provided for @adminAddCategory.
  ///
  /// In en, this message translates to:
  /// **'Add Category'**
  String get adminAddCategory;

  /// No description provided for @adminEditInfo.
  ///
  /// In en, this message translates to:
  /// **'Edit Info'**
  String get adminEditInfo;

  /// No description provided for @adminOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get adminOverview;

  /// No description provided for @adminTotalPlaces.
  ///
  /// In en, this message translates to:
  /// **'Total Places'**
  String get adminTotalPlaces;

  /// No description provided for @adminTotalCategories.
  ///
  /// In en, this message translates to:
  /// **'{count} Categories'**
  String adminTotalCategories(int count);

  /// No description provided for @adminYourPlaces.
  ///
  /// In en, this message translates to:
  /// **'Your Places'**
  String get adminYourPlaces;

  /// No description provided for @adminViewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get adminViewAll;

  /// No description provided for @adminRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get adminRecentActivity;

  /// No description provided for @adminMockPlaceUniversity.
  ///
  /// In en, this message translates to:
  /// **'Damietta University'**
  String get adminMockPlaceUniversity;

  /// No description provided for @adminMockTypeUniversity.
  ///
  /// In en, this message translates to:
  /// **'University'**
  String get adminMockTypeUniversity;

  /// No description provided for @adminMockPlaceRestaurant.
  ///
  /// In en, this message translates to:
  /// **'Green Valley Restaurant'**
  String get adminMockPlaceRestaurant;

  /// No description provided for @adminMockTypeRestaurant.
  ///
  /// In en, this message translates to:
  /// **'Restaurant'**
  String get adminMockTypeRestaurant;

  /// No description provided for @adminMockPlaceHotel.
  ///
  /// In en, this message translates to:
  /// **'7 Star Hotel'**
  String get adminMockPlaceHotel;

  /// No description provided for @adminMockTypeHotel.
  ///
  /// In en, this message translates to:
  /// **'Hotel'**
  String get adminMockTypeHotel;

  /// No description provided for @adminActivityNewPlace.
  ///
  /// In en, this message translates to:
  /// **'New place added'**
  String get adminActivityNewPlace;

  /// No description provided for @adminActivityNewPlaceSub.
  ///
  /// In en, this message translates to:
  /// **'{placeName} was added to {categoryName}'**
  String adminActivityNewPlaceSub(String placeName, String categoryName);

  /// No description provided for @adminActivityPlaceUpdated.
  ///
  /// In en, this message translates to:
  /// **'Place updated'**
  String get adminActivityPlaceUpdated;

  /// No description provided for @adminActivityPlaceUpdatedSub.
  ///
  /// In en, this message translates to:
  /// **'{placeName} details updated'**
  String adminActivityPlaceUpdatedSub(String placeName);

  /// No description provided for @adminActivityNewCategory.
  ///
  /// In en, this message translates to:
  /// **'New category created'**
  String get adminActivityNewCategory;

  /// No description provided for @adminActivityNewCategorySub.
  ///
  /// In en, this message translates to:
  /// **'{categoryName} category added'**
  String adminActivityNewCategorySub(String categoryName);

  /// No description provided for @adminTimeHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} hours ago'**
  String adminTimeHoursAgo(int count);

  /// No description provided for @adminTimeDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} day ago'**
  String adminTimeDaysAgo(int count);

  /// No description provided for @myCommunity.
  ///
  /// In en, this message translates to:
  /// **'My Community'**
  String get myCommunity;

  /// No description provided for @addNewPostPrompt.
  ///
  /// In en, this message translates to:
  /// **'Add New Post?'**
  String get addNewPostPrompt;

  /// No description provided for @recommendedPosts.
  ///
  /// In en, this message translates to:
  /// **'Recommended posts'**
  String get recommendedPosts;

  /// No description provided for @readMore.
  ///
  /// In en, this message translates to:
  /// **'read more..'**
  String get readMore;

  /// No description provided for @viewLess.
  ///
  /// In en, this message translates to:
  /// **'View less..'**
  String get viewLess;

  /// No description provided for @love.
  ///
  /// In en, this message translates to:
  /// **'Love'**
  String get love;

  /// No description provided for @comment.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get comment;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @shares.
  ///
  /// In en, this message translates to:
  /// **'Shares'**
  String get shares;

  /// No description provided for @noPostsYetTitle.
  ///
  /// In en, this message translates to:
  /// **'No Posts Yet'**
  String get noPostsYetTitle;

  /// No description provided for @noPostsYetDesc.
  ///
  /// In en, this message translates to:
  /// **'There are no posts to display right now. Posts will appear here once they are shared'**
  String get noPostsYetDesc;

  /// No description provided for @postsTabTitle.
  ///
  /// In en, this message translates to:
  /// **'posts'**
  String get postsTabTitle;

  /// No description provided for @addFriend.
  ///
  /// In en, this message translates to:
  /// **'Add Friend'**
  String get addFriend;

  /// No description provided for @messageAction.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get messageAction;

  /// No description provided for @myPosts.
  ///
  /// In en, this message translates to:
  /// **'My Posts'**
  String get myPosts;

  /// No description provided for @postHidden.
  ///
  /// In en, this message translates to:
  /// **'Post hidden'**
  String get postHidden;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @eChairTitle.
  ///
  /// In en, this message translates to:
  /// **'E-Chair'**
  String get eChairTitle;

  /// No description provided for @eChairSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage and monitor your e-chair using the options below'**
  String get eChairSubtitle;

  /// No description provided for @emergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency'**
  String get emergency;

  /// No description provided for @alarm.
  ///
  /// In en, this message translates to:
  /// **'Alarm'**
  String get alarm;

  /// No description provided for @battery.
  ///
  /// In en, this message translates to:
  /// **'Battery'**
  String get battery;

  /// No description provided for @controlEChair.
  ///
  /// In en, this message translates to:
  /// **'Control your e-chair'**
  String get controlEChair;

  /// No description provided for @connected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connected;

  /// No description provided for @disconnected.
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get disconnected;

  /// No description provided for @connecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting...'**
  String get connecting;

  /// No description provided for @connectionError.
  ///
  /// In en, this message translates to:
  /// **'Connection Error'**
  String get connectionError;

  /// No description provided for @onboardingPage4Title.
  ///
  /// In en, this message translates to:
  /// **'Stay Updated with Real Time Health Monitoring'**
  String get onboardingPage4Title;

  /// No description provided for @onboardingPage4Description.
  ///
  /// In en, this message translates to:
  /// **'Track health status, receive emergency alerts, and stay updated'**
  String get onboardingPage4Description;

  /// No description provided for @healthAssistantIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'Hi, I\'m your health assistant!'**
  String get healthAssistantIntroTitle;

  /// No description provided for @healthAssistantIntroMessage.
  ///
  /// In en, this message translates to:
  /// **'Before we begin, answer a few quick questions to personalize your health monitoring.'**
  String get healthAssistantIntroMessage;

  /// No description provided for @letsGo.
  ///
  /// In en, this message translates to:
  /// **'Let\'s Go'**
  String get letsGo;

  /// No description provided for @healthConditionTitle.
  ///
  /// In en, this message translates to:
  /// **'Tell us about your health condition so we can provide smarter monitoring.'**
  String get healthConditionTitle;

  /// No description provided for @conditionHighBloodPressure.
  ///
  /// In en, this message translates to:
  /// **'High Blood Pressure'**
  String get conditionHighBloodPressure;

  /// No description provided for @conditionHeartDisease.
  ///
  /// In en, this message translates to:
  /// **'Heart Disease'**
  String get conditionHeartDisease;

  /// No description provided for @conditionDiabetes.
  ///
  /// In en, this message translates to:
  /// **'Diabetes'**
  String get conditionDiabetes;

  /// No description provided for @conditionEpilepsy.
  ///
  /// In en, this message translates to:
  /// **'Epilepsy'**
  String get conditionEpilepsy;

  /// No description provided for @conditionElderly.
  ///
  /// In en, this message translates to:
  /// **'Elderly'**
  String get conditionElderly;

  /// No description provided for @conditionNone.
  ///
  /// In en, this message translates to:
  /// **'None of the above'**
  String get conditionNone;

  /// No description provided for @whatsYourLocation.
  ///
  /// In en, this message translates to:
  /// **'What\'s your location?'**
  String get whatsYourLocation;

  /// No description provided for @unknownLocation.
  ///
  /// In en, this message translates to:
  /// **'Unknown Location'**
  String get unknownLocation;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @loadingAddress.
  ///
  /// In en, this message translates to:
  /// **'Loading address...'**
  String get loadingAddress;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @pleaseEnterUsername.
  ///
  /// In en, this message translates to:
  /// **'Please enter username'**
  String get pleaseEnterUsername;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @pleaseSelectGender.
  ///
  /// In en, this message translates to:
  /// **'Please select gender'**
  String get pleaseSelectGender;

  /// No description provided for @birthDate.
  ///
  /// In en, this message translates to:
  /// **'Birth Date'**
  String get birthDate;

  /// No description provided for @birthDateHint.
  ///
  /// In en, this message translates to:
  /// **'YYYY-MM-DD'**
  String get birthDateHint;

  /// No description provided for @pleaseSelectBirthDate.
  ///
  /// In en, this message translates to:
  /// **'Please select birth date'**
  String get pleaseSelectBirthDate;

  /// No description provided for @weightKg.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get weightKg;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @heightCm.
  ///
  /// In en, this message translates to:
  /// **'Height (cm)'**
  String get heightCm;

  /// No description provided for @height.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get height;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @medicalConditionIds.
  ///
  /// In en, this message translates to:
  /// **'Medical Condition IDs (comma separated)'**
  String get medicalConditionIds;

  /// No description provided for @medicalConditionIdsHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 1, 2'**
  String get medicalConditionIdsHint;

  /// No description provided for @doctorUsername.
  ///
  /// In en, this message translates to:
  /// **'Doctor Username'**
  String get doctorUsername;

  /// No description provided for @targetUsername.
  ///
  /// In en, this message translates to:
  /// **'Target Username'**
  String get targetUsername;

  /// No description provided for @categoryName.
  ///
  /// In en, this message translates to:
  /// **'Category Name'**
  String get categoryName;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @greeting.
  ///
  /// In en, this message translates to:
  /// **'Hi, {name}'**
  String greeting(String name);

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @heartRate.
  ///
  /// In en, this message translates to:
  /// **'Heart Rate'**
  String get heartRate;

  /// No description provided for @temperature.
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get temperature;

  /// No description provided for @movement.
  ///
  /// In en, this message translates to:
  /// **'Movement'**
  String get movement;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @liveHealthMonitoring.
  ///
  /// In en, this message translates to:
  /// **'Live Health Monitoring'**
  String get liveHealthMonitoring;

  /// No description provided for @bpm.
  ///
  /// In en, this message translates to:
  /// **'BPM'**
  String get bpm;

  /// No description provided for @normalRangeHeartRate.
  ///
  /// In en, this message translates to:
  /// **'Normal range: 60-100'**
  String get normalRangeHeartRate;

  /// No description provided for @celsius.
  ///
  /// In en, this message translates to:
  /// **'°C'**
  String get celsius;

  /// No description provided for @normalRangeTemperature.
  ///
  /// In en, this message translates to:
  /// **'Normal range: 36.1-37.2'**
  String get normalRangeTemperature;

  /// No description provided for @steps.
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get steps;

  /// No description provided for @normalActivity.
  ///
  /// In en, this message translates to:
  /// **'Normal Activity'**
  String get normalActivity;

  /// No description provided for @aiHealthInsight.
  ///
  /// In en, this message translates to:
  /// **'AI Health Insight'**
  String get aiHealthInsight;

  /// No description provided for @healthStatusIs.
  ///
  /// In en, this message translates to:
  /// **'Your health status is '**
  String get healthStatusIs;

  /// No description provided for @stable.
  ///
  /// In en, this message translates to:
  /// **'stable'**
  String get stable;

  /// No description provided for @vitalSignsNormal.
  ///
  /// In en, this message translates to:
  /// **'. All vital signs are within normal ranges.'**
  String get vitalSignsNormal;

  /// No description provided for @recentAlerts.
  ///
  /// In en, this message translates to:
  /// **'Recent Alerts'**
  String get recentAlerts;

  /// No description provided for @noRecentAlerts.
  ///
  /// In en, this message translates to:
  /// **'No recent alerts'**
  String get noRecentAlerts;

  /// No description provided for @noAiInsights.
  ///
  /// In en, this message translates to:
  /// **'No AI insights generated yet. Waiting for more data...'**
  String get noAiInsights;

  /// No description provided for @noChartData.
  ///
  /// In en, this message translates to:
  /// **'No chart data available'**
  String get noChartData;

  /// No description provided for @highHeartRate.
  ///
  /// In en, this message translates to:
  /// **'High heart rate'**
  String get highHeartRate;

  /// No description provided for @today847am.
  ///
  /// In en, this message translates to:
  /// **'Today, 08:47 AM'**
  String get today847am;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// No description provided for @fallDetected.
  ///
  /// In en, this message translates to:
  /// **'Fall Detected'**
  String get fallDetected;

  /// No description provided for @yesterday615pm.
  ///
  /// In en, this message translates to:
  /// **'Yesterday, 06:15 PM'**
  String get yesterday615pm;

  /// No description provided for @high.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get high;

  /// No description provided for @addNew.
  ///
  /// In en, this message translates to:
  /// **'Add New'**
  String get addNew;

  /// No description provided for @sosButtonPressed.
  ///
  /// In en, this message translates to:
  /// **'SOS button pressed'**
  String get sosButtonPressed;

  /// No description provided for @daysAgo2_1132am.
  ///
  /// In en, this message translates to:
  /// **'2 days ago, 11:32 AM'**
  String get daysAgo2_1132am;

  /// No description provided for @low.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get low;

  /// No description provided for @lastVisited.
  ///
  /// In en, this message translates to:
  /// **'Last Visited'**
  String get lastVisited;

  /// No description provided for @unknownDistance.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknownDistance;

  /// No description provided for @sensorsDisconnected.
  ///
  /// In en, this message translates to:
  /// **'Sensors Disconnected'**
  String get sensorsDisconnected;

  /// No description provided for @sensorsDisconnectedDesc.
  ///
  /// In en, this message translates to:
  /// **'Unable to retrieve live sensor readings right now. Please check the sensor connection and try again.'**
  String get sensorsDisconnectedDesc;

  /// No description provided for @chatbotWelcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Hello! I\'m your ChairPal AI assistant 🌍\\nAsk me anything about places, travel tips, or nearby spots!'**
  String get chatbotWelcomeMessage;

  /// No description provided for @chatClearedMessage.
  ///
  /// In en, this message translates to:
  /// **'Chat cleared. How can I help you?'**
  String get chatClearedMessage;

  /// No description provided for @newChat.
  ///
  /// In en, this message translates to:
  /// **'New Chat'**
  String get newChat;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @chairPalAI.
  ///
  /// In en, this message translates to:
  /// **'ChairPal AI'**
  String get chairPalAI;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @noSessionsFound.
  ///
  /// In en, this message translates to:
  /// **'No sessions found.'**
  String get noSessionsFound;

  /// No description provided for @typeYourMessage.
  ///
  /// In en, this message translates to:
  /// **'Type your message...'**
  String get typeYourMessage;

  /// No description provided for @descriptionOptional.
  ///
  /// In en, this message translates to:
  /// **'Description (Optional)'**
  String get descriptionOptional;

  /// No description provided for @buildings.
  ///
  /// In en, this message translates to:
  /// **'Buildings'**
  String get buildings;

  /// No description provided for @addBuilding.
  ///
  /// In en, this message translates to:
  /// **'Add Building'**
  String get addBuilding;

  /// No description provided for @addNewBuilding.
  ///
  /// In en, this message translates to:
  /// **'Add New Building'**
  String get addNewBuilding;

  /// No description provided for @buildingName.
  ///
  /// In en, this message translates to:
  /// **'Building Name'**
  String get buildingName;

  /// No description provided for @uploadBuildingImage.
  ///
  /// In en, this message translates to:
  /// **'Upload Building Main Image'**
  String get uploadBuildingImage;

  /// No description provided for @buildingAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Building added successfully!'**
  String get buildingAddedSuccessfully;

  /// No description provided for @noBuildingsFound.
  ///
  /// In en, this message translates to:
  /// **'No buildings found.'**
  String get noBuildingsFound;

  /// No description provided for @aboutBuilding.
  ///
  /// In en, this message translates to:
  /// **'About Building'**
  String get aboutBuilding;

  /// No description provided for @rateThisBuilding.
  ///
  /// In en, this message translates to:
  /// **'Rate this building'**
  String get rateThisBuilding;

  /// No description provided for @floors.
  ///
  /// In en, this message translates to:
  /// **'Floors'**
  String get floors;

  /// No description provided for @addFloor.
  ///
  /// In en, this message translates to:
  /// **'Add Floor'**
  String get addFloor;

  /// No description provided for @addNewFloor.
  ///
  /// In en, this message translates to:
  /// **'Add New Floor'**
  String get addNewFloor;

  /// No description provided for @floorName.
  ///
  /// In en, this message translates to:
  /// **'Floor Name'**
  String get floorName;

  /// No description provided for @floorLevel.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get floorLevel;

  /// No description provided for @uploadFloorImage.
  ///
  /// In en, this message translates to:
  /// **'Upload Floor Image (Optional)'**
  String get uploadFloorImage;

  /// No description provided for @floorAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Floor added successfully!'**
  String get floorAddedSuccessfully;

  /// No description provided for @noFloorsFound.
  ///
  /// In en, this message translates to:
  /// **'No floors found.'**
  String get noFloorsFound;

  /// No description provided for @aboutFloor.
  ///
  /// In en, this message translates to:
  /// **'About Floor'**
  String get aboutFloor;

  /// No description provided for @rateThisFloor.
  ///
  /// In en, this message translates to:
  /// **'Rate this floor'**
  String get rateThisFloor;

  /// No description provided for @places.
  ///
  /// In en, this message translates to:
  /// **'Places'**
  String get places;

  /// No description provided for @addPlace.
  ///
  /// In en, this message translates to:
  /// **'Add Place'**
  String get addPlace;

  /// No description provided for @addNewPlace.
  ///
  /// In en, this message translates to:
  /// **'Add New Place'**
  String get addNewPlace;

  /// No description provided for @placeName.
  ///
  /// In en, this message translates to:
  /// **'Place Name'**
  String get placeName;

  /// No description provided for @uploadPlaceImage.
  ///
  /// In en, this message translates to:
  /// **'Upload Place Image (Optional)'**
  String get uploadPlaceImage;

  /// No description provided for @placeAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Place added successfully!'**
  String get placeAddedSuccessfully;

  /// No description provided for @noPlacesFound.
  ///
  /// In en, this message translates to:
  /// **'No places found.'**
  String get noPlacesFound;

  /// No description provided for @buildingsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Buildings'**
  String buildingsCount(int count);

  /// No description provided for @floorsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Floors'**
  String floorsCount(int count);

  /// No description provided for @placesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Places'**
  String placesCount(int count);

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @rateThisPlace.
  ///
  /// In en, this message translates to:
  /// **'Rate this place'**
  String get rateThisPlace;

  /// No description provided for @addOrganization.
  ///
  /// In en, this message translates to:
  /// **'Add Organization'**
  String get addOrganization;

  /// No description provided for @organizationName.
  ///
  /// In en, this message translates to:
  /// **'Organization Name'**
  String get organizationName;

  /// No description provided for @uploadOrganizationImage.
  ///
  /// In en, this message translates to:
  /// **'Upload Organization Main Image'**
  String get uploadOrganizationImage;

  /// No description provided for @organizationAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Organization added successfully!'**
  String get organizationAddedSuccessfully;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get requiredField;

  /// No description provided for @buildingNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Main Building'**
  String get buildingNameHint;

  /// No description provided for @buildingDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Describe the building...'**
  String get buildingDescriptionHint;

  /// No description provided for @categoryNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Universities'**
  String get categoryNameHint;

  /// No description provided for @floorNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Ground Floor'**
  String get floorNameHint;

  /// No description provided for @floorLevelHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 0 or 1'**
  String get floorLevelHint;

  /// No description provided for @floorDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Describe the floor...'**
  String get floorDescriptionHint;

  /// No description provided for @organizationNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. FCAI Faculty'**
  String get organizationNameHint;

  /// No description provided for @countryHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Egypt'**
  String get countryHint;

  /// No description provided for @cityHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Banha'**
  String get cityHint;

  /// No description provided for @organizationDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Describe the organization...'**
  String get organizationDescriptionHint;

  /// No description provided for @placeNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Room 101, Cafeteria'**
  String get placeNameHint;

  /// No description provided for @placeDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Describe the place...'**
  String get placeDescriptionHint;

  /// No description provided for @rateAppHint.
  ///
  /// In en, this message translates to:
  /// **'Type your opinion (Optional).. '**
  String get rateAppHint;

  /// No description provided for @locationServicesDisabled.
  ///
  /// In en, this message translates to:
  /// **'Location services are disabled.'**
  String get locationServicesDisabled;

  /// No description provided for @locationPermissionsDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permissions are denied.'**
  String get locationPermissionsDenied;

  /// No description provided for @locationPermissionsPermanentlyDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permissions are permanently denied.'**
  String get locationPermissionsPermanentlyDenied;

  /// No description provided for @fetchingLocation.
  ///
  /// In en, this message translates to:
  /// **'Fetching location...'**
  String get fetchingLocation;

  /// No description provided for @locationFetched.
  ///
  /// In en, this message translates to:
  /// **'Location fetched'**
  String get locationFetched;

  /// No description provided for @pleaseSetLocationFirst.
  ///
  /// In en, this message translates to:
  /// **'Please set the location first.'**
  String get pleaseSetLocationFirst;

  /// No description provided for @enterOrganizationLocationHint.
  ///
  /// In en, this message translates to:
  /// **'Enter organization\'s location'**
  String get enterOrganizationLocationHint;

  /// No description provided for @imageOfOrganization.
  ///
  /// In en, this message translates to:
  /// **'Image of Organization'**
  String get imageOfOrganization;

  /// No description provided for @typeDescriptionHere.
  ///
  /// In en, this message translates to:
  /// **'Type the description here..'**
  String get typeDescriptionHere;

  /// No description provided for @floorsNumberLevels.
  ///
  /// In en, this message translates to:
  /// **'Floors number/ Levels'**
  String get floorsNumberLevels;

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get recentActivity;

  /// No description provided for @noRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'No recent activity.'**
  String get noRecentActivity;

  /// No description provided for @yourPlaces.
  ///
  /// In en, this message translates to:
  /// **'Your Places'**
  String get yourPlaces;

  /// No description provided for @patients.
  ///
  /// In en, this message translates to:
  /// **'Patients'**
  String get patients;

  /// No description provided for @totalPatients.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get totalPatients;

  /// No description provided for @normal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normal;

  /// No description provided for @critical.
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get critical;

  /// No description provided for @noPatientsAssigned.
  ///
  /// In en, this message translates to:
  /// **'No patients assigned yet.'**
  String get noPatientsAssigned;

  /// No description provided for @totalPlaces.
  ///
  /// In en, this message translates to:
  /// **'Total Places'**
  String get totalPlaces;

  /// No description provided for @companionRequestPending.
  ///
  /// In en, this message translates to:
  /// **'Companion Request Pending'**
  String get companionRequestPending;

  /// No description provided for @companionRequestPendingDesc.
  ///
  /// In en, this message translates to:
  /// **'Your companion request is currently waiting for the user\'s approval. You\'ll gain access once the request is accepted.'**
  String get companionRequestPendingDesc;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @requestAcceptedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Request Accepted Successfully'**
  String get requestAcceptedSuccessfully;

  /// No description provided for @requestAcceptedDesc.
  ///
  /// In en, this message translates to:
  /// **'Welcome aboard! Your companion request has been accepted. You can now start monitoring and supporting the user.'**
  String get requestAcceptedDesc;

  /// No description provided for @companionRequestRejected.
  ///
  /// In en, this message translates to:
  /// **'Companion Request Rejected'**
  String get companionRequestRejected;

  /// No description provided for @companionRequestRejectedDesc.
  ///
  /// In en, this message translates to:
  /// **'Your companion request was declined by the user. Please check the username and try sending a new request.'**
  String get companionRequestRejectedDesc;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to login'**
  String get backToLogin;

  /// No description provided for @companions.
  ///
  /// In en, this message translates to:
  /// **'Companions'**
  String get companions;

  /// No description provided for @helpIsOnTheWay.
  ///
  /// In en, this message translates to:
  /// **'Help Is On The Way'**
  String get helpIsOnTheWay;

  /// No description provided for @emergencyAlertSent.
  ///
  /// In en, this message translates to:
  /// **'Your emergency alert and live location have been sent to your companions.'**
  String get emergencyAlertSent;

  /// No description provided for @deleteCompanion.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this Companion?'**
  String get deleteCompanion;

  /// No description provided for @newCompanionRequest.
  ///
  /// In en, this message translates to:
  /// **'New Companion Request'**
  String get newCompanionRequest;

  /// No description provided for @wantsToFollow.
  ///
  /// In en, this message translates to:
  /// **'wants to follow your status and receive emergency alerts.'**
  String get wantsToFollow;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @decline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get decline;

  /// No description provided for @noEmergencyCompanions.
  ///
  /// In en, this message translates to:
  /// **'No Emergency Companions added'**
  String get noEmergencyCompanions;

  /// No description provided for @giveYourUsernameDesc.
  ///
  /// In en, this message translates to:
  /// **'Give your username to emergency companions you want so they can receive alerts and your location when needed'**
  String get giveYourUsernameDesc;

  /// No description provided for @manageTrustedCompanions.
  ///
  /// In en, this message translates to:
  /// **'Manage trusted companions to receive alerts and your location'**
  String get manageTrustedCompanions;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @pressSOS.
  ///
  /// In en, this message translates to:
  /// **'Press the SOS button to send alerts and your location'**
  String get pressSOS;

  /// No description provided for @noConnections.
  ///
  /// In en, this message translates to:
  /// **'No Connections'**
  String get noConnections;

  /// No description provided for @enterPatientUsernameToSendConnectionRequest.
  ///
  /// In en, this message translates to:
  /// **'Enter a patients username to send a connection request.'**
  String get enterPatientUsernameToSendConnectionRequest;

  /// No description provided for @patientUsername.
  ///
  /// In en, this message translates to:
  /// **'Patients Username'**
  String get patientUsername;

  /// No description provided for @sendRequest.
  ///
  /// In en, this message translates to:
  /// **'Send Request'**
  String get sendRequest;

  /// No description provided for @helpSupportAssistance.
  ///
  /// In en, this message translates to:
  /// **'Need assistance? The ChairPal team is ready to help you.'**
  String get helpSupportAssistance;

  /// No description provided for @helpSupportContactInfo.
  ///
  /// In en, this message translates to:
  /// **'Contact Info'**
  String get helpSupportContactInfo;

  /// No description provided for @helpSupportMessage.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get helpSupportMessage;

  /// No description provided for @helpSupportMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Type the message here..'**
  String get helpSupportMessageHint;

  /// No description provided for @helpSupportSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get helpSupportSend;

  /// No description provided for @helpSupportSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Message sent successfully!'**
  String get helpSupportSuccessMessage;

  /// No description provided for @helpSupportSuccessDesc1.
  ///
  /// In en, this message translates to:
  /// **'Thank you for contacting us. '**
  String get helpSupportSuccessDesc1;

  /// No description provided for @helpSupportSuccessDesc2.
  ///
  /// In en, this message translates to:
  /// **'ChairPal'**
  String get helpSupportSuccessDesc2;

  /// No description provided for @helpSupportSuccessDesc3.
  ///
  /// In en, this message translates to:
  /// **' support team will get back to you.'**
  String get helpSupportSuccessDesc3;

  /// No description provided for @cancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// No description provided for @logoutButton.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logoutButton;

  /// No description provided for @deleteButton.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteButton;

  /// No description provided for @myAccount.
  ///
  /// In en, this message translates to:
  /// **'My Account'**
  String get myAccount;

  /// No description provided for @updateProfile.
  ///
  /// In en, this message translates to:
  /// **'Update Profile'**
  String get updateProfile;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// No description provided for @dateOfBirthHint.
  ///
  /// In en, this message translates to:
  /// **'Select Date of Birth'**
  String get dateOfBirthHint;

  /// No description provided for @logoutOtherDevices.
  ///
  /// In en, this message translates to:
  /// **'Logout other devices'**
  String get logoutOtherDevices;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @cm.
  ///
  /// In en, this message translates to:
  /// **'cm'**
  String get cm;

  /// No description provided for @kg.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get kg;

  /// No description provided for @medicalInfo.
  ///
  /// In en, this message translates to:
  /// **'Medical Info'**
  String get medicalInfo;

  /// No description provided for @profileUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdatedSuccessfully;

  /// No description provided for @pleaseConnectFromDoctorSearch.
  ///
  /// In en, this message translates to:
  /// **'Please connect from Doctor Search'**
  String get pleaseConnectFromDoctorSearch;

  /// No description provided for @messageButton.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get messageButton;

  /// No description provided for @addFriendButton.
  ///
  /// In en, this message translates to:
  /// **'Add friend'**
  String get addFriendButton;

  /// No description provided for @pendingButton.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pendingButton;

  /// No description provided for @chatsTitle.
  ///
  /// In en, this message translates to:
  /// **'Chats'**
  String get chatsTitle;

  /// No description provided for @noChatsYet.
  ///
  /// In en, this message translates to:
  /// **'No Chats Yet'**
  String get noChatsYet;

  /// No description provided for @friendRequestSentSuccess.
  ///
  /// In en, this message translates to:
  /// **'Friend request sent successfully.'**
  String get friendRequestSentSuccess;

  /// No description provided for @friendRequestSentFail.
  ///
  /// In en, this message translates to:
  /// **'Failed to send friend request.'**
  String get friendRequestSentFail;

  /// No description provided for @saySomethingAboutThis.
  ///
  /// In en, this message translates to:
  /// **'Say something about this...'**
  String get saySomethingAboutThis;

  /// No description provided for @shareNow.
  ///
  /// In en, this message translates to:
  /// **'Share Now'**
  String get shareNow;

  /// No description provided for @writeAComment.
  ///
  /// In en, this message translates to:
  /// **'Write a comment...'**
  String get writeAComment;

  /// No description provided for @typeAMessage.
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get typeAMessage;

  /// No description provided for @noCommentsYet.
  ///
  /// In en, this message translates to:
  /// **'No comments yet.'**
  String get noCommentsYet;

  /// No description provided for @warningLabel.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warningLabel;

  /// No description provided for @youDontHaveAnyConnectedPatients.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any connected patients.\\nApproved patient connections will appear here.'**
  String get youDontHaveAnyConnectedPatients;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get noData;

  /// No description provided for @lastUpdate.
  ///
  /// In en, this message translates to:
  /// **'Last update: '**
  String get lastUpdate;

  /// No description provided for @noNotificationsYet.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet.'**
  String get noNotificationsYet;

  /// No description provided for @requestRejectedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Request Rejected Successfully'**
  String get requestRejectedSuccessfully;

  /// No description provided for @requestAlreadyHandled.
  ///
  /// In en, this message translates to:
  /// **'This request has already been handled.'**
  String get requestAlreadyHandled;

  /// No description provided for @noNotificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any notifications at the moment.\nAny alerts and updates will appear here'**
  String get noNotificationsSubtitle;

  /// No description provided for @noNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'No Notifications Yet'**
  String get noNotificationsTitle;

  /// No description provided for @editPlace.
  ///
  /// In en, this message translates to:
  /// **'Edit Place'**
  String get editPlace;

  /// No description provided for @pleaseSelectRating.
  ///
  /// In en, this message translates to:
  /// **'Please select a rating first.'**
  String get pleaseSelectRating;

  /// No description provided for @reviewPostedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Review posted successfully!'**
  String get reviewPostedSuccess;

  /// No description provided for @submitReview.
  ///
  /// In en, this message translates to:
  /// **'Submit Review'**
  String get submitReview;

  /// No description provided for @cannotReviewPlace.
  ///
  /// In en, this message translates to:
  /// **'This place cannot be reviewed.'**
  String get cannotReviewPlace;

  /// No description provided for @reviewsVisibilityNote.
  ///
  /// In en, this message translates to:
  /// **'All users can see your reviews that contain your profile info'**
  String get reviewsVisibilityNote;

  /// No description provided for @ratePlaceTitle.
  ///
  /// In en, this message translates to:
  /// **'Rate {name}'**
  String ratePlaceTitle(String name);
}

class _SDelegate extends LocalizationsDelegate<S> {
  const _SDelegate();

  @override
  Future<S> load(Locale locale) {
    return SynchronousFuture<S>(lookupS(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'de',
    'en',
    'fr',
    'hi',
    'ko',
    'vi',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_SDelegate old) => false;
}

S lookupS(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return SAr();
    case 'de':
      return SDe();
    case 'en':
      return SEn();
    case 'fr':
      return SFr();
    case 'hi':
      return SHi();
    case 'ko':
      return SKo();
    case 'vi':
      return SVi();
  }

  throw FlutterError(
    'S.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
