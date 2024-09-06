import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../routes/route_helper.dart';
import '../utils/dimensions.dart';

class CreateEventWidget extends StatelessWidget {
  const CreateEventWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(RouteHelper.eventCreatePage);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: Dimensions.height20),
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
        padding: EdgeInsets.symmetric(horizontal: Dimensions.width15),
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Create event",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Get some snacks for your team!",
                    style: TextStyle(
                      fontSize: Dimensions.font20 * 0.6,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.asset('assets/image/animation04.1.gif',
                    width: 150, height: 150, fit: BoxFit.fill),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
