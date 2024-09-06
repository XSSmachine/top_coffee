import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:team_coffee/pages/home/home_screen.dart';

import 'package:team_coffee/pages/leaderboard/leaderborad_page.dart';
import 'package:team_coffee/pages/orders/orders_screen.dart';
import 'package:team_coffee/routes/route_helper.dart';
import '../../controllers/auth_controller.dart';
import '../../utils/colors.dart';
import '../../utils/string_resources.dart';
import '../account/account_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  late PersistentTabController _controller;

  void onTapNav(int index) {
    //used to trigger ui state
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    //Get.find<AuthController>().handleUnauthorizedAccess();
    _controller = PersistentTabController(initialIndex: 0);
  }

  List<Widget> _buildScreens() {
    return [
      const HomeScreen(),
      const OrdersScreen(),
      Container(),
      const LeaderboardScreen(),
      const AccountPage()
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.compass_fill),
        title: (AppStrings.exploreBottomNavBar.tr),
        activeColorPrimary: AppColors.mainPurpleColor,
        inactiveColorPrimary: AppColors.mainColor,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.rule_rounded),
        title: (AppStrings.myActivitiesBottomNavBar.tr),
        activeColorPrimary: AppColors.mainPurpleColor,
        inactiveColorPrimary: AppColors.mainColor,
      ),
      PersistentBottomNavBarItem(
        iconSize: 28,
        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        title: (AppStrings.addBottomNavBar.tr),
        activeColorPrimary: AppColors.mainPurpleColor,
        inactiveColorPrimary: AppColors.mainBlackColor,
        onPressed: (context) {
          Get.toNamed(RouteHelper.eventCreatePage);
        },
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.emoji_events),
        title: (AppStrings.leaderBottomNavBar.tr),
        activeColorPrimary: AppColors.mainPurpleColor,
        inactiveColorPrimary: AppColors.mainColor,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.person_fill),
        title: (AppStrings.meBottomNavBar.tr),
        activeColorPrimary: AppColors.mainPurpleColor,
        inactiveColorPrimary: AppColors.mainColor,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.white, // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset:
          true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardShows:
          true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle:
          NavBarStyle.style15, // Choose the nav bar style with this property.
    );
  }
}
