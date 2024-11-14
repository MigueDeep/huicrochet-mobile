import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioClient {
  final Dio _dio;

  DioClient({required String baseUrl})
      : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 5),
            receiveTimeout: const Duration(seconds: 5),
          ),
        ) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final requiresToken = options.extra['requiresToken'] ?? false;

        if (requiresToken) {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('token');
          
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
        }

        return handler.next(options);
      },
      onResponse: (response, handler) {
        if (response.statusCode == 200) {
          handler.next(response);
        } else {
          handler.reject(
            DioException(
              requestOptions: response.requestOptions,
              response: response,
            ),
          );
        }
      },
      onError: (error, handler) {
        if (error.response != null) {
          switch (error.response?.statusCode) {
            case 400:
              print("Bad Request");
              break;
            case 401:
              print("Unauthorized");
              break;
            case 500:
              print("Internal Server Error");
              break;
            default:
              print("Unhandled Error: ${error.response?.statusCode}");
          }
        }
        handler.next(error);
      },
    ));
  }

  Dio get dio => _dio;

  Future<Response> get(String path, {bool requiresToken = false, Map<String, dynamic>? queryParameters}) {
    return _dio.get(
      path,
      queryParameters: queryParameters,
      options: Options(extra: {'requiresToken': requiresToken}),
    );
  }

  Future<Response> post(String path, {bool requiresToken = false, Map<String, dynamic>? data}) {
    return _dio.post(
      path,
      data: data,
      options: Options(extra: {'requiresToken': requiresToken}),
    );
  }
}
