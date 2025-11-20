import 'package:dio/dio.dart';
import '../../core/constants.dart';
import '../models/order.dart';
import 'api_service.dart';

class OrderService {
  final ApiService _apiService = ApiService();

  // Create Order
  Future<Order> createOrder(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.dio.post(
        ApiConstants.orders,
        data: data,
      );
      return Order.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  // Get My Orders
  Future<List<Order>> getMyOrders() async {
    try {
      final response = await _apiService.dio.get(ApiConstants.myOrders);
      final List<dynamic> data = response.data;
      return data.map((json) => Order.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Get Order by ID
  Future<Order> getOrderById(String id) async {
    try {
      final response = await _apiService.dio.get('${ApiConstants.orders}/$id');
      return Order.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
