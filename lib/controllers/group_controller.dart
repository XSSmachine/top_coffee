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
}
