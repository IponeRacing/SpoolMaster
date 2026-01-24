/// Configuration de l'API backend
class ApiConfig {
  static const String baseUrl = 'https://api.engageengine.ch';

  // Endpoints Auth
  static const String loginWithApple = '/auth/apple';
  static const String loginWithGoogle = '/auth/google';
  static const String refreshToken = '/auth/refresh';

  // Endpoints User
  static const String getUserProfile = '/user/profile';
  static const String updateUserProfile = '/user/profile';
  static const String logout = '/user/logout';
  static const String deleteAccount = '/user/account';

  // Endpoints Spools
  static const String getSpools = '/spools';
  static String getSpool(String id) => '/spools/$id';
  static const String createSpool = '/spools';
  static String updateSpool(String id) => '/spools/$id';
  static String deleteSpool(String id) => '/spools/$id';

  // Endpoints Sync
  static const String syncPush = '/sync/push';
  static const String syncPull = '/sync/pull';
  static const String syncHistory = '/sync/history';

  // Endpoints Shopping List
  static const String shoppingListPush = '/shopping-list/push';
  static const String shoppingListPull = '/shopping-list/pull';
  static String deleteShoppingListItem(String id) => '/shopping-list/$id';
  static String toggleShoppingListOrdered(String id) => '/shopping-list/$id/toggle-ordered';

  // Endpoints Analytics
  static const String logEvent = '/analytics/event';
  static const String getScans = '/analytics/scans';
  static const String getStats = '/analytics/stats';

  // Endpoints Subscriptions
  static const String verifySubscription = '/subscriptions/verify';
  static const String getSubscriptionStatus = '/subscriptions/status';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
