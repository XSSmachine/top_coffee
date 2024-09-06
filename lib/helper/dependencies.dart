import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:team_coffee/controllers/event_controller.dart';

import '../controllers/auth_controller.dart';
import '../controllers/notification_controller.dart';
import '../controllers/order_controller.dart';
import '../controllers/response_notification_controller.dart';
import '../controllers/user_controller.dart';
import '../data/api/api_client.dart';
import '../data/repository/auth_repo.dart';
import '../data/repository/event_repo.dart';
import '../data/repository/order_repo.dart';
import '../data/repository/user_repo.dart';
import '../utils/app_constants.dart';

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  // SharedPreferences
  Get.put(sharedPreferences, permanent: true);

  // ApiClient
  Get.put(
      ApiClient(
          appBaseUrl: AppConstants.BASE_URL, sharedPreferences: Get.find()),
      permanent: true);

  // Repositories
  Get.put(OrderRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.put(EventRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.put(AuthRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.put(UserRepo(apiClient: Get.find(), sharedPreferences: Get.find()));

  // Controllers
  Get.put(ResponseNotificationController());
  Get.put(NotificationController(apiClient: Get.find()));
  Get.put(AuthController(authRepo: Get.find(), userRepo: Get.find()));
  Get.put(UserController(userRepo: Get.find()));
  Get.put(EventController(
      eventRepo: Get.find(), orderRepo: Get.find(), userRepo: Get.find()));
  Get.put(OrderController(orderRepo: Get.find()));

  print("All dependencies initialized"); // Add this line for debugging
}
