import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:team_coffee/controllers/event_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../models/filter_model.dart';
import '../../models/group_data.dart';
import '../../routes/route_helper.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';

import 'package:lottie/lottie.dart';
import '../../utils/string_resources.dart';

class GroupListScreen extends StatefulWidget {
  @override
  _GroupListScreenState createState() => _GroupListScreenState();
}

class _GroupListScreenState extends State<GroupListScreen> {
  final AuthController authController = Get.find<AuthController>();
  final EventController eventController = Get.find<EventController>();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  String? selectedGroupId;
  List<Group> groups = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      groups = await authController.fetchAllGroups();
    } catch (e) {
      Get.snackbar(AppStrings.errorMsg.tr, '${AppStrings.failLoadMsg.tr} $e');
    }
  }

  void _onRefresh() async {
    await _loadData();
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<AuthController>(
        builder: (controller) {
          if (controller.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          // if (groups.isEmpty) {
          //   WidgetsBinding.instance.addPostFrameCallback((_) {
          //     Get.toNamed(RouteHelper.getGroupPage('first'));
          //   });
          // }
          return Column(
            children: [
              // Lottie animation (unchanged)
              Padding(
                padding: EdgeInsets.only(
                    top: Dimensions.height15 * 2,
                    bottom: Dimensions.height10 * 0.8),
                child: SizedBox(
                  height: Dimensions.height30 * 10,
                  child: OverflowBox(
                    alignment: Alignment.topCenter,
                    minHeight: Dimensions.height10 * 40,
                    maxHeight: Dimensions.height10 * 40,
                    child: ColorFiltered(
                      colorFilter: const ColorFilter.mode(
                        AppColors.mainBlueColor,
                        BlendMode.modulate,
                      ),
                      child: Lottie.asset(
                        'assets/image/animation_gr.json',
                        height: Dimensions.height10 * 40,
                        fit: BoxFit.contain,
                        frameRate: FrameRate.max,
                      ),
                    ),
                  ),
                ),
              ),
              // Expanded card with gradient
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.mainBlueVeryDarkColor,
                        AppColors.mainBlueColor.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(Dimensions.radius15),
                      topRight: Radius.circular(Dimensions.radius15),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(Dimensions.radius15),
                      topRight: Radius.circular(Dimensions.radius15),
                    ),
                    child: Card(
                      margin: EdgeInsets.zero,
                      color: Colors.transparent,
                      elevation: 0,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(Dimensions.height15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppStrings.yourGroupsMsg.tr,
                                  style: TextStyle(
                                    fontSize: Dimensions.font20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Get.toNamed(
                                        RouteHelper.getGroupPage('join'));
                                  },
                                  icon: Icon(Icons.add, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: SmartRefresher(
                              controller: _refreshController,
                              onRefresh: _onRefresh,
                              child: ListView.builder(
                                itemCount: groups.length,
                                itemBuilder: (context, index) {
                                  Group group = groups[index];
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: Dimensions.height10 * 0.8,
                                        horizontal: Dimensions.width15),
                                    child: Card(
                                      color: AppColors.mainBlueColor
                                          .withOpacity(0.7),
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            selectedGroupId = group.groupId;
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Row(
                                            children: [
                                              CircleAvatar(
                                                backgroundImage: group
                                                            .photoUrl !=
                                                        null
                                                    ? NetworkImage(
                                                        group.photoUrl!)
                                                    : NetworkImage(
                                                        'https://via.placeholder.com/150'),
                                                radius:
                                                    Dimensions.radius30 * 1.2,
                                              ),
                                              SizedBox(
                                                  width: Dimensions.width15),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(group.name,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: Dimensions
                                                                    .font20 *
                                                                0.9,
                                                            color:
                                                                Colors.white)),
                                                    SizedBox(
                                                        height: Dimensions
                                                                .height10 *
                                                            0.4),
                                                    Text(
                                                      group.description,
                                                      style: TextStyle(
                                                          fontSize: Dimensions
                                                                  .font16 *
                                                              0.8,
                                                          color: Colors.white),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              if (selectedGroupId ==
                                                  group.groupId)
                                                Icon(Icons.check_outlined,
                                                    color: Colors.white,
                                                    weight: Dimensions.height45,
                                                    size:
                                                        Dimensions.iconSize24),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: Dimensions.height20,
                              left: Dimensions.width15,
                              right: Dimensions.width15,
                            ),
                            child: ElevatedButton(
                              child: Text(AppStrings.continueToHomeBtn.tr),
                              style: ElevatedButton.styleFrom(
                                minimumSize:
                                    Size(double.infinity, Dimensions.height45),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.height15),
                                ),
                                foregroundColor: Colors.white,
                                backgroundColor: AppColors.mainBlueColor,
                              ),
                              onPressed: selectedGroupId != null
                                  ? () async {
                                      try {
                                        await controller
                                            .saveGroupId(selectedGroupId!);
                                        await controller.fetchAndSetGroupId();
                                        await eventController
                                            .fetchFilteredEvents(
                                          page: 0,
                                          size: eventController.pageSize,
                                          search: '',
                                          filters: EventFilters(
                                            eventType: eventController
                                                .selectedEventType.value,
                                            status: eventController
                                                .selectedEventStatus.value,
                                            timeFilter: eventController
                                                .selectedTimeFilter.value,
                                          ),
                                        );
                                        Get.toNamed(RouteHelper.getInitial());
                                      } catch (e) {
                                        Get.snackbar('Error',
                                            'Failed to process group selection: $e');
                                      }
                                    }
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }
}
