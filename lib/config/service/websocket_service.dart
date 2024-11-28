import 'package:huicrochet_mobile/config/global_variables.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'notification_service.dart';

class WebSocketService {
  late StompClient _stompClient;
  final NotificationService notificationService;

  WebSocketService({required this.notificationService});

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
    print("Conectado al servidor WebSocket");
    _stompClient.subscribe(
      destination: '/topic/notification',
      callback: (frame) {
        final message = frame.body ?? "Sin mensaje recibido.";
        notificationService.showNotification(
          title: '¡Tu orden!',
          body: message,
        );
        print("Notificación recibida: $message");
      },
    );
  }

  void disconnect() {
    _stompClient.deactivate();
  }
}
