import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'package:team_coffee/models/navigation/nav_item_model.dart';

import '../../models/navigation/rive_model.dart';
import '../../routes/route_helper.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../utils/string_resources.dart';
import '../account/account_page.dart';
import '../leaderboard/leaderborad_page.dart';
import '../orders/orders_screen.dart';
import 'home_screen.dart';

List<NavItemModel> bottomNavItems = [
  NavItemModel(
      title: AppStrings.exploreBottomNavBar.tr,
      rive: RiveModel(
          src: "assets/travel_icons_pack.riv",
          artboard: "compass",
          stateMachineName: "compass_interactivity")),
  NavItemModel(
      title: AppStrings.myActivitiesBottomNavBar.tr,
      rive: RiveModel(
          src: "assets/travel_icons_pack.riv",
          artboard: "map",
          stateMachineName: "map_interactivity")),
  NavItemModel(
      title: AppStrings.leaderBottomNavBar.tr,
      rive: RiveModel(
          src: "assets/travel_icons_pack.riv",
          artboard: "food",
          stateMachineName: "food_interactivity")),
  NavItemModel(
      title: AppStrings.meBottomNavBar.tr,
      rive: RiveModel(
          src: "assets/travel_icons_pack.riv",
          artboard: "walk",
          stateMachineName: "walk_interactivity")),
];

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  List<SMIBool?> riveIconInputs = List.filled(bottomNavItems.length, null);
  List<StateMachineController?> controllers = [];
  int selectedNavIndex = 0;

  List<Widget> _buildScreens() {
    return [
      const HomeScreen(),
      const OrdersScreen(),
      const LeaderboardScreen(),
      const AccountPage()
    ];
  }

  Artboard? _compassArtboard;

  @override
  void initState() {
    super.initState();
    _loadRiveFile();
  }

  void _loadRiveFile() async {
    final bytes = await rootBundle.load('assets/travel_icons_pack.riv');
    final file = RiveFile.import(bytes);
    final artboard = file.mainArtboard;
    var controller =
        StateMachineController.fromArtboard(artboard, 'compass_interactivity');
    if (controller != null) {
      artboard.addController(controller);
    }
    setState(() => _compassArtboard = artboard);
  }

  void animateTheIcon(int index) {
    if (riveIconInputs[index] != null) {
      riveIconInputs[index]!.change(true);
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted && riveIconInputs[index] != null) {
          riveIconInputs[index]!.change(false);
        }
      });
    }
  }

  void riveOnInit(Artboard artboard,
      {required String stateMachineName, required int index}) {
    StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, stateMachineName);
    if (controller != null) {
      artboard.addController(controller);
      controllers.add(controller);
      riveIconInputs[index] = controller.findInput<bool>('active') as SMIBool?;
    }
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedNavIndex,
        children: _buildScreens(),
      ),
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            alignment: Alignment.center,
            height: Dimensions.height20 * 4,
            padding: EdgeInsets.symmetric(
                horizontal: Dimensions.width20,
                vertical: Dimensions.height10 / 2),
            decoration: BoxDecoration(
              color: AppColors.mainBlueDarkColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Dimensions.radius15),
                topRight: Radius.circular(Dimensions.radius15),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ...List.generate(bottomNavItems.length + 1, (index) {
                  if (index == bottomNavItems.length ~/ 2) {
                    // Add empty space in the middle
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: Dimensions.height20 * 2,
                          width: Dimensions.height20 * 2,
                        ),
                      ],
                    );
                  }
                  final actualIndex =
                      index > bottomNavItems.length ~/ 2 ? index - 1 : index;
                  if (actualIndex >= bottomNavItems.length)
                    return SizedBox.shrink(); // Skip if out of bounds
                  final riveIcon = bottomNavItems[actualIndex].rive;
                  final riveTitle = bottomNavItems[actualIndex].title;
                  return GestureDetector(
                    onTap: () {
                      animateTheIcon(actualIndex);
                      setState(() {
                        selectedNavIndex = actualIndex;
                      });
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: Dimensions.height20 * 2.5,
                          width: Dimensions.height20 * 2.5,
                          decoration: BoxDecoration(
                            color: actualIndex == selectedNavIndex
                                ? AppColors.mainBlueVeryDarkColor
                                    .withOpacity(0.1)
                                : Colors.transparent,
                            borderRadius:
                                BorderRadius.circular(Dimensions.radius20),
                          ),
                          child: RiveAnimation.asset(
                            riveIcon.src,
                            artboard: riveIcon.artboard,
                            onInit: (artboard) {
                              print(artboard.toString());
                              riveOnInit(artboard,
                                  stateMachineName: riveIcon.stateMachineName,
                                  index: actualIndex);
                            },
                          ),
                        ),
                        SizedBox(
                          width: Dimensions.width30 * 2,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              riveTitle,
                              style: TextStyle(
                                color: actualIndex == selectedNavIndex
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.5),
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
          Positioned(
            top: -Dimensions.height20,
            child: GestureDetector(
              onTap: () {
                // Add your onTap functionality here
                Get.toNamed(RouteHelper.eventCreatePage);
              },
              child: Container(
                height: Dimensions.height20 * 3,
                width: Dimensions.height20 * 3,
                decoration: BoxDecoration(
                  color: AppColors.mainBlueMediumColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: Dimensions.height20 * 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
