import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:team_coffee/models/event_status_count.dart';
import 'package:team_coffee/models/fetch_me_model.dart';
import 'package:team_coffee/models/order_status_count.dart';
import '../controllers/auth_controller.dart';
import '../controllers/user_controller.dart';
import '../models/group_data.dart';
import '../pages/account/widgets/group_selection_screen.dart';
import '../pages/account/widgets/group_selector_widget.dart';
import '../routes/route_helper.dart';
import '../utils/colors.dart';
import '../utils/dimensions.dart';

class WordCustomCard extends StatefulWidget {
  final FetchMeModel user;
  final UserController userController;
  final Function() onEditProfile;

  const WordCustomCard({
    Key? key,
    required this.user,
    required this.userController,
    required this.onEditProfile,
  }) : super(key: key);

  @override
  _WordCustomCardState createState() => _WordCustomCardState();
}

class _WordCustomCardState extends State<WordCustomCard> {
  final AuthController authController = Get.find<AuthController>();
  bool _isExpanded = false;
  Group? _selectedGroup;
  List<Group> _groups = [];

  @override
  void initState() {
    super.initState();
    _fetchGroups();
  }

  Future<void> _fetchGroups() async {
    try {
      List<Group> fetchedGroups = await authController.fetchAllGroups();
      setState(() {
        _groups = fetchedGroups;
        _selectedGroup = _groups.firstWhereOrNull(
          (group) =>
              group.groupId == widget.userController.group.value?.groupId,
        );

        if (_selectedGroup == null && _groups.isNotEmpty) {
          _selectedGroup = _groups.first;
        }
      });
    } catch (e) {
      print('Error fetching groups: $e');
    }
  }

  Future<void> fetchAllData() async {
    await widget.userController.getUserProfileDetails();
    await widget.userController.getOrderStats();
    await widget.userController.getEventsStats();
    await widget.userController.fetchProfilePhoto();
    await widget.userController.getGroupName();
  }

  void _showGroupDescriptionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.radius20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(Dimensions.height20),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(Dimensions.radius20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: const Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  widget.userController.groupName.value,
                  style: TextStyle(
                    fontSize: Dimensions.font20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: Dimensions.height15),
                Text(
                  widget.userController.groupDesc.value ??
                      'No description available',
                  style: TextStyle(fontSize: Dimensions.font16),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: Dimensions.height20),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Close',
                    style: TextStyle(
                      fontSize: Dimensions.font16,
                      color: AppColors.candyPurpleColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    int allOrderCount = widget.userController.orderStats.sumOrderStatusCounts();
    int allEventCount = widget.userController.eventStats.sumAllCounts();
    return FutureBuilder(
      future: fetchAllData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              // Purple card (bottom)
              GestureDetector(
                onTap: () {
                  Get.toNamed(RouteHelper.accountStatsPage);
                },
                child: Container(
                  margin: EdgeInsets.only(top: Dimensions.height45 * 6.5),
                  padding: const EdgeInsets.fromLTRB(20, 70, 20, 20),
                  decoration: BoxDecoration(
                    color: AppColors.candyPurpleColor,
                    borderRadius: BorderRadius.circular(Dimensions.radius30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: Dimensions.height20 * 2,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: _buildStatColumn(
                                '${widget.userController.orderStats.sumOrderStatusCounts()}',
                                'ORDERS'),
                          ),
                          Expanded(
                            child: _buildStatColumn(
                                '${widget.userController.eventStats.sumAllCounts()}',
                                'EVENTS'),
                          ),
                          Expanded(
                            child: _buildStatColumn(
                                widget.userController.userDetail?.score
                                        .toString() ??
                                    'N/A',
                                'RATING'),
                          ),
                          Expanded(
                            flex: 0,
                            child: _buildClickColumn(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // White card (top)
              Positioned(
                top: 0,
                child: AnimatedContainer(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(
                      top: Dimensions.height45 * 1,
                      bottom: Dimensions.height30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(Dimensions.radius30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  duration: Duration(milliseconds: 300),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.width20),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: Dimensions.radius30 * 2,
                              height: Dimensions.radius30 * 2,
                              child: GroupSelector(
                                groups: _groups,
                                selectedGroup: _selectedGroup,
                                onGroupSelected: (Group group) {
                                  setState(() {
                                    _selectedGroup = group;
                                  });
                                  widget.userController
                                      .updateGroupName(group.name);
                                },
                              ),
                            ),
                            IconButton(
                                onPressed: widget.onEditProfile,
                                icon: Icon(Icons.edit)),
                          ],
                        ),
                      ),
                      CircleAvatar(
                        radius: Dimensions.radius30 * 2.8,
                        backgroundColor: Colors.grey[200],
                        child: Obx(() {
                          if (widget.userController.profileImage.value !=
                              null) {
                            return CircleAvatar(
                              radius: Dimensions.radius30 * 2.8,
                              backgroundImage: MemoryImage(
                                  widget.userController.profileImage.value!),
                            );
                          } else {
                            return CircleAvatar(
                              radius: Dimensions.radius30 * 2.8,
                              child: Icon(Icons.person, size: 48),
                            );
                          }
                        }),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${widget.user.firstName} ${widget.user.lastName}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      InkWell(
                        onTap: () {
                          _showGroupDescriptionDialog(context);
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  widget.userController.groupName.value + ', ',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              Icon(
                                _isExpanded
                                    ? Icons.expand_less
                                    : Icons.more_horiz,
                                color: Colors.grey,
                                size: Dimensions.iconSize24,
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (_isExpanded)
                        Padding(
                          padding: EdgeInsets.all(Dimensions.height10),
                          child: Text(
                            widget.userController.groupDesc.value ??
                                'No description available',
                            style: TextStyle(
                                fontSize: Dimensions.font16 * 0.8,
                                color: Colors.grey[600]),
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              // Purple card (bottom)
              GestureDetector(
                onTap: () {
                  Get.toNamed(RouteHelper.accountStatsPage);
                },
                child: Container(
                  margin: EdgeInsets.only(top: Dimensions.height45 * 6.5),
                  padding: const EdgeInsets.fromLTRB(20, 70, 20, 20),
                  decoration: BoxDecoration(
                    color: AppColors.candyPurpleColor,
                    borderRadius: BorderRadius.circular(Dimensions.radius30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: Dimensions.height20 * 2,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: _buildStatColumn(
                                '${widget.userController.orderStats.sumOrderStatusCounts()}',
                                'ORDERS'),
                          ),
                          Expanded(
                            child: _buildStatColumn(
                                '${widget.userController.eventStats.sumAllCounts()}',
                                'EVENTS'),
                          ),
                          Expanded(
                            child: _buildStatColumn(
                                widget.userController.userDetail?.score
                                        .toString() ??
                                    'N/A',
                                'RATING'),
                          ),
                          Expanded(
                            flex: 0,
                            child: _buildClickColumn(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // White card (top)
              Positioned(
                top: 0,
                child: AnimatedContainer(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(
                      top: Dimensions.height45 * 1,
                      bottom: Dimensions.height30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(Dimensions.radius30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  duration: Duration(milliseconds: 300),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.width20),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: Dimensions.radius30 * 2,
                              height: Dimensions.radius30 * 2,
                              child: GroupSelector(
                                groups: _groups,
                                selectedGroup: _selectedGroup,
                                onGroupSelected: (Group group) {
                                  setState(() {
                                    _selectedGroup = group;
                                  });
                                  widget.userController
                                      .updateGroupName(group.name);
                                },
                              ),
                            ),
                            IconButton(
                                onPressed: widget.onEditProfile,
                                icon: Icon(Icons.edit)),
                          ],
                        ),
                      ),
                      CircleAvatar(
                        radius: Dimensions.radius30 * 2.8,
                        backgroundColor: Colors.grey[200],
                        child: Obx(() {
                          if (widget.userController.profileImage.value !=
                              null) {
                            return CircleAvatar(
                              radius: Dimensions.radius30 * 2.8,
                              backgroundImage: MemoryImage(
                                  widget.userController.profileImage.value!),
                            );
                          } else {
                            return CircleAvatar(
                              radius: Dimensions.radius30 * 2.8,
                              child: Icon(Icons.person, size: 48),
                            );
                          }
                        }),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${widget.user.firstName} ${widget.user.lastName}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      InkWell(
                        onTap: () {
                          _showGroupDescriptionDialog(context);
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  widget.userController.groupName.value + ', ',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              Icon(
                                _isExpanded
                                    ? Icons.expand_less
                                    : Icons.more_horiz,
                                color: Colors.grey,
                                size: Dimensions.iconSize24,
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (_isExpanded)
                        Padding(
                          padding: EdgeInsets.all(Dimensions.height10),
                          child: Text(
                            widget.userController.groupDesc.value ??
                                'No description available',
                            style: TextStyle(
                                fontSize: Dimensions.font16 * 0.8,
                                color: Colors.grey[600]),
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildStatColumn(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: Dimensions.font20 * 0.8,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: Dimensions.height10 / 2),
        Text(
          label,
          style: TextStyle(
            fontSize: Dimensions.font16 * 0.8,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildClickColumn() {
    return Column(
      children: [
        Icon(
          Icons.arrow_forward_ios,
          size: Dimensions.iconSize16,
          color: Colors.white,
        ),
      ],
    );
  }
}
