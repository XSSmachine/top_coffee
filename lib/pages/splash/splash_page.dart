import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../routes/route_helper.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin{

  late Animation<double> animation;
  late AnimationController controller;
  late Animation<double> rotationAnimation;
  /*Future<void> _loadResource() async {
    await Get.find<PopularProductController>().getPopularProductList();
    await Get.find<RecommendedProductController>().getRecommendedProductList();
  }*/

  @override
  void initState() {
  super.initState();
  controller = AnimationController(vsync: this, duration: Duration(seconds: 2))..forward();

  animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);

  // Create rotation animation
  rotationAnimation = Tween<double>(
  begin: 0,
  end: 3, // Convert 400 degrees to radians
  ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOutQuad));

  Timer(
  const Duration(seconds: 3),
  () => Get.offNamed(RouteHelper.getInitial())
  );
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
  backgroundColor: AppColors.mainColor,
  body: Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
  RotationTransition(
  turns: rotationAnimation,
  child: ScaleTransition(
  scale: animation,
  child: Center(
  child: Image.asset(
  "/Users/karlokovacevic/Documents/top_coffee/assets/image/coffeecoffee.png",
  width: Dimensions.splashImg,
  ),
  ),
  ),
  ),
  Center(
  child: Image.asset(
  "/Users/karlokovacevic/Documents/top_coffee/assets/image/coffee_name.png",
  width: Dimensions.splashImg,
  ),
  )
  ],
  ),
  );
  }

  @override
  void dispose() {
  controller.dispose();
  super.dispose();
  }
  }

