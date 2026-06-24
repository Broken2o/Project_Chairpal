// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(categoryName) => "${categoryName} category added";

  static String m1(placeName, categoryName) =>
      "${placeName} was added to ${categoryName}";

  static String m2(placeName) => "${placeName} details updated";

  static String m3(count) => "${count} day ago";

  static String m4(count) => "${count} hours ago";

  static String m5(count) => "${count} Categories";

  static String m6(count) => "${count} Buildings";

  static String m7(count) => "${count} Floors";

  static String m8(name) => "Hi, ${name}";

  static String m9(name) => "Hi, ${name}";

  static String m10(date) => "Joined ${date}";

  static String m11(count) => "${count} Places";

  static String m12(category) => "Popular in ${category}";

  static String m13(name) => "Rate ${name}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "about": MessageLookupByLibrary.simpleMessage("About"),
    "aboutBuilding": MessageLookupByLibrary.simpleMessage("About Building"),
    "aboutFloor": MessageLookupByLibrary.simpleMessage("About Floor"),
    "accept": MessageLookupByLibrary.simpleMessage("Accept"),
    "addBuilding": MessageLookupByLibrary.simpleMessage("Add Building"),
    "addCategory": MessageLookupByLibrary.simpleMessage("Add Category"),
    "addFloor": MessageLookupByLibrary.simpleMessage("Add Floor"),
    "addFriend": MessageLookupByLibrary.simpleMessage("Add Friend"),
    "addFriendButton": MessageLookupByLibrary.simpleMessage("Add friend"),
    "addNew": MessageLookupByLibrary.simpleMessage("Add New"),
    "addNewBuilding": MessageLookupByLibrary.simpleMessage("Add New Building"),
    "addNewFloor": MessageLookupByLibrary.simpleMessage("Add New Floor"),
    "addNewOrganization": MessageLookupByLibrary.simpleMessage(
      "Add new organization",
    ),
    "addNewPlace": MessageLookupByLibrary.simpleMessage("Add New Place"),
    "addNewPostPrompt": MessageLookupByLibrary.simpleMessage("Add New Post?"),
    "addOrganization": MessageLookupByLibrary.simpleMessage("Add Organization"),
    "addPlace": MessageLookupByLibrary.simpleMessage("Add Place"),
    "adminActivityNewCategory": MessageLookupByLibrary.simpleMessage(
      "New category created",
    ),
    "adminActivityNewCategorySub": m0,
    "adminActivityNewPlace": MessageLookupByLibrary.simpleMessage(
      "New place added",
    ),
    "adminActivityNewPlaceSub": m1,
    "adminActivityPlaceUpdated": MessageLookupByLibrary.simpleMessage(
      "Place updated",
    ),
    "adminActivityPlaceUpdatedSub": m2,
    "adminAddCategory": MessageLookupByLibrary.simpleMessage("Add Category"),
    "adminAddPlace": MessageLookupByLibrary.simpleMessage("Add Place"),
    "adminEditInfo": MessageLookupByLibrary.simpleMessage("Edit Info"),
    "adminManagePlacesSubtitle": MessageLookupByLibrary.simpleMessage(
      "Here you can manage your places easily",
    ),
    "adminMockPlaceHotel": MessageLookupByLibrary.simpleMessage("7 Star Hotel"),
    "adminMockPlaceRestaurant": MessageLookupByLibrary.simpleMessage(
      "Green Valley Restaurant",
    ),
    "adminMockPlaceUniversity": MessageLookupByLibrary.simpleMessage(
      "Damietta University",
    ),
    "adminMockTypeHotel": MessageLookupByLibrary.simpleMessage("Hotel"),
    "adminMockTypeRestaurant": MessageLookupByLibrary.simpleMessage(
      "Restaurant",
    ),
    "adminMockTypeUniversity": MessageLookupByLibrary.simpleMessage(
      "University",
    ),
    "adminOverview": MessageLookupByLibrary.simpleMessage("Overview"),
    "adminPanelTitle": MessageLookupByLibrary.simpleMessage("Admin Dashboard"),
    "adminQuickActions": MessageLookupByLibrary.simpleMessage("Quick Actions"),
    "adminRecentActivity": MessageLookupByLibrary.simpleMessage(
      "Recent Activity",
    ),
    "adminTimeDaysAgo": m3,
    "adminTimeHoursAgo": m4,
    "adminTotalCategories": m5,
    "adminTotalPlaces": MessageLookupByLibrary.simpleMessage("Total Places"),
    "adminViewAll": MessageLookupByLibrary.simpleMessage("View all"),
    "adminWelcomeBack": MessageLookupByLibrary.simpleMessage("Welcome back"),
    "adminYourPlaces": MessageLookupByLibrary.simpleMessage("Your Places"),
    "age": MessageLookupByLibrary.simpleMessage("Age"),
    "agreeToPolicy": MessageLookupByLibrary.simpleMessage(
      "I agree to the policies",
    ),
    "aiHealthInsight": MessageLookupByLibrary.simpleMessage(
      "AI Health Insight",
    ),
    "alarm": MessageLookupByLibrary.simpleMessage("Alarm"),
    "allLanguages": MessageLookupByLibrary.simpleMessage("All Languages"),
    "alreadyHaveAccount": MessageLookupByLibrary.simpleMessage(
      "Already have an account?",
    ),
    "appName": MessageLookupByLibrary.simpleMessage("Chair Pal"),
    "arabic": MessageLookupByLibrary.simpleMessage("Arabic"),
    "back": MessageLookupByLibrary.simpleMessage("Back"),
    "backToLogin": MessageLookupByLibrary.simpleMessage("Back to login"),
    "battery": MessageLookupByLibrary.simpleMessage("Battery"),
    "birthDate": MessageLookupByLibrary.simpleMessage("Birth Date"),
    "birthDateHint": MessageLookupByLibrary.simpleMessage("YYYY-MM-DD"),
    "bpm": MessageLookupByLibrary.simpleMessage("BPM"),
    "buildingAddedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Building added successfully!",
    ),
    "buildingDescriptionHint": MessageLookupByLibrary.simpleMessage(
      "Describe the building...",
    ),
    "buildingName": MessageLookupByLibrary.simpleMessage("Building Name"),
    "buildingNameHint": MessageLookupByLibrary.simpleMessage(
      "e.g. Main Building",
    ),
    "buildings": MessageLookupByLibrary.simpleMessage("Buildings"),
    "buildingsCount": m6,
    "camera": MessageLookupByLibrary.simpleMessage("Camera"),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "cancelButton": MessageLookupByLibrary.simpleMessage("Cancel"),
    "cannotReviewPlace": MessageLookupByLibrary.simpleMessage(
      "This place cannot be reviewed.",
    ),
    "categories": MessageLookupByLibrary.simpleMessage("Categories"),
    "categoryAddedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Category added successfully!",
    ),
    "categoryName": MessageLookupByLibrary.simpleMessage("Category Name"),
    "categoryNameHint": MessageLookupByLibrary.simpleMessage(
      "e.g. Universities",
    ),
    "celsius": MessageLookupByLibrary.simpleMessage("°C"),
    "chairPalAI": MessageLookupByLibrary.simpleMessage("ChairPal AI"),
    "changeMyEChair": MessageLookupByLibrary.simpleMessage("Change my e-chair"),
    "changePassword": MessageLookupByLibrary.simpleMessage("Change Password"),
    "chatClearedMessage": MessageLookupByLibrary.simpleMessage(
      "Chat cleared. How can I help you?",
    ),
    "chatbotWelcomeMessage": MessageLookupByLibrary.simpleMessage(
      "Hello! I\'m your ChairPal AI assistant 🌍\\nAsk me anything about places, travel tips, or nearby spots!",
    ),
    "chatsTitle": MessageLookupByLibrary.simpleMessage("Chats"),
    "choose": MessageLookupByLibrary.simpleMessage("Choose"),
    "city": MessageLookupByLibrary.simpleMessage("City"),
    "cityHint": MessageLookupByLibrary.simpleMessage("e.g. Banha"),
    "cm": MessageLookupByLibrary.simpleMessage("cm"),
    "codeResentSuccess": MessageLookupByLibrary.simpleMessage(
      "Code has been resent successfully.",
    ),
    "comment": MessageLookupByLibrary.simpleMessage("Comment"),
    "companionRequestPending": MessageLookupByLibrary.simpleMessage(
      "Companion Request Pending",
    ),
    "companionRequestPendingDesc": MessageLookupByLibrary.simpleMessage(
      "Your companion request is currently waiting for the user\'s approval. You\'ll gain access once the request is accepted.",
    ),
    "companionRequestRejected": MessageLookupByLibrary.simpleMessage(
      "Companion Request Rejected",
    ),
    "companionRequestRejectedDesc": MessageLookupByLibrary.simpleMessage(
      "Your companion request was declined by the user. Please check the username and try sending a new request.",
    ),
    "companions": MessageLookupByLibrary.simpleMessage("Companions"),
    "conditionDiabetes": MessageLookupByLibrary.simpleMessage("Diabetes"),
    "conditionElderly": MessageLookupByLibrary.simpleMessage("Elderly"),
    "conditionEpilepsy": MessageLookupByLibrary.simpleMessage("Epilepsy"),
    "conditionHeartDisease": MessageLookupByLibrary.simpleMessage(
      "Heart Disease",
    ),
    "conditionHighBloodPressure": MessageLookupByLibrary.simpleMessage(
      "High Blood Pressure",
    ),
    "conditionNone": MessageLookupByLibrary.simpleMessage("None of the above"),
    "confirm": MessageLookupByLibrary.simpleMessage("Confirm"),
    "confirmLocation": MessageLookupByLibrary.simpleMessage("Confirm Location"),
    "confirmNewPassword": MessageLookupByLibrary.simpleMessage(
      "Confirm New Password",
    ),
    "confirmPassword": MessageLookupByLibrary.simpleMessage("Confirm Password"),
    "connected": MessageLookupByLibrary.simpleMessage("Connected"),
    "connecting": MessageLookupByLibrary.simpleMessage("Connecting..."),
    "connectionError": MessageLookupByLibrary.simpleMessage("Connection Error"),
    "continueButton": MessageLookupByLibrary.simpleMessage("Continue"),
    "controlEChair": MessageLookupByLibrary.simpleMessage(
      "Control your e-chair",
    ),
    "country": MessageLookupByLibrary.simpleMessage("Country"),
    "countryHint": MessageLookupByLibrary.simpleMessage("e.g. Egypt"),
    "createAccount": MessageLookupByLibrary.simpleMessage("Create Account"),
    "critical": MessageLookupByLibrary.simpleMessage("Critical"),
    "currentLocation": MessageLookupByLibrary.simpleMessage("Current Location"),
    "currentPassword": MessageLookupByLibrary.simpleMessage("Current Password"),
    "dateOfBirth": MessageLookupByLibrary.simpleMessage("Date of Birth"),
    "dateOfBirthHint": MessageLookupByLibrary.simpleMessage(
      "Select Date of Birth",
    ),
    "daysAgo2_1132am": MessageLookupByLibrary.simpleMessage(
      "2 days ago, 11:32 AM",
    ),
    "decline": MessageLookupByLibrary.simpleMessage("Decline"),
    "delete": MessageLookupByLibrary.simpleMessage("Delete"),
    "deleteAccount": MessageLookupByLibrary.simpleMessage("Delete Account"),
    "deleteAccountDialogTitle": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to delete your account?",
    ),
    "deleteButton": MessageLookupByLibrary.simpleMessage("Delete"),
    "deleteCompanion": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to delete this Companion?",
    ),
    "description": MessageLookupByLibrary.simpleMessage("Description"),
    "descriptionOptional": MessageLookupByLibrary.simpleMessage(
      "Description (Optional)",
    ),
    "didNotReceiveCode": MessageLookupByLibrary.simpleMessage(
      "Didn\'t receive the code?",
    ),
    "disconnected": MessageLookupByLibrary.simpleMessage("Disconnected"),
    "doctorUsername": MessageLookupByLibrary.simpleMessage("Doctor Username"),
    "dontHaveAccount": MessageLookupByLibrary.simpleMessage(
      "Don\'t have an account?",
    ),
    "dragDropImage": MessageLookupByLibrary.simpleMessage(
      "Drag & drop image or Browse",
    ),
    "eChairSubtitle": MessageLookupByLibrary.simpleMessage(
      "Manage and monitor your e-chair using the options below",
    ),
    "eChairTitle": MessageLookupByLibrary.simpleMessage("E-Chair"),
    "editPlace": MessageLookupByLibrary.simpleMessage("Edit Place"),
    "email": MessageLookupByLibrary.simpleMessage("Email"),
    "emailHint": MessageLookupByLibrary.simpleMessage("example@gmail.com"),
    "emailVerifiedSuccess": MessageLookupByLibrary.simpleMessage(
      "Awesome! Your Email has been verified successfully.",
    ),
    "emergency": MessageLookupByLibrary.simpleMessage("Emergency"),
    "emergencyAlertSent": MessageLookupByLibrary.simpleMessage(
      "Your emergency alert and live location have been sent to your companions.",
    ),
    "english": MessageLookupByLibrary.simpleMessage("English"),
    "enterAge": MessageLookupByLibrary.simpleMessage("18"),
    "enterCurrentAndNewPassword": MessageLookupByLibrary.simpleMessage(
      "Enter your current password and a new password.",
    ),
    "enterLocation": MessageLookupByLibrary.simpleMessage(
      "Enter your location",
    ),
    "enterOrganizationLocationHint": MessageLookupByLibrary.simpleMessage(
      "Enter organization\'s location",
    ),
    "enterOtpCode": MessageLookupByLibrary.simpleMessage("Enter OTP Code"),
    "enterPatientUsernameToSendConnectionRequest":
        MessageLookupByLibrary.simpleMessage(
          "Enter a patients username to send a connection request.",
        ),
    "enterPhoneNumber": MessageLookupByLibrary.simpleMessage(
      "Enter your phone number",
    ),
    "enterVerificationCode": MessageLookupByLibrary.simpleMessage(
      "Enter Verification Code",
    ),
    "fallDetected": MessageLookupByLibrary.simpleMessage("Fall Detected"),
    "female": MessageLookupByLibrary.simpleMessage("Female"),
    "fetchingLocation": MessageLookupByLibrary.simpleMessage(
      "Fetching location...",
    ),
    "floorAddedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Floor added successfully!",
    ),
    "floorDescriptionHint": MessageLookupByLibrary.simpleMessage(
      "Describe the floor...",
    ),
    "floorLevel": MessageLookupByLibrary.simpleMessage("Level"),
    "floorLevelHint": MessageLookupByLibrary.simpleMessage("e.g. 0 or 1"),
    "floorName": MessageLookupByLibrary.simpleMessage("Floor Name"),
    "floorNameHint": MessageLookupByLibrary.simpleMessage("e.g. Ground Floor"),
    "floors": MessageLookupByLibrary.simpleMessage("Floors"),
    "floorsCount": m7,
    "floorsNumberLevels": MessageLookupByLibrary.simpleMessage(
      "Floors number/ Levels",
    ),
    "followDoctor": MessageLookupByLibrary.simpleMessage("Follow Doctor?"),
    "forgotPassword": MessageLookupByLibrary.simpleMessage("Forgot Password?"),
    "forgotPasswordSubtitle": MessageLookupByLibrary.simpleMessage(
      "Enter your email address and we\'ll send you a verification code to reset your password.",
    ),
    "forgotPasswordTitle": MessageLookupByLibrary.simpleMessage(
      "Forgot Password?",
    ),
    "friendRequestSentFail": MessageLookupByLibrary.simpleMessage(
      "Failed to send friend request.",
    ),
    "friendRequestSentSuccess": MessageLookupByLibrary.simpleMessage(
      "Friend request sent successfully.",
    ),
    "gallery": MessageLookupByLibrary.simpleMessage("Gallery"),
    "gender": MessageLookupByLibrary.simpleMessage("Gender"),
    "getStarted": MessageLookupByLibrary.simpleMessage("Get Started"),
    "giveYourUsernameDesc": MessageLookupByLibrary.simpleMessage(
      "Give your username to emergency companions you want so they can receive alerts and your location when needed",
    ),
    "greeting": m8,
    "healthAssistantIntroMessage": MessageLookupByLibrary.simpleMessage(
      "Before we begin, answer a few quick questions to personalize your health monitoring.",
    ),
    "healthAssistantIntroTitle": MessageLookupByLibrary.simpleMessage(
      "Hi, I\'m your health assistant!",
    ),
    "healthConditionTitle": MessageLookupByLibrary.simpleMessage(
      "Tell us about your health condition so we can provide smarter monitoring.",
    ),
    "healthStatusIs": MessageLookupByLibrary.simpleMessage(
      "Your health status is ",
    ),
    "heartRate": MessageLookupByLibrary.simpleMessage("Heart Rate"),
    "height": MessageLookupByLibrary.simpleMessage("Height"),
    "heightCm": MessageLookupByLibrary.simpleMessage("Height (cm)"),
    "helpIsOnTheWay": MessageLookupByLibrary.simpleMessage(
      "Help Is On The Way",
    ),
    "helpSupport": MessageLookupByLibrary.simpleMessage("Help & Support"),
    "helpSupportAssistance": MessageLookupByLibrary.simpleMessage(
      "Need assistance? The ChairPal team is ready to help you.",
    ),
    "helpSupportContactInfo": MessageLookupByLibrary.simpleMessage(
      "Contact Info",
    ),
    "helpSupportMessage": MessageLookupByLibrary.simpleMessage("Message"),
    "helpSupportMessageHint": MessageLookupByLibrary.simpleMessage(
      "Type the message here..",
    ),
    "helpSupportSend": MessageLookupByLibrary.simpleMessage("Send"),
    "helpSupportSuccessDesc1": MessageLookupByLibrary.simpleMessage(
      "Thank you for contacting us. ",
    ),
    "helpSupportSuccessDesc2": MessageLookupByLibrary.simpleMessage("ChairPal"),
    "helpSupportSuccessDesc3": MessageLookupByLibrary.simpleMessage(
      " support team will get back to you.",
    ),
    "helpSupportSuccessMessage": MessageLookupByLibrary.simpleMessage(
      "Message sent successfully!",
    ),
    "hiUser": m9,
    "high": MessageLookupByLibrary.simpleMessage("High"),
    "highHeartRate": MessageLookupByLibrary.simpleMessage("High heart rate"),
    "history": MessageLookupByLibrary.simpleMessage("History"),
    "imageOfOrganization": MessageLookupByLibrary.simpleMessage(
      "Image of Organization",
    ),
    "joinedDate": m10,
    "kg": MessageLookupByLibrary.simpleMessage("kg"),
    "languageSelectionSubtitle": MessageLookupByLibrary.simpleMessage(
      "Select your preferred language below, this helps us serve you better.",
    ),
    "languageSelectionTitle": MessageLookupByLibrary.simpleMessage(
      "Choose Your Language",
    ),
    "languageSetting": MessageLookupByLibrary.simpleMessage("Language"),
    "lastUpdate": MessageLookupByLibrary.simpleMessage("Last update: "),
    "lastVisited": MessageLookupByLibrary.simpleMessage("Last Visited"),
    "letsGo": MessageLookupByLibrary.simpleMessage("Let\'s Go"),
    "liveHealthMonitoring": MessageLookupByLibrary.simpleMessage(
      "Live Health Monitoring",
    ),
    "loading": MessageLookupByLibrary.simpleMessage("Loading..."),
    "loadingAddress": MessageLookupByLibrary.simpleMessage(
      "Loading address...",
    ),
    "location": MessageLookupByLibrary.simpleMessage("Location"),
    "locationFetched": MessageLookupByLibrary.simpleMessage("Location fetched"),
    "locationNotSet": MessageLookupByLibrary.simpleMessage("Location not set"),
    "locationPermissionsDenied": MessageLookupByLibrary.simpleMessage(
      "Location permissions are denied.",
    ),
    "locationPermissionsPermanentlyDenied":
        MessageLookupByLibrary.simpleMessage(
          "Location permissions are permanently denied.",
        ),
    "locationServicesDisabled": MessageLookupByLibrary.simpleMessage(
      "Location services are disabled.",
    ),
    "logOut": MessageLookupByLibrary.simpleMessage("Log out"),
    "loggedInSuccess": MessageLookupByLibrary.simpleMessage(
      "Logged in successfully.",
    ),
    "login": MessageLookupByLibrary.simpleMessage("Login"),
    "loginScreenSubtitle": MessageLookupByLibrary.simpleMessage(
      "Access your account to control your wheelchair and enjoy community features.",
    ),
    "loginScreenTitle": MessageLookupByLibrary.simpleMessage(
      "Log in to Your Account",
    ),
    "loginSubtitle": MessageLookupByLibrary.simpleMessage("Log in to continue"),
    "loginTitle": MessageLookupByLibrary.simpleMessage("Welcome Back"),
    "logo": MessageLookupByLibrary.simpleMessage("Logo"),
    "logoutButton": MessageLookupByLibrary.simpleMessage("Log out"),
    "logoutDialogTitle": MessageLookupByLibrary.simpleMessage(
      "Oh! You are leaving. Are you sure?",
    ),
    "logoutOtherDevices": MessageLookupByLibrary.simpleMessage(
      "Logout other devices",
    ),
    "love": MessageLookupByLibrary.simpleMessage("Love"),
    "low": MessageLookupByLibrary.simpleMessage("Low"),
    "male": MessageLookupByLibrary.simpleMessage("Male"),
    "manageTrustedCompanions": MessageLookupByLibrary.simpleMessage(
      "Manage trusted companions to receive alerts and your location",
    ),
    "medicalConditionIds": MessageLookupByLibrary.simpleMessage(
      "Medical Condition IDs (comma separated)",
    ),
    "medicalConditionIdsHint": MessageLookupByLibrary.simpleMessage(
      "e.g. 1, 2",
    ),
    "medicalInfo": MessageLookupByLibrary.simpleMessage("Medical Info"),
    "medium": MessageLookupByLibrary.simpleMessage("Medium"),
    "messageAction": MessageLookupByLibrary.simpleMessage("Message"),
    "messageButton": MessageLookupByLibrary.simpleMessage("Message"),
    "movement": MessageLookupByLibrary.simpleMessage("Movement"),
    "myAccount": MessageLookupByLibrary.simpleMessage("My Account"),
    "myCommunity": MessageLookupByLibrary.simpleMessage("My Community"),
    "myFavorites": MessageLookupByLibrary.simpleMessage("My Favorites"),
    "myPosts": MessageLookupByLibrary.simpleMessage("My Posts"),
    "myProfile": MessageLookupByLibrary.simpleMessage("My Profile"),
    "name": MessageLookupByLibrary.simpleMessage("Full Name"),
    "nameHint": MessageLookupByLibrary.simpleMessage("John Doe"),
    "newChat": MessageLookupByLibrary.simpleMessage("New Chat"),
    "newCompanionRequest": MessageLookupByLibrary.simpleMessage(
      "New Companion Request",
    ),
    "newPassword": MessageLookupByLibrary.simpleMessage("New Password"),
    "next": MessageLookupByLibrary.simpleMessage("Next"),
    "noAiInsights": MessageLookupByLibrary.simpleMessage(
      "No AI insights generated yet. Waiting for more data...",
    ),
    "noBuildingsFound": MessageLookupByLibrary.simpleMessage(
      "No buildings found.",
    ),
    "noCancel": MessageLookupByLibrary.simpleMessage("No, Cancel"),
    "noCategoriesSubtitle": MessageLookupByLibrary.simpleMessage(
      "We couldn\'t find any categories at the moment.",
    ),
    "noCategoriesTitle": MessageLookupByLibrary.simpleMessage("No Categories"),
    "noChartData": MessageLookupByLibrary.simpleMessage(
      "No chart data available",
    ),
    "noChatsYet": MessageLookupByLibrary.simpleMessage("No Chats Yet"),
    "noCommentsYet": MessageLookupByLibrary.simpleMessage("No comments yet."),
    "noConnections": MessageLookupByLibrary.simpleMessage("No Connections"),
    "noData": MessageLookupByLibrary.simpleMessage("No data"),
    "noEmergencyCompanions": MessageLookupByLibrary.simpleMessage(
      "No Emergency Companions added",
    ),
    "noFavoritesSubtitle": MessageLookupByLibrary.simpleMessage(
      "Places you save as favorites will appear here for quick access",
    ),
    "noFavoritesYet": MessageLookupByLibrary.simpleMessage("No Favorites Yet"),
    "noFloorsFound": MessageLookupByLibrary.simpleMessage("No floors found."),
    "noNotificationsSubtitle": MessageLookupByLibrary.simpleMessage(
      "You don\'t have any notifications at the moment.\nAny alerts and updates will appear here",
    ),
    "noNotificationsTitle": MessageLookupByLibrary.simpleMessage(
      "No Notifications Yet",
    ),
    "noNotificationsYet": MessageLookupByLibrary.simpleMessage(
      "No notifications yet.",
    ),
    "noOrganizationsYet": MessageLookupByLibrary.simpleMessage(
      "No Organizations Yet",
    ),
    "noOrganizationsYetDesc": MessageLookupByLibrary.simpleMessage(
      "No organizations are available in this category right now. Be the first to add an organization to this category",
    ),
    "noPatientsAssigned": MessageLookupByLibrary.simpleMessage(
      "No patients assigned yet.",
    ),
    "noPlacesFound": MessageLookupByLibrary.simpleMessage("No places found."),
    "noPlacesFoundSubtitle": MessageLookupByLibrary.simpleMessage(
      "We couldn\'t find any popular places nearby.",
    ),
    "noPlacesFoundTitle": MessageLookupByLibrary.simpleMessage(
      "No Places Found",
    ),
    "noPostsYetDesc": MessageLookupByLibrary.simpleMessage(
      "There are no posts to display right now. Posts will appear here once they are shared",
    ),
    "noPostsYetTitle": MessageLookupByLibrary.simpleMessage("No Posts Yet"),
    "noRecentActivity": MessageLookupByLibrary.simpleMessage(
      "No recent activity.",
    ),
    "noRecentAlerts": MessageLookupByLibrary.simpleMessage("No recent alerts"),
    "noResults": MessageLookupByLibrary.simpleMessage("No results found"),
    "noSessionsFound": MessageLookupByLibrary.simpleMessage(
      "No sessions found.",
    ),
    "normal": MessageLookupByLibrary.simpleMessage("Normal"),
    "normalActivity": MessageLookupByLibrary.simpleMessage("Normal Activity"),
    "normalRangeHeartRate": MessageLookupByLibrary.simpleMessage(
      "Normal range: 60-100",
    ),
    "normalRangeTemperature": MessageLookupByLibrary.simpleMessage(
      "Normal range: 36.1-37.2",
    ),
    "notifications": MessageLookupByLibrary.simpleMessage("Notifications"),
    "onboardingDescription1": MessageLookupByLibrary.simpleMessage(
      "Your perfect companion for navigating places with your wheelchair. We help you find accessible locations and connect with a supportive community.",
    ),
    "onboardingDescription2": MessageLookupByLibrary.simpleMessage(
      "Discover wheelchair-friendly places near you. Read reviews from other users to make informed decisions.",
    ),
    "onboardingDescription3": MessageLookupByLibrary.simpleMessage(
      "Connect with others, share your experiences, and help build a more accessible world together.",
    ),
    "onboardingPage1Description": MessageLookupByLibrary.simpleMessage(
      "Smart features designed for users, companions, doctors, and organizations.",
    ),
    "onboardingPage1Title": MessageLookupByLibrary.simpleMessage(
      "Smart Mobility and Control for Every User",
    ),
    "onboardingPage2Description": MessageLookupByLibrary.simpleMessage(
      "Discover accessible places created by organizations, or create your own",
    ),
    "onboardingPage2Title": MessageLookupByLibrary.simpleMessage(
      "Explore and Create Accessible Places",
    ),
    "onboardingPage3Description": MessageLookupByLibrary.simpleMessage(
      "connected with users and companions in one supportive environment",
    ),
    "onboardingPage3Title": MessageLookupByLibrary.simpleMessage(
      "Connect with a Supportive Community",
    ),
    "onboardingPage4Description": MessageLookupByLibrary.simpleMessage(
      "Track health status, receive emergency alerts, and stay updated",
    ),
    "onboardingPage4Title": MessageLookupByLibrary.simpleMessage(
      "Stay Updated with Real Time Health Monitoring",
    ),
    "onboardingTitle1": MessageLookupByLibrary.simpleMessage(
      "Welcome to Wheelchair Buddy",
    ),
    "onboardingTitle2": MessageLookupByLibrary.simpleMessage(
      "Find Accessible Places",
    ),
    "onboardingTitle3": MessageLookupByLibrary.simpleMessage(
      "Join Our Community",
    ),
    "online": MessageLookupByLibrary.simpleMessage("Online"),
    "oops": MessageLookupByLibrary.simpleMessage("Oops!"),
    "orContinueWith": MessageLookupByLibrary.simpleMessage("Or continue with"),
    "organizationAddedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Organization added successfully!",
    ),
    "organizationDescriptionHint": MessageLookupByLibrary.simpleMessage(
      "Describe the organization...",
    ),
    "organizationName": MessageLookupByLibrary.simpleMessage(
      "Organization Name",
    ),
    "organizationNameHint": MessageLookupByLibrary.simpleMessage(
      "e.g. FCAI Faculty",
    ),
    "otpMustBe4Digits": MessageLookupByLibrary.simpleMessage(
      "OTP must be 6 digits",
    ),
    "otpSentSuccess": MessageLookupByLibrary.simpleMessage(
      "OTP sent to your email successfully.",
    ),
    "otpSentTo": MessageLookupByLibrary.simpleMessage(
      "We\'ve sent a 4-digit code to",
    ),
    "otpVerifiedSuccess": MessageLookupByLibrary.simpleMessage(
      "OTP verified successfully.",
    ),
    "overview": MessageLookupByLibrary.simpleMessage("Overview"),
    "password": MessageLookupByLibrary.simpleMessage("Password"),
    "passwordChangedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Password changed successfully.",
    ),
    "passwordHint": MessageLookupByLibrary.simpleMessage("••••••••"),
    "passwordMinLength": MessageLookupByLibrary.simpleMessage(
      "Password must be at least 6 characters",
    ),
    "passwordResetSuccess": MessageLookupByLibrary.simpleMessage(
      "Your password has been reset successfully.",
    ),
    "passwordTooShort": MessageLookupByLibrary.simpleMessage(
      "Password must be at least 6 characters",
    ),
    "passwordsDoNotMatch": MessageLookupByLibrary.simpleMessage(
      "Passwords do not match",
    ),
    "patientUsername": MessageLookupByLibrary.simpleMessage(
      "Patients Username",
    ),
    "patients": MessageLookupByLibrary.simpleMessage("Patients"),
    "pendingButton": MessageLookupByLibrary.simpleMessage("Pending"),
    "phoneNumber": MessageLookupByLibrary.simpleMessage("Phone Number"),
    "pickLocationTapHint": MessageLookupByLibrary.simpleMessage(
      "Tap on the map to select location",
    ),
    "pickLocationTitle": MessageLookupByLibrary.simpleMessage("Pick Location"),
    "placeAddedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Place added successfully!",
    ),
    "placeDescriptionHint": MessageLookupByLibrary.simpleMessage(
      "Describe the place...",
    ),
    "placeName": MessageLookupByLibrary.simpleMessage("Place Name"),
    "placeNameHint": MessageLookupByLibrary.simpleMessage(
      "e.g. Room 101, Cafeteria",
    ),
    "places": MessageLookupByLibrary.simpleMessage("Places"),
    "placesCount": m11,
    "pleaseAgreeToPolicy": MessageLookupByLibrary.simpleMessage(
      "Please agree to policies",
    ),
    "pleaseConfirmNewPassword": MessageLookupByLibrary.simpleMessage(
      "Please confirm your new password",
    ),
    "pleaseConfirmPassword": MessageLookupByLibrary.simpleMessage(
      "Please confirm your password",
    ),
    "pleaseConnectFromDoctorSearch": MessageLookupByLibrary.simpleMessage(
      "Please connect from Doctor Search",
    ),
    "pleaseEnterCategoryName": MessageLookupByLibrary.simpleMessage(
      "Please enter a category name",
    ),
    "pleaseEnterCurrentPassword": MessageLookupByLibrary.simpleMessage(
      "Please enter your current password",
    ),
    "pleaseEnterEmail": MessageLookupByLibrary.simpleMessage(
      "Please enter your email",
    ),
    "pleaseEnterName": MessageLookupByLibrary.simpleMessage(
      "Please enter your full name",
    ),
    "pleaseEnterNewPassword": MessageLookupByLibrary.simpleMessage(
      "Please enter new password",
    ),
    "pleaseEnterPassword": MessageLookupByLibrary.simpleMessage(
      "Please enter your password",
    ),
    "pleaseEnterPhoneNumber": MessageLookupByLibrary.simpleMessage(
      "Please enter your phone number",
    ),
    "pleaseEnterUsername": MessageLookupByLibrary.simpleMessage(
      "Please enter username",
    ),
    "pleaseEnterValidEmail": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid email",
    ),
    "pleaseEnterValidPhoneNumber": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid phone number",
    ),
    "pleaseEnterVerificationCode": MessageLookupByLibrary.simpleMessage(
      "Please enter the verification code",
    ),
    "pleaseEnterYourEmail": MessageLookupByLibrary.simpleMessage(
      "Please enter your email",
    ),
    "pleaseSelectBirthDate": MessageLookupByLibrary.simpleMessage(
      "Please select birth date",
    ),
    "pleaseSelectGender": MessageLookupByLibrary.simpleMessage(
      "Please select gender",
    ),
    "pleaseSelectRating": MessageLookupByLibrary.simpleMessage(
      "Please select a rating first.",
    ),
    "pleaseSetLocationFirst": MessageLookupByLibrary.simpleMessage(
      "Please set the location first.",
    ),
    "pleaseUploadLogo": MessageLookupByLibrary.simpleMessage(
      "Please upload a logo",
    ),
    "popularIn": m12,
    "popularPlaces": MessageLookupByLibrary.simpleMessage("Popular Places"),
    "postHidden": MessageLookupByLibrary.simpleMessage("Post hidden"),
    "postsTabTitle": MessageLookupByLibrary.simpleMessage("posts"),
    "pressSOS": MessageLookupByLibrary.simpleMessage(
      "Press the SOS button to send alerts and your location",
    ),
    "profileUpdatedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Profile updated successfully",
    ),
    "rateAppHint": MessageLookupByLibrary.simpleMessage(
      "Type your opinion (Optional).. ",
    ),
    "ratePlaceTitle": m13,
    "rateThisBuilding": MessageLookupByLibrary.simpleMessage(
      "Rate this building",
    ),
    "rateThisFloor": MessageLookupByLibrary.simpleMessage("Rate this floor"),
    "rateThisPlace": MessageLookupByLibrary.simpleMessage("Rate this place"),
    "readMore": MessageLookupByLibrary.simpleMessage("read more.."),
    "recentActivity": MessageLookupByLibrary.simpleMessage("Recent Activity"),
    "recentAlerts": MessageLookupByLibrary.simpleMessage("Recent Alerts"),
    "recommendedPosts": MessageLookupByLibrary.simpleMessage(
      "Recommended posts",
    ),
    "rememberMe": MessageLookupByLibrary.simpleMessage("Remember Me"),
    "requestAcceptedDesc": MessageLookupByLibrary.simpleMessage(
      "Welcome aboard! Your companion request has been accepted. You can now start monitoring and supporting the user.",
    ),
    "requestAcceptedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Request Accepted Successfully",
    ),
    "requestAlreadyHandled": MessageLookupByLibrary.simpleMessage(
      "This request has already been handled.",
    ),
    "requestRejectedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Request Rejected Successfully",
    ),
    "required": MessageLookupByLibrary.simpleMessage("Required"),
    "requiredField": MessageLookupByLibrary.simpleMessage("Required"),
    "resendCode": MessageLookupByLibrary.simpleMessage("Resend Code"),
    "resendCodeTimer": MessageLookupByLibrary.simpleMessage(
      "Resend code • 00:30",
    ),
    "resetPassword": MessageLookupByLibrary.simpleMessage("Reset Password"),
    "resetPasswordSubtitle": MessageLookupByLibrary.simpleMessage(
      "Enter your new password below.",
    ),
    "resetPasswordTitle": MessageLookupByLibrary.simpleMessage(
      "Reset Password",
    ),
    "retry": MessageLookupByLibrary.simpleMessage("Retry"),
    "reviewPostedSuccess": MessageLookupByLibrary.simpleMessage(
      "Review posted successfully!",
    ),
    "reviewsVisibilityNote": MessageLookupByLibrary.simpleMessage(
      "All users can see your reviews that contain your profile info",
    ),
    "roleCompanion": MessageLookupByLibrary.simpleMessage("Companion"),
    "roleDoctor": MessageLookupByLibrary.simpleMessage("Doctor"),
    "roleOrganization": MessageLookupByLibrary.simpleMessage("Organization"),
    "roleOrganizationDescription": MessageLookupByLibrary.simpleMessage(
      "Access your account to manage system features.",
    ),
    "roleSelectionSubtitle": MessageLookupByLibrary.simpleMessage(
      "Choose your role so we can customize the app experience for you.",
    ),
    "roleSelectionTitle": MessageLookupByLibrary.simpleMessage(
      "Choose how you\'ll use app",
    ),
    "roleUser": MessageLookupByLibrary.simpleMessage("User"),
    "roleUserDescription": MessageLookupByLibrary.simpleMessage(
      "Access your account to use available features.",
    ),
    "saySomethingAboutThis": MessageLookupByLibrary.simpleMessage(
      "Say something about this...",
    ),
    "search": MessageLookupByLibrary.simpleMessage("Search"),
    "searchHint": MessageLookupByLibrary.simpleMessage(
      "Enter address or place name",
    ),
    "searchLocation": MessageLookupByLibrary.simpleMessage(
      "Search for a location",
    ),
    "searchResults": MessageLookupByLibrary.simpleMessage("Search Results"),
    "selectLanguageFirst": MessageLookupByLibrary.simpleMessage(
      "Please select a language first",
    ),
    "sendOtp": MessageLookupByLibrary.simpleMessage("Send OTP"),
    "sendRequest": MessageLookupByLibrary.simpleMessage("Send Request"),
    "sensorsDisconnected": MessageLookupByLibrary.simpleMessage(
      "Sensors Disconnected",
    ),
    "sensorsDisconnectedDesc": MessageLookupByLibrary.simpleMessage(
      "Unable to retrieve live sensor readings right now. Please check the sensor connection and try again.",
    ),
    "share": MessageLookupByLibrary.simpleMessage("Share"),
    "shareNow": MessageLookupByLibrary.simpleMessage("Share Now"),
    "shares": MessageLookupByLibrary.simpleMessage("Shares"),
    "signUp": MessageLookupByLibrary.simpleMessage("Sign Up"),
    "signupSubtitle": MessageLookupByLibrary.simpleMessage(
      "Sign up to get started",
    ),
    "signupSubtitleOrg": MessageLookupByLibrary.simpleMessage(
      "Create a new account to manage users and track system activity.",
    ),
    "signupSubtitleUser": MessageLookupByLibrary.simpleMessage(
      "Create a new account to control wheelchair and discover accessible places.",
    ),
    "signupTitle": MessageLookupByLibrary.simpleMessage("Create Account"),
    "signupTitleOrg": MessageLookupByLibrary.simpleMessage(
      "Create New Account",
    ),
    "signupTitleUser": MessageLookupByLibrary.simpleMessage(
      "Create New Account",
    ),
    "skip": MessageLookupByLibrary.simpleMessage("Skip"),
    "somethingWentWrong": MessageLookupByLibrary.simpleMessage(
      "Something went wrong.",
    ),
    "sosButtonPressed": MessageLookupByLibrary.simpleMessage(
      "SOS button pressed",
    ),
    "stable": MessageLookupByLibrary.simpleMessage("stable"),
    "steps": MessageLookupByLibrary.simpleMessage("Steps"),
    "submitReview": MessageLookupByLibrary.simpleMessage("Submit Review"),
    "systemAlertsNotificationsWillAppearHere":
        MessageLookupByLibrary.simpleMessage(
          "System alerts and emergency notifications will appear here.",
        ),
    "targetUsername": MessageLookupByLibrary.simpleMessage("Target Username"),
    "temperature": MessageLookupByLibrary.simpleMessage("Temperature"),
    "today": MessageLookupByLibrary.simpleMessage("Today"),
    "today847am": MessageLookupByLibrary.simpleMessage("Today, 08:47 AM"),
    "totalPatients": MessageLookupByLibrary.simpleMessage("Total"),
    "totalPlaces": MessageLookupByLibrary.simpleMessage("Total Places"),
    "typeAMessage": MessageLookupByLibrary.simpleMessage("Type a message..."),
    "typeDescriptionHere": MessageLookupByLibrary.simpleMessage(
      "Type the description here..",
    ),
    "typeYourMessage": MessageLookupByLibrary.simpleMessage(
      "Type your message...",
    ),
    "unauthorizedToViewOtherUsers": MessageLookupByLibrary.simpleMessage(
      "Unauthorized to view other users.",
    ),
    "undo": MessageLookupByLibrary.simpleMessage("Undo"),
    "unknownDistance": MessageLookupByLibrary.simpleMessage("Unknown"),
    "unknownLocation": MessageLookupByLibrary.simpleMessage("Unknown Location"),
    "update": MessageLookupByLibrary.simpleMessage("Update"),
    "updatePassword": MessageLookupByLibrary.simpleMessage("Update Password"),
    "updateProfile": MessageLookupByLibrary.simpleMessage("Update Profile"),
    "uploadBuildingImage": MessageLookupByLibrary.simpleMessage(
      "Upload Building Main Image",
    ),
    "uploadFloorImage": MessageLookupByLibrary.simpleMessage(
      "Upload Floor Image (Optional)",
    ),
    "uploadOrganizationImage": MessageLookupByLibrary.simpleMessage(
      "Upload Organization Main Image",
    ),
    "uploadPlaceImage": MessageLookupByLibrary.simpleMessage(
      "Upload Place Image (Optional)",
    ),
    "username": MessageLookupByLibrary.simpleMessage("Username"),
    "verificationCodeMustBe4Digits": MessageLookupByLibrary.simpleMessage(
      "Verification code must be 6 digits",
    ),
    "verificationCodeResent": MessageLookupByLibrary.simpleMessage(
      "Verification code has been resent!",
    ),
    "verificationDescription": MessageLookupByLibrary.simpleMessage(
      "Please enter the 4-digit code sent to\\nyour email to verify your account.",
    ),
    "verificationSubtitle": MessageLookupByLibrary.simpleMessage(
      "Enter the code sent to",
    ),
    "verificationSuccessful": MessageLookupByLibrary.simpleMessage(
      "Verification Successful!",
    ),
    "verificationTitle": MessageLookupByLibrary.simpleMessage("Verification"),
    "verify": MessageLookupByLibrary.simpleMessage("Verify"),
    "verifyOtp": MessageLookupByLibrary.simpleMessage("Verify OTP"),
    "viewAll": MessageLookupByLibrary.simpleMessage("View all"),
    "viewLess": MessageLookupByLibrary.simpleMessage("View less.."),
    "vitalSignsNormal": MessageLookupByLibrary.simpleMessage(
      ". All vital signs are within normal ranges.",
    ),
    "wantsToFollow": MessageLookupByLibrary.simpleMessage(
      "wants to follow your status and receive emergency alerts.",
    ),
    "warningLabel": MessageLookupByLibrary.simpleMessage("Warning"),
    "weight": MessageLookupByLibrary.simpleMessage("Weight"),
    "weightKg": MessageLookupByLibrary.simpleMessage("Weight (kg)"),
    "whatsYourLocation": MessageLookupByLibrary.simpleMessage(
      "What\'s your location?",
    ),
    "writeAComment": MessageLookupByLibrary.simpleMessage("Write a comment..."),
    "yesDelete": MessageLookupByLibrary.simpleMessage("Yes, Delete"),
    "yesLogout": MessageLookupByLibrary.simpleMessage("Yes, Log out"),
    "yesterday615pm": MessageLookupByLibrary.simpleMessage(
      "Yesterday, 06:15 PM",
    ),
    "youDontHaveAnyConnectedPatients": MessageLookupByLibrary.simpleMessage(
      "You don\'t have any connected patients.\\nApproved patient connections will appear here.",
    ),
    "yourPlaces": MessageLookupByLibrary.simpleMessage("Your Places"),
  };
}
