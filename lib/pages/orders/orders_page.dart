import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../models/order_get_model.dart';
import '../../widgets/home/order_list_widget.dart';

class OrdersScreen extends StatelessWidget {


  OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final coffeeOrders = Get.arguments['coffeeOrders'] as List<OrderGetModel>;
    return Scaffold(
      appBar: AppBar(
        title: Text('Coffee Orders'),
      ),
      body: CoffeeOrderList(
        coffeeOrders: coffeeOrders,
        onFinishOrder: () {
          Navigator.pop(context); // Optionally close this screen when done
        },
      ),
    );
  }
}
