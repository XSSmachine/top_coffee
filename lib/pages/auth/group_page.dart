import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tab_container/tab_container.dart';
import 'package:team_coffee/controllers/auth_controller.dart';
import 'package:team_coffee/widgets/group/create_group_widget.dart';
import 'package:team_coffee/widgets/group/join_group_widget.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';

/// This class displays 2 forms for joining or creating new group
class GroupPage extends StatefulWidget {
  const GroupPage({super.key});

  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> with TickerProviderStateMixin {
  late final TabController _tabController;
  late TextTheme textTheme;

  late AnimationController _donutsController;
  late AnimationController _friesController;
  late AnimationController _kafaController;
  late Animation<double> _donutsAnimation;
  late Animation<double> _friesAnimation;
  late Animation<double> _kafaAnimation;
  final bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _donutsController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _friesController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _kafaController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _donutsAnimation = Tween<double>(begin: 0, end: 30).animate(
      CurvedAnimation(
        parent: _donutsController,
        curve: Curves.easeInOut,
      ),
    );
    _friesAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(
        parent: _friesController,
        curve: Curves.easeInQuad,
      ),
    );
    _kafaAnimation = Tween<double>(begin: 0, end: 20).animate(
      CurvedAnimation(
        parent: _kafaController,
        curve: Curves.easeInOutBack,
      ),
    );

    _donutsController.repeat(reverse: true);
    _friesController.repeat(reverse: true);
    _kafaController.repeat(reverse: true);
  }

  @override
  void didChangeDependencies() {
    textTheme = Theme.of(context).textTheme;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _donutsController.dispose();
    _friesController.dispose();
    _kafaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: GetBuilder<AuthController>(builder: (controller) {
      return SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              margin: EdgeInsets.zero,
              height: Dimensions.screenHeight * 0.423,
              width: double.infinity,
              child: Stack(
                children: [
                  Positioned(
                    top: -40,
                    right: Dimensions.height30 * 6,
                    child: AnimatedBuilder(
                      animation: _donutsAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _donutsAnimation.value),
                          child: Transform.rotate(
                            angle: _donutsAnimation.value * 0.01,
                            child: child,
                          ),
                        );
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 130,
                        child: Image.asset(
                          "assets/image/donuts.png",
                          width: 330,
                          height: 330,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: Dimensions.width15 * 1.5,
                    right: Dimensions.height30 * 0.2,
                    child: AnimatedBuilder(
                      animation: _kafaAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _kafaAnimation.value),
                          child: Transform.rotate(
                            angle: _kafaAnimation.value * 0.01,
                            child: child,
                          ),
                        );
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 80,
                        child: Image.asset(
                          "assets/image/kafa.png",
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: Dimensions.height45 * 4.8,
                    right: Dimensions.height30 * 2.2,
                    child: AnimatedBuilder(
                      animation: _friesAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _friesAnimation.value),
                          child: Transform.rotate(
                            angle: _friesAnimation.value * 0.01,
                            child: child,
                          ),
                        );
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 70,
                        child: Image.asset(
                          "assets/image/fries.png",
                          width: 180,
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Sync",
                            style: TextStyle(
                                fontSize: Dimensions.font20 * 2,
                                fontWeight: FontWeight.w600,
                                height: 0.8),
                          ),
                          Text(
                            "Snack",
                            style: TextStyle(
                                fontSize: Dimensions.font20 * 2,
                                fontWeight: FontWeight.w900,
                                height: 0.8),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: double.maxFinite,
              height: Dimensions.screenHeight / 1.734 -
                  MediaQuery.of(context).viewInsets.bottom,
              child: DecoratedBox(
                decoration: const BoxDecoration(color: Colors.white),
                child: AspectRatio(
                  aspectRatio: 10 / 8,
                  child: TabContainer(
                    controller: _tabController,
                    borderRadius: BorderRadius.circular(20),
                    tabEdge: TabEdge.top,
                    curve: Curves.easeIn,
                    transitionBuilder: (child, animation) {
                      animation = CurvedAnimation(
                          curve: Curves.easeIn, parent: animation);
                      return SlideTransition(
                        position: Tween(
                          begin: const Offset(0.2, 0.0),
                          end: const Offset(0.0, 0.0),
                        ).animate(animation),
                        child: FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                      );
                    },
                    colors: const <Color>[
                      AppColors.mainBlueColor,
                      AppColors.candyPurpleColor,
                    ],
                    selectedTextStyle:
                        textTheme.bodyMedium?.copyWith(fontSize: 15.0),
                    unselectedTextStyle:
                        textTheme.bodyMedium?.copyWith(fontSize: 13.0),
                    tabs: [
                      Text(
                        'Join Group',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: Dimensions.font16 - 2),
                      ),
                      Text(
                        'Create Group',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: Dimensions.font16 - 2),
                      ),
                    ],
                    children: [
                      JoinGroupWidget(controller: controller),
                      CreateGroupWidget(
                        controller: controller,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }));
  }
}
