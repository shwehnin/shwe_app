import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_api_availability/google_api_availability.dart';
import '../const.dart';
import '../global.dart';
import '../shared_pref.dart';
import '../../firebase_options.dart';
import 'app_notification.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // ✅ show လုပ်တာ မလိုဘူး — Firebase က system notification auto ပြပြီး
  debugPrint("Background message received: ${message.messageId}");
}

class FCM {
  static final _messaging = FirebaseMessaging.instance;
  static bool _isInitialized = false;

  static Future<void> initialize({
    void Function(String? payload)? onNotificationTap,
  }) async {
    if (_isInitialized) return;

    try {
      GooglePlayServicesAvailability availability = await GoogleApiAvailability
          .instance
          .checkGooglePlayServicesAvailability();

      if (availability != GooglePlayServicesAvailability.success) return;

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      await _messaging.setForegroundNotificationPresentationOptions(
        alert: false,
        badge: true,
        sound: false,
      );

      // ✅ AppNotification initialize + tap handler
      await AppNotification.initialize(onTap: onNotificationTap);

      _isInitialized = true;
    } catch (e) {
      debugPrint("FCM init error: $e");
    }
  }

  static Future<void> config({String? userid}) async {
    try {
      var notiStatus = await SharedPref.getData(key: Const.notiStatus);
      print("##########|||||||||||||||||||||||||");
      print("##########|||||||||||||||||||||||||");
      print(notiStatus);
      print("##########|||||||||||||||||||||||||");
      print("##########|||||||||||||||||||||||||");
      if (notiStatus != "off") {
        Global.notiStatus.value = true;
        print("-------------------------------");
        print("-------------------------------");
        print("trying..........");
        print("-------------------------------");
        print("-------------------------------");
        await _messaging.subscribeToTopic(Const.appNoti);
        print("#############################");
        print("#############################");
        print(Const.appNoti);
        print("#############################");
        print("#############################");
      } else {
        Global.notiStatus.value = false;
      }

      // ✅ Foreground
      FirebaseMessaging.onMessage.listen((message) {
        debugPrint("======= onMessage =======");
        debugPrint("notification: ${message.notification?.title}");
        debugPrint("data: ${message.data}");

        final notification = message.notification;
        if (notification != null) {
          AppNotification.show(
            id: message.messageId?.hashCode,
            title: notification.title ?? '',
            body: notification.body ?? '',
            imageUrl: message.data['image'],
            payload: message.data.toString(),
          );
        }
      });
      // ✅ Background tap
      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        debugPrint("Background tap: ${message.data}");
        AppNotification.onNotificationTap?.call(message.data.toString());
      });

      // ✅ Killed state tap
      final initial = await _messaging.getInitialMessage();
      if (initial != null) {
        debugPrint("Killed state tap: ${initial.data}");
        AppNotification.onNotificationTap?.call(initial.data.toString());
      }

      // ✅ Killed state — local notification tap
      final localInitial = await AppNotification.getInitialNotification();
      if (localInitial != null) {
        AppNotification.onNotificationTap?.call(localInitial.payload);
      }
    } catch (e) {
      debugPrint("FCM config error: $e");
    }
  }
}
