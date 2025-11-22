import 'dart:io';

class ApiConstants {
  static String get baseUrl {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:5001';
    }
    return 'http://localhost:5001';
  }

  // Auth
  static const String login = '/api/users/login';
  static const String register = '/api/users/register';
  static const String profile = '/api/users/profile';
  static const String forgotPassword = '/api/users/forgot-password';
  static const String resetPassword = '/api/users/reset-password'; // Append /:token
  static const String verifyEmail = '/api/users/verify'; // Append /:token

  // Products
  static const String products = '/api/products';
  static const String productReviews = '/reviews'; // Used as suffix

  // Orders
  static const String orders = '/api/orders';
  static const String myOrders = '/api/orders/my-orders';

  // Stripe
  static const String createCheckoutSession = '/api/stripe/create-checkout-session';

  static String resolveImageUrl(String path) {
    if (path.startsWith('http')) {
      if (Platform.isAndroid && path.contains('localhost')) {
        return path.replaceAll('localhost', '10.0.2.2');
      }
      return path;
    }
    return '$baseUrl$path';
  }
}
