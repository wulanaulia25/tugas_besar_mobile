import 'package:dio/dio.dart';
import '../models/product_model.dart';
import '../models/order_model.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://fakestoreapi.com',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  // ================= GET PRODUCTS =================
  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await _dio.get('/products');
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is List) {
          return data.map((json) => ProductModel.fromJson(json)).toList();
        } else {
          throw Exception('Invalid response format for products');
        }
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  // ================= GET PRODUCT BY ID =================
  Future<ProductModel> getProductById(int id) async {
    try {
      final response = await _dio.get('/products/$id');
      if (response.statusCode == 200) {
        return ProductModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load product');
      }
    } catch (e) {
      throw Exception('Error fetching product: $e');
    }
  }

  // ================= GET CATEGORIES =================
  Future<List<String>> getCategories() async {
    try {
      final response = await _dio.get('/products/categories');
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is List) {
          return data.map((e) => e.toString()).toList();
        } else {
          throw Exception('Invalid response format for categories');
        }
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  // ================= CREATE ORDER =================
  Future<OrderModel> createOrder(OrderModel order) async {
    try {
      final response = await _dio.post('/carts', data: order.toJson());
      if (response.statusCode == 200 || response.statusCode == 201) {
        return OrderModel.fromJson(response.data);
      } else {
        throw Exception('Failed to create order');
      }
    } catch (e) {
      throw Exception('Error creating order: $e');
    }
  }

  // ================= GET ORDERS BY USER =================
  Future<List<OrderModel>> getOrders(String userId) async {
    try {
      final response = await _dio.get('/carts/user/$userId');
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is List) {
          return data.map((json) => OrderModel.fromJson(json)).toList();
        } else {
          throw Exception('Invalid response format for orders');
        }
      } else {
        throw Exception('Failed to load orders');
      }
    } catch (e) {
      throw Exception('Error fetching orders: $e');
    }
  }
}
