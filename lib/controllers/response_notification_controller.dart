import 'package:get/get.dart';

class ResponseNotificationController extends GetxController {
  String notificationMyEvent = ''.obs.toString();

  void setNotificationMyEvent(notification) {
    notificationMyEvent = notification.toString();
    update();
  }

  void addNotificationEvent(bool add) {
    var notificationMyEventInt = add
        ? int.parse(notificationMyEvent) + 1
        : int.parse(notificationMyEvent) - 1;
    notificationMyEvent = notificationMyEventInt.toString();
  }
}
