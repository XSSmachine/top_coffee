// order_screen_selector.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:team_coffee/widgets/order/beverage_order_widget.dart';

import '../../controllers/order_controller.dart';
import '../../widgets/order/coffee_order_widget.dart';
import '../../widgets/order/create_food_order_widget.dart';

class OrderScreenSelector extends StatelessWidget {
  final String eventId;
  final String eventType;

  const OrderScreenSelector({
    Key? key,
    required this.eventId,
    required this.eventType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    OrderController orderController = Get.find<OrderController>();
    switch (eventType.toLowerCase()) {
      case 'coffee':
        return CoffeeOrderScreen(
          eventId: eventId,
          orderController: orderController,
        );
      case 'beverage':
        return BeverageOrderScreen(
          eventId: eventId,
          orderController: orderController,
        );
      default:
        return CoolTextFieldScreen(
          eventId: eventId,
          eventType: eventType,
        );
    }
  }
}
