import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  LocalNotificationService();
  final _localNotificationService = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const androidInitialize =
        AndroidInitializationSettings('@drawable/app_icon');

    DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    final initializationSettings = InitializationSettings(
        android: androidInitialize, iOS: initializationSettingsDarwin);

    await _localNotificationService.initialize(initializationSettings);
  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {
    print("id $id");
  }

  Future<NotificationDetails> _notificationDetails() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('very_unique_channel_id', 'channel_name',
            playSound: true,
            importance: Importance.max,
            priority: Priority.max);
    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails();
    return const NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iosNotificationDetails);
  }

  Future<void> showNotification(
      {int id = 0, required String title, required String body}) async {
    final details = await _notificationDetails();
    await _localNotificationService.show(id, title, body, details);
  }
}
