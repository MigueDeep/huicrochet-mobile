import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'error_state.dart';

class DioClient {
  final Dio _dio;

  DioClient(BuildContext context)
      : _dio = Dio(
          BaseOptions(
            baseUrl: 'http://192.168.107.138:8080/api-crochet',
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            headers: {
              'Content-Type': 'application/json',
            },
          ),
        ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Recupera el token de SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('token') ?? '';

          // Si el token no está vacío, agrégalo a los headers
          if (token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          print('Enviando petición a: ${options.path}');
          print('Datos de la solicitud: ${options.data}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('Respuesta recibida: ${response.data}');
          if (response.statusCode == 200) {
            print('Solicitud exitosa.');
          } else {
            print('Código de estado inesperado: ${response.statusCode}');
          }
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          final errorState = Provider.of<ErrorState>(context, listen: false);
          print('Error en la petición: ${e.message}');
          if (e.response != null) {
            print('Código de estado de error: ${e.response?.statusCode}');
            print('Detalles del error: ${e.response?.data}');
            if (e.response?.statusCode == 400) {
              errorState
                  .setError(e.response?.data['message'] ?? 'Error desconocido');
            }
          } else {
            print('Error sin respuesta del servidor');
          }
          return handler.next(e);
        },
      ),
    );
  }

  Dio get dio => _dio;
}
