import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import '../../routes/route_helper.dart';
import 'package:get/get.dart';

class FirebaseApi {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
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
    print('Token: $fCMToken');

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    // Handle foreground messages
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   showCustomSnackBar(
    //     message.notification?.body ?? '',
    //     title: message.notification?.title ?? '',
    //   );
    // });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Notification clicked: ${message.data}");
      handleNotificationClick(message);
    });

    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      print("App opened from terminated state: ${initialMessage.data}");
      handleNotificationClick(initialMessage);
    }
  }

  void handleNotificationClick(RemoteMessage message) {
    if (message.data['screen'] != null) {
      String screen = message.data['screen'];
      String? eventId = message.data['event_id'];

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
    }
  }

  void navigateToEventDetails(String? eventId) {
    print("Navigating to event details: $eventId");
    Get.toNamed(RouteHelper.eventDetail,
        arguments: {'eventId': eventId, 'page': "pending", 'orderId': null});
  }

  void navigateToAllOrders(String? eventId) {
    print("Navigating to all orders: $eventId");
    Get.toNamed(RouteHelper.allOrderPage, arguments: {'eventId': eventId});
  }

  // void showCustomSnackBar(String message, {String? title}) {
  //   // Implement your custom snackbar here
  //   Get.snackbar(title ?? 'Notification', message);
  // }
}

@pragma('vm:entry-point')
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Background message received:');
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}
