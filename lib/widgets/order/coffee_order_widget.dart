import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../base/show_custom_snackbar.dart';
import '../../controllers/order_controller.dart';
import '../../models/order_body_model.dart';
import '../../routes/route_helper.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';

class CoffeeOrderScreen extends StatefulWidget {
  final String eventId;
  final OrderController orderController;

  const CoffeeOrderScreen({
    Key? key,
    required this.eventId,
    required this.orderController,
  }) : super(key: key);

  @override
  _CoffeeOrderScreenState createState() => _CoffeeOrderScreenState();
}

class _CoffeeOrderScreenState extends State<CoffeeOrderScreen> {
  String _selectedCoffee = 'Latte';
  int _sugarAmount = 1;
  int _milkAmount = 1;
  late TextEditingController _textController;

  final List<String> _coffeeTypes = [
    'Latte',
    'Espresso',
    'Cappuccino',
    'Americano',
    'Turkish'
  ];

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Coffee Order',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.mainBlueColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(Dimensions.width15),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton2<String>(
                  isExpanded: true,
                  underline: SizedBox(),
                  value: _selectedCoffee,
                  iconStyleData: const IconStyleData(
                    icon: Icon(
                      Icons.arrow_forward_ios_outlined,
                    ),
                  ),
                  dropdownStyleData: DropdownStyleData(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                              width: 2, color: AppColors.mainBlueDarkColor))),
                  items: _coffeeTypes.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(color: Colors.black87),
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedCoffee = newValue!;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildSelectorRow('Sugar', Icons.cake, _sugarAmount, (newValue) {
              setState(() {
                _sugarAmount = newValue;
              });
            }),
            SizedBox(height: 20),
            _buildSelectorRow('Milk', Icons.local_drink, _milkAmount,
                (newValue) {
              setState(() {
                _milkAmount = newValue;
              });
            }),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.all(Dimensions.width15),
              child: TextField(
                maxLines: 5,
                controller: _textController,
                decoration: InputDecoration(
                  hintText: ' - Pizza margarita\n - Pizza mješana'
                      '\n - Sendvič piletina sir',
                  filled: true,
                  fillColor: Colors.grey[300],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Dimensions.radius20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _submitOrder,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: AppColors.mainBlueColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: const Text(
                'Submit',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectorRow(
      String label, IconData icon, int value, ValueChanged<int> onChanged) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.deepPurple),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.white),
                SizedBox(width: 10),
                Text(
                  label,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove, color: Colors.white),
                  onPressed: () {
                    if (value > 0) {
                      onChanged(value - 1);
                    }
                  },
                ),
                Text(
                  value.toString(),
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                IconButton(
                  icon: Icon(Icons.add, color: Colors.white),
                  onPressed: () {
                    if (value < 5) {
                      onChanged(value + 1);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _submitOrder() {
    String enteredText = _textController.text;
    print('Entered text: $enteredText');
    print('Entered eventId: ${widget.eventId}');

    Map<String, dynamic> orderDetails = {
      'coffee': _selectedCoffee,
      'sugar': _sugarAmount,
      'milk': _milkAmount,
      'additionalInstructions': enteredText,
    };

    widget.orderController
        .createOrder(OrderBody(
      eventId: widget.eventId,
      additionalOptions: {"orderDetails": orderDetails},
    ))
        .then((status) {
      if (status.isSuccess) {
        print("Success order creation");
        showCustomSnackBar("Successfully created an order",
            isError: false,
            title: "Order submitted",
            color: AppColors.mainBlueColor);
        Get.offNamed(RouteHelper.getInitial());
      } else if (status.message == "409") {
        showCustomSnackBar("You already submitted your order",
            isError: false, title: "Duplicate orders");
      } else {
        showCustomSnackBar(status.message);
      }
    });
  }
}
