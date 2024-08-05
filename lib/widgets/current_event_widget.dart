import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/event_model.dart';
import '../models/order_model.dart';
import '../routes/route_helper.dart';
import '../utils/colors.dart';
import '../utils/dimensions.dart';

class CurrentEventWidget extends StatefulWidget {
  final EventModel event;

  const CurrentEventWidget({super.key, required this.event});

  @override
  _CurrentEventWidgetState createState() => _CurrentEventWidgetState();
}

class _CurrentEventWidgetState extends State<CurrentEventWidget> {
  double _shadowOpacity = 0.6;

  void _animateShadow() {
    setState(() {
      _shadowOpacity = _shadowOpacity == 0.6 ? 1.0 : 0.6;
    });
  }

  @override
  void initState() {
    super.initState();
    // Start the animation loop
    _startAnimationLoop();
  }

  void _startAnimationLoop() async {
    while (true) {
      await Future.delayed(const Duration(seconds: 1));
      _animateShadow();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(_shadowOpacity),
            spreadRadius: 4,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.event, size: 40, color: AppColors.mainBlueColor),
              const SizedBox(width: 10),
              Text(
                widget.event.title ?? "Title",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.mainBlueColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  widget.event.status ?? "Status",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(Dimensions.radius15),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.fastfood, color: Colors.white, size: 16),
                    const SizedBox(width: 5),
                    Text(
                      widget.event.eventType ?? "Food",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
          const Divider(color: Colors.black),
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () {
                Get.toNamed(RouteHelper.getAllOrderPage(widget.event.eventId!));
              },
              style: ElevatedButton.styleFrom(
                elevation: 2,
                foregroundColor: AppColors.mainBlueColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                ),
              ),
              child: Text(
                'My orders',
                style: TextStyle(
                  fontSize: Dimensions.font16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
