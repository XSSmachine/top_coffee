import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team_coffee/base/no_data_page.dart';
import 'package:team_coffee/controllers/event_controller.dart';
import 'package:team_coffee/controllers/order_controller.dart';
import 'package:team_coffee/pages/orders/orders_screen.dart';
import 'package:team_coffee/utils/colors.dart';
import 'package:team_coffee/utils/string_resources.dart';

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

class _AllOrdersScreenState extends State<AllOrdersScreen> {
  OrderController orderController = Get.find<OrderController>();
  EventController eventController = Get.find<EventController>();
  List<MyOrder> orders = []; // Move orders list here

  void _finishEvent(EventController eventController, String eventId) {
    bool allChecked = orders.every((order) => order.isChecked ?? false);

    if (!allChecked) {
      showDialog(
        context: Get.context!,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(AppStrings.youSure.tr),
            content: Text(AppStrings.youSureEvent.tr),
            actions: [
              TextButton(
                child: Text(AppStrings.cancel.tr),
                onPressed: () {
                  Get.find<EventController>().getActiveEvent2().then((action) {
                    Navigator.of(context).pop();
                  });
                },
              ),
              TextButton(
                child: Text(AppStrings.finish.tr),
                onPressed: () {
                  // Handle the finish event logic here
                  eventController.updateEvent(eventId, "COMPLETED");
                  Get.find<EventController>().getActiveEvent2().then((action) {
                    Navigator.of(context).pop();
                  });
                },
              ),
            ],
          );
        },
      );
    } else {
      // Handle the finish event logic here
      eventController.updateEvent(eventId, "COMPLETED").then((action) {
        Get.find<EventController>().getActiveEvent2().then((action) {
          Navigator.pop(context);
        });
      });
    }
  }

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
        title: Text(AppStrings.ordersFilter.tr),
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
              child: NoDataPage(
                  text: AppStrings
                      .noOrders.tr)) // Show loading indicator while fetching
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundImage: AssetImage('assets/image/user.png'),
                  ),
                  title: Text(orders[index].firstName),
                  subtitle: Text(
                      formatText(orders[index].additionalOptions.toString())),
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
          child: orders.isEmpty
              ? Text(AppStrings.cancelEvent.tr)
              : Text(AppStrings.finishBold.tr),
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

String formatText(String input) {
  // Remove curly braces
  String formattedText = input.replaceAll(RegExp(r'[{}]'), '');

  // Check if the active locale is Croatian
  if (Get.locale?.languageCode == 'hr') {
    // Translate "description" to "opis"
    formattedText = formattedText.replaceAll('description', 'opis');
  }

  return formattedText;
}
