import 'package:get/get.dart';
import 'package:team_coffee/controllers/user_controller.dart';

import '../models/filter_model.dart';
import 'event_controller.dart';
import 'order_controller.dart';

class GroupController extends GetxController {
  final Rx<String> currentGroupId = ''.obs;

  void changeGroup(String newGroupId) {
    currentGroupId.value = newGroupId;
    // _updateControllers();
    update();
    print("should update everything!");
  }

  // void _updateControllers() {
  //   print("CALL FUNCTIONS BUT DOESNT WORK!");
  //   if (Get.isRegistered<EventController>()) {
  //     print("CALL FUNCTIONS IN GROUP CONTROLLER");
  //     final eventController = Get.find<EventController>();
  //     eventController.fetchFilteredEvents(
  //       page: 0,
  //       size: eventController.pageSize,
  //       search: '',
  //       filters: EventFilters(
  //         eventType: eventController.selectedEventType.value,
  //         status: eventController.selectedEventStatus.value,
  //         timeFilter: eventController.selectedTimeFilter.value,
  //       ),
  //     );
  //   }
  //
  //   if (Get.isRegistered<OrderController>()) {
  //     Get.find<OrderController>().getFilteredOrders(
  //       page: 0,
  //       size: 10, // Assuming a default page size
  //       status: "IN_PROGRESS", // Default status, you might want to adjust this
  //       rating: '',
  //       type: 'ALL',
  //       search: '',
  //     );
  //   }

  // if (Get.isRegistered<UserController>()) {
  //   final userController = Get.find<UserController>();
  //   userController.getLeaderBoard("FIRSTNAME");
  // }
}
