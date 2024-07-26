import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:team_coffee/pages/home/top_appBar.dart';
import 'package:team_coffee/pages/leaderboard/leaderborad_page.dart';
import 'package:team_coffee/pages/orders/orders_screen.dart';
import 'package:team_coffee/routes/route_helper.dart';
import '../../utils/colors.dart';
import '../account/account_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _selectedIndex=0;

  late PersistentTabController _controller;


  List pages=[
    Container(child: Center(child: Text("Next page"))),
    Container(child: Center(child: Text("Next next page"))),
    Container(child: Center(child: Text("Next next next page"))),
  ];

  void onTapNav(int index){
    //used to trigger ui state
    setState(() {
      _selectedIndex=index;
    });
  }

  @override
  void initState(){
    super.initState();
    //Get.find<AuthController>().clearSharedData();
    _controller = PersistentTabController(initialIndex: 0);
  }

  List<Widget> _buildScreens() {
    return [
      TopAppbar(),
      OrdersScreen(),
      Container(),
      LeaderboardScreen(),
      AccountPage()
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.compass_fill),
        title: ("Explore"),
        activeColorPrimary: Color(0xFF4A43EC),
        inactiveColorPrimary: AppColors.mainColor,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.rule_rounded),
        title: ("My activities"),
        activeColorPrimary: Color(0xFF4A43EC),
        inactiveColorPrimary: AppColors.mainColor,
      ),
      PersistentBottomNavBarItem(
        iconSize: 28,
        icon: Icon(Icons.add,color: Colors.white
          ,),
        title: ("Add"),
        activeColorPrimary: Color(0xFF4A43EC),
        inactiveColorPrimary: AppColors.mainBlackColor,
        onPressed: (context) {
          Get.toNamed(RouteHelper.eventCreatePage);
        },
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.emoji_events),
        title: ("Leaderboard"),
        activeColorPrimary: Color(0xFF4A43EC),
        inactiveColorPrimary: AppColors.mainColor,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.person_fill),
        title: ("Me"),
        activeColorPrimary: Color(0xFF4A43EC),
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
      resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: ItemAnimationProperties( // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style15, // Choose the nav bar style with this property.
    );
  }
}
