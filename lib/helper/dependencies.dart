
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:team_coffee/controllers/event_controller.dart';
import 'package:team_coffee/helper/rated_events_preferences.dart';
import 'package:team_coffee/helper/user_preferences.dart';

import '../controllers/auth_controller.dart';
import '../controllers/order_controller.dart';
import '../controllers/user_controller.dart';
import '../data/api/api_client.dart';
import '../data/repository/auth_repo.dart';
import '../data/repository/event_repo.dart';
import '../data/repository/order_repo.dart';
import '../data/repository/user_repo.dart';
import '../utils/app_constants.dart';


Future<void> init()async {

  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(()=>sharedPreferences);
  Get.lazyPut(()=>UserPreferences(preferences:Get.find()));
  Get.lazyPut(()=>RatedEventsPreferences(preferences:Get.find()));

  //1. api client
  Get.lazyPut(()=>ApiClient(appBaseUrl: AppConstants.BASE_URL,sharedPreferences:Get.find()));

  //2. repos
  Get.lazyPut(()=>OrderRepo(apiClient: Get.find(),sharedPreferences:Get.find()));
  Get.lazyPut(()=>EventRepo(apiClient: Get.find(),sharedPreferences: Get.find()));
  Get.lazyPut(()=>AuthRepo(apiClient: Get.find(),sharedPreferences: Get.find()));
  Get.lazyPut(()=>UserRepo(apiClient: Get.find(),sharedPreferences:Get.find()));

  //3. controllers
  Get.lazyPut(()=>AuthController(authRepo: Get.find(),userRepo: Get.find()));
  Get.lazyPut(()=>UserController(userRepo: Get.find()));
  Get.lazyPut(()=>EventController(eventRepo: Get.find(), orderRepo: Get.find(),userRepo: Get.find()));
  Get.lazyPut(()=>OrderController(orderRepo: Get.find()));

}