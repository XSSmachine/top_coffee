import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../models/group_data.dart';
import '../../../utils/dimensions.dart';
import 'group_selection_screen.dart';

import 'package:team_coffee/controllers/group_controller.dart';

class GroupSelector extends StatelessWidget {
  final List<Group> groups;
  final Function(Group) onGroupSelected;

  const GroupSelector({
    Key? key,
    required this.groups,
    required this.onGroupSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GroupController groupController = Get.find<GroupController>();

    return GestureDetector(
      onTap: () => Get.to(
        () => GroupSelectionPage(
          groups: groups,
          selectedGroupId: groupController.currentGroupId.value,
          onGroupSelected: onGroupSelected,
        ),
        transition: Transition.leftToRightWithFade,
      ),
      child: Obx(() {
        final selectedGroup = groups.firstWhere(
          (group) => group.groupId == groupController.currentGroupId.value,
          orElse: () => groups.first,
        );

        return Container(
          width: Dimensions.radius30 * 2,
          height: Dimensions.radius30 * 2,
          child: Stack(
            children: [
              CircleAvatar(
                radius: Dimensions.radius30,
                backgroundColor: Colors.grey[200],
                backgroundImage: selectedGroup.photoUrl != null
                    ? NetworkImage(selectedGroup.photoUrl!)
                    : null,
                child: selectedGroup.photoUrl == null
                    ? Icon(Icons.group, size: Dimensions.radius30)
                    : null,
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Icon(Icons.cached, size: 16),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
