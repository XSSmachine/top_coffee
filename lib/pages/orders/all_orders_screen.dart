import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';


/**
 * This class displays a list of all orders, event creator can tick off each order to track all of them
 * and also has button to finish whole event when he is ready to do so.
 */
class AllOrdersScreen extends StatefulWidget {
  const AllOrdersScreen({super.key});

  @override
  State<AllOrdersScreen> createState() => _AllOrdersScreenState();
}


  List<Order> orders = [
    Order(name: 'Marko Urić', description: 'Ja zelim pečenu patku sa žara, sa strane umak od gljiva', isChecked: false),
    Order(name: 'Marko Urić', description: 'Ja zelim pečenu patku sa žara, sa strane umak od gljiva', isChecked: true),
    Order(name: 'Marko Urić', description: 'Ja zelim pečenu patku sa žara, sa strane umak od gljiva', isChecked: false),
  ];

  void _finishEvent() {
    bool allChecked = orders.every((order) => order.isChecked);

    if (!allChecked) {
      showDialog(
        context: Get.context!,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Are you sure you want to finish the event? All orders left unchecked will be cancelled.'),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Finish'),
                onPressed: () {
                  // Handle the finish event logic here
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      // Handle the finish event logic here
    }
  }

class _AllOrdersScreenState extends State<AllOrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/avatar.png'), // Replace with your image asset
            ),
            title: Text(orders[index].name),
            subtitle: Text(orders[index].description),
            trailing: Checkbox(
              value: orders[index].isChecked,
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
          onPressed: _finishEvent,
          child: Text('FINISH'),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.blue,
            padding: EdgeInsets.symmetric(vertical: 16.0),
            textStyle: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}

class Order {
  String name;
  String description;
  bool isChecked;

  Order({required this.name, required this.description, this.isChecked = false});
}

