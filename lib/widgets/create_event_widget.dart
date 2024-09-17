import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../routes/route_helper.dart';
import '../utils/dimensions.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../utils/string_resources.dart';

class CreateEventWidget extends StatefulWidget {
  const CreateEventWidget({Key? key}) : super(key: key);

  @override
  _CreateEventWidgetState createState() => _CreateEventWidgetState();
}

class _CreateEventWidgetState extends State<CreateEventWidget>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _foodTableController;
  bool _isFoodTableVisible = false;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _foodTableController = AnimationController(vsync: this);
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _foodTableController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(RouteHelper.eventCreatePage);
      },
      child: Container(
        width: double.infinity,
        height: Dimensions.height30 * 7.4,
        margin: EdgeInsets.symmetric(horizontal: Dimensions.height10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radius20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Dimensions.radius20),
          child: Stack(
            alignment: Alignment.center,
            children: [
              /*Positioned(
                right: Dimensions.width10 * 9.5,
                bottom: 0,
                child: AnimatedOpacity(
                  opacity: _isFoodTableVisible ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 500),
                  child: Lottie.asset(
                    'assets/image/food_table1.json',
                    controller: _foodTableController,
                    width: Dimensions.width10 * 21,
                    height: Dimensions.width10 * 21,
                    fit: BoxFit.cover,
                    onLoaded: (composition) {
                      _foodTableController
                        ..duration = composition.duration
                        ..forward().then((_) {
                          setState(() {
                            _isFoodTableVisible = true;
                          });
                          _fadeController.reverse(); // Fade out cook animation
                        });
                    },
                  ),
                ),
              ),*/
              Positioned(
                right: Dimensions.width10 * 5.6,
                bottom: -Dimensions.height10 * 5,
                child: Lottie.asset(
                  'assets/image/cook_animation.json',
                  width: Dimensions.width10 * 28,
                  height: Dimensions.width10 * 28,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                right: Dimensions.width10 * 6,
                top: Dimensions.height15,
                child: Text(
                  AppStrings.createEventWidget.tr,
                  style: TextStyle(fontSize: Dimensions.font16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
