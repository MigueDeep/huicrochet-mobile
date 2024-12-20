import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:huicrochet_mobile/config/global_variables.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'notification_service.dart';
class WebSocketService {
  late StompClient _stompClient;
  final NotificationService notificationService;
  final Function? onPaymentSuccess; // Callback para manejar "Pago exitoso".

  WebSocketService({
    required this.notificationService,
    this.onPaymentSuccess,
  });

  void connect() {
    _stompClient = StompClient(
      config: StompConfig(
        url: 'http://$ip:8080/websocket',
        useSockJS: true,
        onConnect: _onConnect,
        onWebSocketError: (dynamic error) {
          print("Error en WebSocket: $error");
        },
      ),
    );
    _stompClient.activate();
  }

void _onConnect(StompFrame frame) {
  _stompClient.subscribe(
    destination: '/topic/notification',
    callback: (frame) async {
      final rawMessage = frame.body ?? "Sin mensaje recibido.";

      try {
        final Map<String, dynamic> data = jsonDecode(rawMessage);

        String? extractedMessage;
        if (data.containsKey('message')) {
          extractedMessage = data['message']; 
          
          if (data['message'] == "Pago exitoso") {
            final receiptUrl = data['receipt_url'];
            if (receiptUrl != null) {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setString('receiptUrl', receiptUrl);
            }
            if (onPaymentSuccess != null) {
              onPaymentSuccess!();
            }
          }
        } else if (data.containsKey('status')) {
          extractedMessage = data['status']; 
        }

        if (extractedMessage != null) {
          notificationService.showNotification(
            title: 'Huicrochet',
            body: extractedMessage,
          );
        } else {
          print("Mensaje no reconocido en la notificación.");
        }
      } catch (e) {
        print("Error al procesar la notificación: $e");
      }
    },
  );
}



  void disconnect() {
    _stompClient.deactivate();
  }
}
