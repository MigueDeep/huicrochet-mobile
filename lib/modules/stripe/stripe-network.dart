import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:huicrochet_mobile/config/dio_client.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> stripeNetwork(BuildContext context, String userId) async {
  final dioClient = DioClient(context);
  late BuildContext? loadingDialogContext;

  // Mostrar diálogo de carga
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      loadingDialogContext = context;
      return AlertDialog(
        title: Text('Paga con Stripe'),
        content: Text('Redirigiendo a la pantalla de pago con Stripe...'),
      );
    },
  );

  try {
    final response = await dioClient.dio.post(
      '/stripe/checkout/hosted',
      queryParameters: {'userId': userId},
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.toString());

      if (jsonData['error'] == false) {
        String? checkoutUrl = jsonData['data'];

        if (checkoutUrl != null) {
          // Imprimir la URL original para depuración
          print('URL original recibida: $checkoutUrl');

          // Intentar abrir la URL completa, incluyendo el fragmento hash
          final Uri? uri = Uri.tryParse(checkoutUrl);

          if (uri != null) {
            try {
              // Cerrar el diálogo de "Redirigiendo"
              if (loadingDialogContext != null) {
                Navigator.of(loadingDialogContext!, rootNavigator: true).pop();
              }

              // Configurar un listener para cuando la URL se cierre
              final urlLaunchResult = await launchUrl(
                uri,
                mode: LaunchMode.externalApplication,
                webViewConfiguration: const WebViewConfiguration(
                  enableJavaScript: true,
                ),
              );

            
            } catch (e) {
              print('Error al abrir URL: $e');
              _showErrorDialog(context, 'Error al abrir el enlace de pago');
            }
          } else {
            // Cerrar el diálogo de "Redirigiendo" en caso de error
            if (loadingDialogContext != null) {
              Navigator.of(loadingDialogContext!, rootNavigator: true).pop();
            }
            _showErrorDialog(context, 'Enlace de pago inválido');
          }
        } else {
          // Cerrar el diálogo de "Redirigiendo" en caso de error
          if (loadingDialogContext != null) {
            Navigator.of(loadingDialogContext!, rootNavigator: true).pop();
          }
          _showErrorDialog(context, 'No hay enlace de pago disponible');
        }
      } else {
        // Cerrar el diálogo de "Redirigiendo" en caso de error
        if (loadingDialogContext != null) {
          Navigator.of(loadingDialogContext!, rootNavigator: true).pop();
        }
        _showErrorDialog(context, jsonData['message'] ?? 'Error en el pago');
      }
    } else {
      // Cerrar el diálogo de "Redirigiendo" en caso de error
      if (loadingDialogContext != null) {
        Navigator.of(loadingDialogContext!, rootNavigator: true).pop();
      }
      _showErrorDialog(context, 'Falló la solicitud de pago');
    }
  } catch (e) {
    // Cerrar el diálogo de "Redirigiendo" si hay un error
    if (loadingDialogContext != null) {
      Navigator.of(loadingDialogContext!, rootNavigator: true).pop();
    }
    
    print('Error en la solicitud de Stripe: $e');
    _showErrorDialog(context, 'Ocurrió un error de red');
  }
}
// Los demás métodos permanecen iguales
void _showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Error'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('OK'),
        ),
      ],
    ),
  );
}
