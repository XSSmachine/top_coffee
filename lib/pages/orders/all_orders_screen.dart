import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team_coffee/controllers/event_controller.dart';
import 'package:team_coffee/controllers/order_controller.dart';
import 'package:team_coffee/utils/colors.dart';

import '../../models/my_orders_model.dart';

/// This class displays a list of all orders, event creator can tick off each order to track all of them
/// and also has button to finish whole event when he is ready to do so.
class AllOrdersScreen extends StatefulWidget {
  final String eventId;
  const AllOrdersScreen({super.key, required this.eventId});

  @override
  State<AllOrdersScreen> createState() => _AllOrdersScreenState();
}

List<MyOrder> orders = [];

void _finishEvent(EventController eventController, String eventId) {
  print("called finishEvent");
  bool allChecked = orders.every((order) => order.isChecked ?? false);

  if (!allChecked) {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('Are you sure you want to finish the event?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Finish'),
              onPressed: () {
                // Handle the finish event logic here
                eventController.updateEvent(eventId, "COMPLETED");
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  } else {
    // Handle the finish event logic here
    eventController.updateEvent(eventId, "COMPLETED");
    Get.back();
  }
}

class _AllOrdersScreenState extends State<AllOrdersScreen> {
  OrderController orderController = Get.find<OrderController>();
  EventController eventController = Get.find<EventController>();
  List<MyOrder> orders = []; // Move orders list here

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  void fetchOrders() async {
    try {
      final orderList =
          await orderController.getAllOrdersForMyEvent(widget.eventId);
      setState(() {
        orders = orderList;
      });
    } catch (e) {
      print('Error fetching orders: $e');
      // Handle error (e.g., show a snackbar)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: orders.isEmpty
          ? Center(
              child:
                  CircularProgressIndicator()) // Show loading indicator while fetching
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundImage: AssetImage('assets/image/user.png'),
                  ),
                  title: Text(orders[index].firstName),
                  subtitle: Text(orders[index].additionalOptions.toString()),
                  trailing: Checkbox(
                    value: orders[index].isChecked ?? false,
                    onChanged: (bool? value) {
                      setState(() {
                        orders[index].isChecked = value!;
                      });
                    },
                  ),
                );
              },
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            _finishEvent(eventController, widget.eventId);
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: AppColors.mainBlueDarkColor,
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            textStyle: const TextStyle(fontSize: 18),
          ),
          child: const Text('FINISH'),
        ),
      ),
    );
  }
}

class Order {
  String name;
  String description;
  bool isChecked;

  Order(
      {required this.name, required this.description, this.isChecked = false});
}
