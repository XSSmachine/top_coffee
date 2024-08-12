import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admin/firebase_admin.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import 'package:team_coffee/controllers/event_controller.dart';
import '../base/show_custom_snackbar.dart';
import '../routes/route_helper.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis/servicecontrol/v1.dart' as servicecontrol;

class NotificationController extends GetxController {
  static const String TAG = "NotificationController";
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void onInit() {
    super.onInit();
    initializeNotifications();
    setupInteractedMessage();
  }

  void initializeNotifications() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  void onDidReceiveNotificationResponse(NotificationResponse response) async {
    final String? payload = response.payload;
    if (payload != null) {
      print('notification payload: $payload');
      // Handle notification tap here
    }
  }

  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
  }

  void _handleMessage(RemoteMessage message) async {
    var type = message.data['type'];
    var id = message.data['id'];
    if (type == "event") {
      Get.find<EventController>().getEventById(id);
      await Future.delayed(const Duration(seconds: 1));
      Get.toNamed(RouteHelper.getEventDetail(id, "home", null));
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    showLocalNotification(message);
    showCustomSnackBar(
      message.notification?.body ?? '',
      title: message.notification?.title ?? '',
    );
  }

  void showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title ?? '',
      message.notification?.body ?? '',
      platformChannelSpecifics,
      payload: json.encode(message.data),
    );
  }

  Future<void> requestPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  Future<void> subscribeToGroup(String groupId) async {
    await _firebaseMessaging.subscribeToTopic(groupId);
    print('Subscribed to topic: $groupId');
  }

  Future<void> unsubscribeFromGroup(String groupId) async {
    await _firebaseMessaging.unsubscribeFromTopic(groupId);
    print('Unsubscribed from topic: $groupId');
  }

  Future<void> sendGroupNotification(
      String groupId, String title, String body) async {
    // Your FCM server key
    final currentFCMToken = await FirebaseMessaging.instance.getToken();

    final String fcmUrl =
        'https://fcm.googleapis.com/v1/projects/team-coffee-b5a02/messages:send';
    final Map<String, dynamic> message = {
      "message": {
        'topic': '$groupId',
        'notification': {
          'title': title,
          'body': body,
        },
        'data': {
          'type': 'event',
          'id': groupId,
        },
      }
    };
  }

  void showCustomSnackBar(String message, {required String title}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Get.theme.primaryColor,
      colorText: Get.theme.colorScheme.onPrimary,
    );
  }
}
