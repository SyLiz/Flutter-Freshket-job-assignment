import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_job_assignment/config/app_config.dart';
import 'package:flutter_job_assignment/utils/dio_service.dart';

class CartApi {
  final Dio dio;
  CartApi({Dio? dioInstance}) : dio = dioInstance ?? DioService.getInstance(baseUrl: AppConfig.baseURL);

  // Checkout API
  Future<bool?> checkout(List<num> productIds) async {
    try {
      final response = await dio.post(
        '/orders/checkout',
        options: Options(
          headers: {
            'accept': '*/*',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'products': productIds,
        },
      );

      if (response.statusCode == 204) {
        // Handle success (e.g., show a success message or process the response data)
        if (kDebugMode) {
          print('Checkout successful');
        }
        return true;
      } else {
        throw Exception('Failed to checkout');
      }
    } catch (e) {
      throw Exception('Error during checkout: $e');
    }
  }
}
