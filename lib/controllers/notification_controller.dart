import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../data/api/api_client.dart';
import '../models/notification.dart';
import '../models/response_model.dart';
import '../routes/route_helper.dart';
import '../utils/app_constants.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class NotificationController extends GetxController {
  final ApiClient apiClient;
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  NotificationController({required this.apiClient});

  static const String TAG = "NotificationController";

  @override
  void onInit() {
    super.onInit();
    initializeNotifications();
    setupInteractedMessage();
  }

  Future<ResponseModel> patchFcmToken(String token) async {
    try {
      final response = await apiClient.patchData(
          '${AppConstants.USER_PROFILE}/fcm-token?token=$token', "");

      if (response.statusCode == 200) {
        // Successful update
        return ResponseModel(true, "FCM token updated successfully");
      } else {
        // Server returned an error
        return ResponseModel(false,
            "Failed to update FCM token. Server returned: ${response.statusCode}");
      }
    } catch (e) {
      // Network or other error occurred
      print("Error updating FCM token: $e");
      return ResponseModel(
          false, "An error occurred while updating FCM token: $e");
    }
  }

  Future<List<NotificationModel>> fetchNotifications(int page, int size) async {
    List<NotificationModel> localList = [];
    try {
      final response = await apiClient
          .getData('${AppConstants.NOTIFICATIONS_LIST}?page=$page&size=$size');
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        response.body.forEach((element) {
          localList.add(NotificationModel.fromJson(element));
        });
        print("NOTIFICATION 2");
        return localList;
      } else {
        throw Exception('Failed to load notifications');
      }
    } catch (e) {
      print(e.toString());
      print("Unexpected Error");
      return localList;
    }
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

    // Create the notification channel for Android
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.max,
    );
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
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

  void onDidReceiveNotificationResponse(NotificationResponse response) async {
    final String? payload = response.payload;
    if (payload != null) {
      print('Local notification tapped with payload: $payload');
      final data = json.decode(payload);
      handleNotificationClick(RemoteMessage(data: data));
    }
  }

  Future<void> setupInteractedMessage() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    final fCMToken = await _firebaseMessaging.getToken();
    print('FCM Token: $fCMToken');
    if (fCMToken != null) {
      patchFcmToken(fCMToken);
    }

    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      print(
          "App opened from terminated state with message: ${initialMessage.data}");
      handleNotificationClick(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("App opened from background with message: ${message.data}");
      handleNotificationClick(message);
    });

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
  }

  void handleNotificationClick(RemoteMessage message) {
    print("Handling notification click: ${message.data}");
    var id = message.data['eventId'];
    print("Navigating to event detail: $id");
    if (message.data['screen'] != null) {
      String screen = message.data['screen'];
      String? eventId = message.data['eventId'];

      print("Handling notification click: screen=$screen, eventId=$eventId");

      switch (screen) {
        case 'event_details':
          navigateToEventDetails(eventId);
          break;
        case 'all-orders':
          navigateToAllOrders(eventId);
          break;
        default:
          print('Unknown screen: $screen');
      }
    } else {
      print("Unknown message type or structure");
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    print("Received foreground message: ${message.data}");
    showLocalNotification(message);
    // showCustomSnackBar(
    //   message.notification?.body ?? '',
    //   title: message.notification?.title ?? '',
    // );
  }

  void showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
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

  void navigateToEventDetails(String? eventId) {
    print("Navigating to event details: $eventId");
    Get.toNamed(RouteHelper.getEventDetail(eventId ?? "", "pending", null));
  }

  void navigateToAllOrders(String? eventId) {
    print("Navigating to all orders: $eventId");
    Get.toNamed(RouteHelper.getAllOrderPage(eventId ?? ""));
  }

  Future<void> subscribeToGroup(String groupId) async {
    await _firebaseMessaging.subscribeToTopic(groupId);
    print('Subscribed to topic: $groupId');
  }

  Future<void> unsubscribeFromGroup(String groupId) async {
    await _firebaseMessaging.unsubscribeFromTopic(groupId);
    print('Unsubscribed from topic: $groupId');
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

@pragma('vm:entry-point')
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Background message received:');
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}
