import 'package:dio/dio.dart';

import '../models/item_model.dart';

class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://jsonplaceholder.typicode.com',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );
  }

  Future<List<ItemModel>> getItems() async {
    try {
      final response = await _dio.get('/posts');

      final List<dynamic> data = response.data as List<dynamic>;

      return data
          .map((json) => ItemModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      throw Exception('Something went wrong: $e');
    }
  }

  String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Request timed out. Please try again.';

      case DioExceptionType.connectionError:
        return 'No internet connection. Please check your network.';

      case DioExceptionType.badResponse:
        return 'Server error: ${error.response?.statusCode}';

      case DioExceptionType.cancel:
        return 'Request was cancelled.';

      default:
        return 'Unable to connect to server. Please try again.';
    }
  }
}
