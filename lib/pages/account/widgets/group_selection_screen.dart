import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:team_coffee/controllers/auth_controller.dart';

import '../../../models/group_data.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimensions.dart';

class GroupSelectionPage extends StatefulWidget {
  final List<Group> groups;
  final String? selectedGroupId;
  final Function(Group) onGroupSelected;

  const GroupSelectionPage({
    Key? key,
    required this.groups,
    required this.selectedGroupId,
    required this.onGroupSelected,
  }) : super(key: key);

  @override
  _GroupSelectionPageState createState() => _GroupSelectionPageState();
}

class _GroupSelectionPageState extends State<GroupSelectionPage> {
  AuthController authController = Get.find<AuthController>();
  String? _selectedGroupId;

  @override
  void initState() {
    super.initState();
    _selectedGroupId = widget.selectedGroupId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBlueColor.withOpacity(0.7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Select Group',
          style: TextStyle(
            fontSize: Dimensions.font20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView.builder(
        itemCount: widget.groups.length,
        itemBuilder: (context, index) {
          Group group = widget.groups[index];
          return Padding(
            padding: EdgeInsets.symmetric(
              vertical: Dimensions.height10 * 0.8,
              horizontal: Dimensions.width15,
            ),
            child: Card(
              color: AppColors.mainBlueColor,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedGroupId = group.groupId;
                    authController.saveGroupId(group.groupId);
                  });
                  widget.onGroupSelected(group);
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: group.photoUrl != null
                            ? NetworkImage(group.photoUrl!)
                            : NetworkImage('https://via.placeholder.com/150'),
                        radius: Dimensions.radius30 * 1.2,
                      ),
                      SizedBox(width: Dimensions.width15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              group.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: Dimensions.font20 * 0.9,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: Dimensions.height10 * 0.4),
                            Text(
                              group.description,
                              style: TextStyle(
                                fontSize: Dimensions.font16 * 0.8,
                                color: Colors.white,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      if (_selectedGroupId == group.groupId)
                        Icon(
                          Icons.check_outlined,
                          color: Colors.white,
                          size: Dimensions.iconSize24,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
