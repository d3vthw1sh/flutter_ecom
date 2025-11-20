import 'package:dio/dio.dart';
import '../../core/constants.dart';
import 'api_service.dart';

class StripeService {
  final ApiService _apiService = ApiService();

  // Create Checkout Session
  Future<Map<String, dynamic>> createCheckoutSession(Map<String, dynamic> payload) async {
    try {
      final response = await _apiService.dio.post(
        ApiConstants.createCheckoutSession,
        data: payload,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
