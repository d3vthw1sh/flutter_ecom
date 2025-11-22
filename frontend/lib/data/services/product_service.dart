import 'package:dio/dio.dart';
import '../../core/constants.dart';
import '../models/product.dart';
import 'api_service.dart';

class ProductService {
  final ApiService _apiService = ApiService();

  // Get all products
  Future<List<Product>> getProducts() async {
    try {
      final response = await _apiService.dio.get(ApiConstants.products);
      
      List<dynamic> data;
      if (response.data is Map<String, dynamic> && response.data.containsKey('products')) {
        data = response.data['products'];
      } else if (response.data is List) {
        data = response.data;
      } else {
        data = [];
      }
      
      return data.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Get single product
  Future<Product> getProduct(String id) async {
    try {
      final response = await _apiService.dio.get('${ApiConstants.products}/$id');
      return Product.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  // Add product
  Future<Product> addProduct(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.dio.post(
        ApiConstants.products,
        data: data,
      );
      return Product.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  // Update product
  Future<Product> updateProduct(String id, Map<String, dynamic> data) async {
    try {
      final response = await _apiService.dio.put(
        '${ApiConstants.products}/$id',
        data: data,
      );
      return Product.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  // Delete product
  Future<void> deleteProduct(String id) async {
    try {
      await _apiService.dio.delete('${ApiConstants.products}/$id');
    } catch (e) {
      rethrow;
    }
  }

  // Add review
  Future<void> addReview(String id, Map<String, dynamic> data) async {
    try {
      await _apiService.dio.post(
        '${ApiConstants.products}/$id${ApiConstants.productReviews}',
        data: data,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Remove review
  Future<void> removeReview(String productId, String reviewId) async {
    try {
      await _apiService.dio.delete(
        '${ApiConstants.products}/$productId${ApiConstants.productReviews}/$reviewId',
      );
    } catch (e) {
      rethrow;
    }
  }
}
