import 'package:dio/dio.dart';
import 'package:flutter_job_assignment/config/app_config.dart';
import 'package:flutter_job_assignment/utils/dio_service.dart';

import '../model/products.dart';

class ProductApi {
  final Dio dio;
  ProductApi({Dio? dioInstance}) : dio = dioInstance ?? DioService.getInstance(baseUrl: AppConfig.baseURL);

  // Fetch a list of products with pagination support
  Future<Products> fetchProducts({int limit = 20, String? cursor}) async {
    try {
      final response = await dio.get('/products', queryParameters: {
        'limit': limit,
        'cursor': cursor,
      });

      if (response.statusCode == 200) {
        return Products.fromJson(response.data);
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  // Fetch a list of recommended products
  Future<List<Product>> fetchRecommendedProducts() async {
    try {
      final response = await dio.get('/recommended-products');

      if (response.statusCode == 200) {
        List<Product> products = (response.data as List).map((productJson) => Product.fromJson(productJson)).toList();
        return products;
      } else {
        throw Exception('Failed to load recommended products');
      }
    } catch (e) {
      throw Exception('Error fetching recommended products: $e');
    }
  }
}
