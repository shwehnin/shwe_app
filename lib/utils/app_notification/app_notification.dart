import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class AppNotification {
  static const String channelId = 'high_importance_channel';
  static const String channelName = 'High Importance Notifications';

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static void Function(String? payload)? onNotificationTap;

  static Future<void> initialize({
    void Function(String? payload)? onTap,
  }) async {
    onNotificationTap = onTap;

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@drawable/ic_notification');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );

    await _plugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        debugPrint('Notification tapped: ${response.payload}');
        onNotificationTap?.call(response.payload);
      },
      onDidReceiveBackgroundNotificationResponse: onBackgroundNotificationTap,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  @pragma('vm:entry-point')
  static void onBackgroundNotificationTap(NotificationResponse response) {
    debugPrint('Background notification tapped: ${response.payload}');
  }

  static Future<NotificationResponse?> getInitialNotification() async {
    final details = await _plugin.getNotificationAppLaunchDetails();
    if (details?.didNotificationLaunchApp == true) {
      return details?.notificationResponse;
    }
    return null;
  }

  static Future<void> show({
    int? id,
    required String title,
    required String body,
    String? payload,
    String? imageUrl,
  }) async {
    final String? validImageUrl = (imageUrl != null && imageUrl.isNotEmpty)
        ? imageUrl
        : null;

    final BigPictureStyleInformation? bigPictureStyle = validImageUrl != null
        ? BigPictureStyleInformation(
            FilePathAndroidBitmap(validImageUrl),
            contentTitle: title,
            summaryText: body,
          )
        : null;

    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          channelId,
          channelName,
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
          largeIcon: const DrawableResourceAndroidBitmap(
            '@mipmap/launcher_icon',
          ),

          styleInformation: bigPictureStyle ?? BigTextStyleInformation(body),
        );

    await _plugin.show(
      id: id ?? DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title: title,
      body: body,
      notificationDetails: NotificationDetails(android: androidDetails),
      payload: payload,
    );
  }
}
