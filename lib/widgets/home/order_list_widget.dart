import 'package:flutter/material.dart';

import '../../models/order_get_model.dart';


class CoffeeOrderList extends StatefulWidget {
  final List<OrderGetModel> coffeeOrders;
  final Color backgroundColor;
  final Color textColor;
  final Color checkboxColor;
  final VoidCallback onFinishOrder;

  const CoffeeOrderList({
    super.key,
    required this.coffeeOrders,
    this.backgroundColor = Colors.grey,
    this.textColor = Colors.white,
    this.checkboxColor = Colors.white,
    required this.onFinishOrder,
  });

  @override
  _CoffeeOrderListState createState() => _CoffeeOrderListState();
}

class _CoffeeOrderListState extends State<CoffeeOrderList> {
  List<bool> _orderStatus = [];

  @override
  void initState() {
    super.initState();
    _orderStatus = List<bool>.filled(widget.coffeeOrders.length, false);
  }

  bool allOrdersCompleted() {
    return _orderStatus.every((status) => status);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: widget.backgroundColor,
      ),
      child: Column(
        children: [
          Text(
            "Coffee Orders",
            style: TextStyle(color: widget.textColor, fontSize: 20),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: widget.coffeeOrders.length,
              itemBuilder: (context, index) {
                OrderGetModel order = widget.coffeeOrders[index];
                return CheckboxListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Type: ${order.additionalOptions!["type"]}",
                        style: TextStyle(color: widget.textColor),
                      ),
                      Text(
                        "Sugar Quantity: ${order.additionalOptions!["sugar"]}",
                        style: TextStyle(color: widget.textColor),
                      ),
                      Text(
                        "Milk Quantity: ${order.additionalOptions!["milk"]}",
                        style: TextStyle(color: widget.textColor),
                      ),
                    ],
                  ),
                  value: _orderStatus[index],
                  onChanged: (bool? value) {
                    setState(() {
                      _orderStatus[index] = value ?? false;
                    });
                  },
                  activeColor: widget.checkboxColor,
                  checkColor: widget.backgroundColor,
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: allOrdersCompleted() ? widget.onFinishOrder : null,
            child: const Text("Finish Order"),
          ),
        ],
      ),
    );
  }
}
