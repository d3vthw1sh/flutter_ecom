class ApiConstants {
  static const String baseUrl = 'http://localhost:5000';

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
}
