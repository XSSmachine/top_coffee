import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:team_coffee/pages/leaderboard/widgets/skeleton_user_item.dart';
import 'package:team_coffee/utils/app_constants.dart';
import 'package:team_coffee/utils/string_resources.dart';

import '../../controllers/group_controller.dart';
import '../../controllers/user_controller.dart';
import '../../models/user_model.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/icon_and_text_widget.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
    with TickerProviderStateMixin {
  final UserController userController = Get.find<UserController>();
  final GroupController groupController = Get.find<GroupController>();
  bool showFilters = false;
  String selectedFilter = "FIRSTNAME";
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  List<Animation<double>> _itemAnimations = [];

  @override
  void initState() {
    super.initState();

    ever(
        groupController.currentGroupId,
        (_) => setState(() {
              _refreshLeaderboard();
            }));
    _initializeLeaderboard();
    _scrollController.addListener(_onScroll);
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _initializeLeaderboard() async {
    await userController.getLeaderBoard(selectedFilter);
    _setupAnimations();
  }

  void _setupAnimations() {
    _itemAnimations = List.generate(
      userController.allUserList.length,
      (index) => Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval((1 / userController.allUserList.length) * index, 1.0,
              curve: Curves.easeOut),
        ),
      ),
    );
    _animationController.forward();
  }

  Future<void> _refreshLeaderboard() async {
    await userController.getLeaderBoard(selectedFilter);
  }

  void _applyFilter() {
    _refreshLeaderboard();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMore();
    }
  }

  void _loadMore() {
    if (!userController.isLoading && userController.hasMore) {
      userController.getLeaderBoard(selectedFilter, loadMore: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(showFilters
            ? Dimensions.height10 * 17
            : Dimensions.height10 * 10.8),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          height: showFilters
              ? Dimensions.height10 * 17
              : Dimensions.height10 * 10.8,
          decoration: BoxDecoration(
            color: AppColors.mainBlueDarkColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(Dimensions.radius20),
              bottomRight: Radius.circular(Dimensions.radius20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10.0,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                AppBar(
                  backgroundColor: Colors.transparent,
                  automaticallyImplyLeading: false,
                  elevation: 0,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(width: Dimensions.width20 * 3.6),
                      Text(
                        AppStrings.leaderboardTitle.tr,
                        style: TextStyle(
                          fontSize: Dimensions.font20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            showFilters = !showFilters;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(Dimensions.height10 * 0.5),
                          decoration: BoxDecoration(
                            color: AppColors.mainBlueColor,
                            borderRadius:
                                BorderRadius.circular(Dimensions.radius20),
                          ),
                          child: IconAndTextWidget(
                            icon: Icons.filter_list,
                            text: AppStrings.filtersTitle.tr,
                            iconColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // if (showFilters)
                SizedBox(
                  height: Dimensions.height15,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FilterChip(
                        label: Text(AppStrings.firstName.tr),
                        selected: selectedFilter == 'FIRSTNAME',
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        onSelected: (bool selected) {
                          setState(() {
                            selectedFilter =
                                selected ? 'FIRSTNAME' : 'FIRSTNAME';
                          });
                          _applyFilter();
                        },
                      ),
                      FilterChip(
                        label: Text(AppStrings.ordersFilter.tr),
                        selected: selectedFilter == 'ORDER_COUNT',
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        onSelected: (bool selected) {
                          setState(() {
                            selectedFilter =
                                selected ? 'ORDER_COUNT' : "FIRSTNAME";
                          });
                          _applyFilter();
                        },
                      ),
                      FilterChip(
                        label: Text(AppStrings.scoreFilter.tr),
                        selected: selectedFilter == 'SCORE',
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        onSelected: (bool selected) {
                          setState(() {
                            selectedFilter = selected ? 'SCORE' : 'FIRSTNAME';
                          });
                          _applyFilter();
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: Dimensions.height20,
                )
              ],
            ),
          ),
        ),
      ),
      body: GetBuilder<UserController>(
        builder: (controller) {
          if (controller.isLoading && controller.allUserList.isEmpty) {
            return ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) => SkeletonUserItem(),
            );
          } else if (controller.allUserList.isEmpty) {
            return Center(
                child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset("assets/image/empty_leaderboard.json",
                    height: Dimensions.height45 * 5,
                    width: Dimensions.width30 * 7),
                Text(AppStrings.noRatings.tr),
              ],
            ));
          }
          return RefreshIndicator(
            onRefresh: _refreshLeaderboard,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: Dimensions.height15),
              child: ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                controller: _scrollController,
                itemCount: controller.allUserList.length +
                    (controller.hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < controller.allUserList.length) {
                    UserModel user = controller.allUserList[index];
                    return _buildUserListItem(
                        user, index, controller.allUserList.length);
                  } else if (controller.hasMore) {
                    return Padding(
                      padding: EdgeInsets.all(Dimensions.height20),
                      child: Center(
                        child: ElevatedButton(
                          onPressed: _loadMore,
                          child: Text(AppStrings.loadMore.tr),
                        ),
                      ),
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserListItem(UserModel user, int index, int totalUsers) {
    double elevation = 0;
    double scale = 0.95;
    Color backgroundColor = Colors.white;
    Color borderColor = Colors.transparent;

    if (index == 0) {
      elevation = 8;
      scale = 1.05;
      borderColor = Colors.amber;
    } else if (index == 1) {
      elevation = 4;
      scale = 1.02;
      borderColor = Colors.grey;
    } else if (index == 2) {
      elevation = 2;
      scale = 0.99;
      borderColor = Colors.brown;
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.width10,
        vertical: Dimensions.height10 / 2,
      ),
      child: Transform.scale(
        scale: scale,
        child: Card(
          elevation: elevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.radius15),
            side: BorderSide(color: borderColor, width: 1),
          ),
          color: backgroundColor,
          child: Padding(
            padding: EdgeInsets.all(Dimensions.width10),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: Dimensions.radius30 * scale,
                      backgroundImage: user.photoUri != null
                          ? NetworkImage(user.photoUri!)
                          : const AssetImage('assets/image/user.png')
                              as ImageProvider,
                    ),
                    SizedBox(width: Dimensions.width10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name ?? 'Unknown User',
                            style: TextStyle(
                              fontSize: index < 3
                                  ? Dimensions.font20
                                  : Dimensions.font20 * 0.8,
                              fontWeight: index < 3
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          SizedBox(height: Dimensions.height10 / 2),
                          Row(
                            children: [
                              Icon(Icons.event, size: Dimensions.iconSize16),
                              SizedBox(width: 4),
                              Text('${user.orderCount ?? 0}'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    user.score != 0.0
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.star,
                                      size: Dimensions.iconSize24,
                                      color: Colors.amber),
                                  SizedBox(width: 4),
                                  Text(
                                    user.score!.toStringAsFixed(2),
                                    style: TextStyle(
                                      fontSize: Dimensions.font20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : Text(
                            AppStrings.unranked.tr,
                            style: TextStyle(
                              fontSize: Dimensions.font16 * 0.8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
