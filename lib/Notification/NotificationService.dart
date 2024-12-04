import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart'
    as tz; // Correct timezone initialization
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  // Singleton instance
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;

  // FlutterLocalNotificationsPlugin instance
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Private constructor
  NotificationService._internal();

  // Initialize the notification service
  Future<void> initialize() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings iOSInitializationSettings =
        DarwinInitializationSettings(); // Fixed iOS initialization

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: iOSInitializationSettings, // Fixed here as well
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Initialize the time zone database
    tz.initializeTimeZones(); // Fixed initializeTimeZones call
  }

  // Schedule a notification after a delay (in seconds)
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required int delayInSeconds,
  }) async {
    // Convert DateTime to TZDateTime
    final now =
        tz.TZDateTime.now(tz.local); // Get the current time in local timezone
    final scheduledTime =
        now.add(Duration(seconds: delayInSeconds)); // Add delay

    // Define the Android notification details
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'default_channel',
      'Default Channel',
      channelDescription: 'This is the default channel for notifications.',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    // Schedule the notification
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledTime,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> showNotification(
      {required int id, required String title, required String body}) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'default_channel',
      'Default Channel',
      channelDescription: 'This is the default channel for notifications.',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await _flutterLocalNotificationsPlugin.show(
        id, title, body, notificationDetails);
  }
}
