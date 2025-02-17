import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioService {
  // Private static Dio instance
  static Dio? _dio;
  static bool _isInitialized = false;

  // Private constructor to prevent instantiation
  DioService._();

  // Public static method to get the Dio instance with a configurable base URL (initialized only once)
  static Dio getInstance({String? baseUrl}) {
    // Assert if Dio is not initialized yet
    assert(
      _isInitialized || baseUrl != null,
      'DioSingleton is not initialized. Provide a baseUrl for initialization.',
    );

    // Initialize Dio only once with the provided base URL
    if (!_isInitialized && baseUrl != null) {
      _dio = Dio(BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: Duration(seconds: 5),
        receiveTimeout: Duration(seconds: 3),
      ));
      _isInitialized = true;

      if (kDebugMode) {
        _dio?.interceptors.add(PrettyDioLogger());
      }
    }

    // If Dio is not initialized and no baseUrl is provided, throw an error
    if (_dio == null) {
      throw Exception('DioSingleton is not initialized. Call getInstance with a baseUrl first.');
    }

    return _dio!;
  }
}
