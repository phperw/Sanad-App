class ApiConstants {
  static const String baseURL = 'https://backend-athar1.vercel.app/api';
  static const String endpointLogin = '/auth/login';
  static const String endpointRegister = '/auth/register';
  static const String endpointRefresh = '/auth/refresh';
  static const String endpointHome = '/home';
  static const String endpointProfile = '/auth/me';
  static const String endpointCreateCommunityPost = '/community/posts';
  static const String endpointCommunityFeed = '/community/feed';
  static const String endpointGetallProfiles = '/profile';
  static const String endpointLeaderboard = '/profile/leaderboard';

  static const String endpointWeeklyLeaderboard =
      '$endpointLeaderboard?period=weekly';

  static const String endpointMonthlyLeaderboard =
      '$endpointLeaderboard?period=monthly';

  static const String endpointAllTimeLeaderboard =
      '$endpointLeaderboard?period=all';

  static const String endpointSosSend = '/sos-requests';
  static const String endpointSosCancel = '/sos-requests/active/cancel';
}

class ApiErrors {
  static const String badRequestError = "badRequestError";
  static const String noContent = "noContent";
  static const String forbiddenError = "forbiddenError";
  static const String unauthorizedError = "unauthorizedError";
  static const String notFoundError = "notFoundError";
  static const String conflictError = "conflictError";
  static const String internalServerError = "internalServerError";
  static const String unknownError = "unknownError";
  static const String timeoutError = "timeoutError";
  static const String defaultError = "defaultError";
  static const String cacheError = "cacheError";
  static const String noInternetError = "noInternetError";
  static const String loadingMessage = "loading_message";
  static const String retryAgainMessage = "retry_again_message";
  static const String ok = "Ok";
}