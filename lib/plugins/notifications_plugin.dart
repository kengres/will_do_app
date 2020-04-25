import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:will_do/models/notification_data.dart';

class NotificationPlugin with ChangeNotifier{
  FlutterLocalNotificationsPlugin _localNotificationsPlugin;
  NotificationAppLaunchDetails _notificationAppLaunchDetails;

  NotificationPlugin() {
    _initializeNotifications();
  }

  void _initializeNotifications () async {
    print("init notification plugin...");
    _localNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _notificationAppLaunchDetails = await _localNotificationsPlugin.getNotificationAppLaunchDetails();

    final initSettingsAndroid =  AndroidInitializationSettings("app_notification_image");
    final initSettingsIOS = IOSInitializationSettings();
    final initSettings = InitializationSettings(initSettingsAndroid, initSettingsIOS);

    _localNotificationsPlugin.initialize(initSettings, onSelectNotification: onSelectNotification);

    // notifyListeners();
  }

  FlutterLocalNotificationsPlugin get flutterLocalNotificationsPlugin => _localNotificationsPlugin;
  NotificationAppLaunchDetails get notificationAppLaunchDetails => _notificationAppLaunchDetails;

  Future onSelectNotification (String payload) async {
    if (payload != null) {
      print("Notification payload: $payload");
    }
  }

  Future<void> debugNotification() async {
    var scheduledDateTime = DateTime.now().add(Duration(seconds: 5));
    var vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'Second channel',
        'Channel renamed',
        'A channel created from old fashion copy paste',
        icon: 'app_notification_image',
        //sound: RawResourceAndroidNotificationSound('slow_spring_board'),
        //largeIcon: DrawableResourceAndroidBitmap('@drawable-hdpi/app_notification_image'),
        vibrationPattern: vibrationPattern,
        enableLights: true,
        color: Color.fromARGB(255, 255, 0, 0),
        ledColor: Color.fromARGB(255, 255, 0, 0),
        ledOnMs: 1000,
        ledOffMs: 500);
    var iOSPlatformChannelSpecifics =
        IOSNotificationDetails(sound: 'slow_spring_board.aiff');
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        0,
        'scheduled title',
        'scheduled body',
        scheduledDateTime,
        platformChannelSpecifics);
  }

  Future<void> showDailyAtTime (Time time, int id, String title, String description) async {
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'show weekly channel id',
      'show weekly channel name',
      'show weekly description',
    );
    final iOSPlatformChannelSpecifics = IOSNotificationDetails();
    final platformChannelSpecifics = NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await _localNotificationsPlugin.showDailyAtTime(id, title, description, time, platformChannelSpecifics);
  }

  Future<void> showNotification (int id, String title, String description) async {
    final androidChanelSpecifics = AndroidNotificationDetails(
      "Test ID",
      "Test Channel",
      "Notification for testing purposes",
    );

    final iosChanelSpecifics = IOSNotificationDetails();
    final platformChanelSpecifics = NotificationDetails(androidChanelSpecifics, iosChanelSpecifics);
    await _localNotificationsPlugin.show(id, title, description, platformChanelSpecifics);
  }

  Future<void> scheduleNotification (DateTime date, int id, String title, String description) async {
    print("scheduling notification");
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'scheduled_notification',
      'Task Notification',
      'Task notifications shown as scheduled in the calendar.',
      enableLights: true,
      color: Color.fromARGB(255, 206, 122, 206),
      ledColor: Color.fromARGB(255, 206, 122, 206),
      ledOnMs: 1000,
      ledOffMs: 500
    );
    final iOSPlatformChannelSpecifics = IOSNotificationDetails();
    final platformChannelSpecifics = NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    try {
      await _localNotificationsPlugin.schedule(id, title, description, date, platformChannelSpecifics);
    } catch (e) {
      print("[Nfc Plgin] unable to schrdule notification: ${e.toString()}");
    }
  }

  Future<List<PendingNotificationRequest>> getScheduledNotifications () async {
    return await _localNotificationsPlugin.pendingNotificationRequests();
  }

  Future<void> cancelNotification (int id) async {
    await _localNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications () async {
    await _localNotificationsPlugin.cancelAll();
  }

  Future<void> scheduleAllNotifications(List<NotificationData> notifications) async {
    for (final notification in notifications) {
      await showDailyAtTime(
        Time(notification.hour, notification.minute),
        notification.notificationId,
        notification.title,
        notification.description,
      );
    }
  }
}