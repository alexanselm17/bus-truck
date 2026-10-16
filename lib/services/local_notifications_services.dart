import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:school_tracker/service_locator.dart';
import 'package:school_tracker/services/NavigationService.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static initialize(BuildContext context) async {
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings("@drawable/ic_launcher"),
    );

    await _notificationsPlugin.initialize(initializationSettings,
        onDidReceiveBackgroundNotificationResponse:
            (NotificationResponse details) {
      var payloadData = jsonDecode(details.payload!);
      print("payload ${payloadData.data}");
      locator<NavigationService>().navigateTo('payment');
    }, onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {
      var payloadData = jsonDecode(notificationResponse.payload!);
      print("payload $payloadData");
      locator<NavigationService>().navigateTo('on-route');
    });
  }

  static void display(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      NotificationDetails notificationDetails = const NotificationDetails(
          android: AndroidNotificationDetails(
        "high_importance_channel",
        "bus-truck",
        importance: Importance.max,
        priority: Priority.high,
        icon: '@drawable/ic_launcher',
      ));

      await _notificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: jsonEncode(message.toMap()),
      );
    } on Exception catch (e) {
      print(e);
    }
  }
}
