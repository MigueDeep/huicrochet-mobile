import 'dart:io';
import 'dart:ui';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initializeNotification() async {
    // Configuración de inicialización para Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('flutter_logo');

    // Configuración de inicialización para iOS
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Configuración general de inicialización
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    // Inicializar el plugin de notificaciones
    await notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
        if (notificationResponse.payload != null) {
          print("Payload recibido: ${notificationResponse.payload}");
        }
      },
    );

    // Crear un canal de notificaciones (Android 8.0+)
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'ACT_123',
      'Actualizaciones de envíos',
      description: 'Este es el canal de notificaciones de alta prioridad.',
      importance: Importance.max,
    );

    // Configuración específica de la plataforma Android
    await notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // Solicitar permiso de notificaciones en Android 13+
    await _requestNotificationPermission();
  }

  // Solicitar permiso para notificaciones en Android 13 o superior
  Future<void> _requestNotificationPermission() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt >= 33) {
        final permissionStatus = await Permission.notification.request();
        if (permissionStatus != PermissionStatus.granted) {
          print('Permiso de notificación no otorgado.');
        }
      }
    }
  }

  // Configuración de los detalles de la notificación
  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        "ACT_123", // ID del canal
        "Actualizaciones de envíos", // Nombre del canal
        importance: Importance.max,
        priority: Priority.high,
        icon: 'flutter_logo',
        showWhen: true,
        color: Color(0xFFCF5297),
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  // Mostrar una notificación
  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    try {
      await notificationsPlugin.show(
        id,
        title,
        body,
        notificationDetails(),
        payload: payload,
      );
    } catch (e) {
      print("Error al mostrar notificación: $e");
    }
  }
}
