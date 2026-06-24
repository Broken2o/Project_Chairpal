class ApiConstants {
  /// The static base URL.
  static const String baseUrl = 'https://chairpal-api.duckdns.org/api/';
  static const String loginEndpoint = 'login';
  static const String signupEndpoint = 'signup';
  static const String verifyEmailEndpoint = 'verify-otp';
  static const String resendVerificationCodeEndpoint = 'resend-otp';
  static const String forgotPasswordEndpoint = 'forget-password';
  static const String verifyOtpEndpoint = 'verify-otp';
  static const String resetPasswordEndpoint = 'reset-password';
  static const String refreshTokenEndpoint = 'refresh-token';
  static const String getCategoryEndpoint = 'categories/';
  static const String getCategoriesEndpoint = 'categories';
  static const String dashboardUserEndpoint = 'dashboard/user';
  static const String dashboardCompanionEndpoint = 'dashboard/companion';
  static const String dashboardDoctorEndpoint = 'dashboard/doctor';
  static const String dashboardAdminEndpoint = 'dashboard/org-admin';
  static const String connectionsEndpoint = 'connections';
  static const String getProfileEndpoint = 'profile';
  static const String getFavoritesEndpoint = 'profile/favorites';
  static const String supportEndpoint = 'support';
  static const String changePasswordEndpoint = 'profile/change-password';
  static const String logoutEndpoint = 'logout';
  static const String updateProfileEndpoint = 'profile/update';
  static const String deleteAccountEndpoint = 'profile';
  static const String updateLanguageEndpoint = 'profile/language';
  static const String medicalConditionsEndpoint = 'medical-conditions';
  static const String lastVisitedPlacesEndpoint = 'places/last-visited';

  // Wheelchairs (Patient Health)
  static String wheelchairSensorReadingsEndpoint(int wheelchairId) => 'wheelchairs/$wheelchairId/sensor-readings';
  static String wheelchairHealthEndpoint(int wheelchairId) => 'wheelchairs/$wheelchairId/health';

  // Community
  static const String postsEndpoint = 'posts';
  static String postDetailsEndpoint(int postId) => 'posts/$postId';
  static String postCommentsEndpoint(int postId) => 'posts/$postId/comments';
  static String hidePostEndpoint(int postId) => 'posts/$postId/hide';
  static String postLikeEndpoint(int postId) => 'posts/$postId/like';
  static String postLikesEndpoint(int postId) => 'posts/$postId/likes';
  static String commentEndpoint(int commentId) => 'comments/$commentId';
  static String commentLikeEndpoint(int commentId) => 'comments/$commentId/like';
  static String commentLikesEndpoint(int commentId) => 'comments/$commentId/likes';
  static String postShareEndpoint(int postId) => 'posts/$postId/share';
  
  // Geoapify
  static const String geoapifyBaseUrl = 'https://api.geoapify.com/v2';
  static const String geoapifyPlacesEndpoint = '/places';
  static const String geoapifyPlaceDetailsEndpoint = '/place-details';
  static const String geoapifyAutocompleteEndpoint = 'https://api.geoapify.com/v1/geocode/autocomplete';
  static const String geoapifyApiKey = '69d93e9bddbd4dfca6b4910aeed37123';
  
  // Headers
  static const String acceptHeader = 'Accept';
  static const String applicationJson = 'application/json';
}
