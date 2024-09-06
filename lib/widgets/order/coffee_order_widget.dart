import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../base/show_custom_snackbar.dart';
import '../../controllers/event_controller.dart';
import '../../controllers/order_controller.dart';
import '../../models/filter_model.dart';
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
  EventController eventController = Get.find<EventController>();

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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(Dimensions.height20 * 3),
        child: AppBar(
          backgroundColor: AppColors.mainBlueMediumColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(Dimensions.radius20),
            ),
          ),
          title: Text(
            'Coffee Order',
            style: TextStyle(
              color: Colors.white,
              fontSize: Dimensions.font20,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: Dimensions.width10, vertical: Dimensions.height15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: Dimensions.width10,
                  vertical: Dimensions.height15),
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius30),
                  border:
                      Border.all(width: 2, color: AppColors.candyPurpleColor)),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.width15,
                    vertical: Dimensions.height10 / 2),
                child: DropdownButton2<String>(
                  isExpanded: true,
                  underline: SizedBox(),
                  value: _selectedCoffee,
                  iconStyleData: const IconStyleData(
                    icon: Icon(
                      CupertinoIcons.chevron_down,
                    ),
                  ),
                  dropdownStyleData: DropdownStyleData(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.width10,
                          vertical: Dimensions.height10 / 2),
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(Dimensions.radius30),
                          border: Border.all(
                              width: 2, color: AppColors.candyPurpleColor))),
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
            SizedBox(height: Dimensions.height20),
            _buildSelectorRow(
                'Sugar',
                ImageIcon(
                  AssetImage("assets/image/honey-01.png"),
                  color: AppColors.mainBlueDarkColor,
                ),
                _sugarAmount, (newValue) {
              setState(() {
                _sugarAmount = newValue;
              });
            }),
            SizedBox(height: Dimensions.height20),
            _buildSelectorRow(
                'Milk',
                ImageIcon(
                  AssetImage("assets/image/milk-bottle.png"),
                  color: AppColors.mainBlueDarkColor,
                ),
                _milkAmount, (newValue) {
              setState(() {
                _milkAmount = newValue;
              });
            }),
            SizedBox(height: Dimensions.height20),
            Padding(
              padding: EdgeInsets.all(Dimensions.width10),
              child: TextField(
                maxLines: 5,
                controller: _textController,
                decoration: InputDecoration(
                  hintText: ' - Bez laktoze\n - S ledom'
                      '\n - Tona šećera',
                  filled: true,
                  fillColor: Colors.grey[300],
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Dimensions.radius20),
                    borderSide:
                        BorderSide(color: AppColors.candyPurpleColor, width: 3),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Dimensions.radius20),
                    borderSide:
                        BorderSide(color: AppColors.candyPurpleColor, width: 3),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.width10),
              child: ElevatedButton(
                onPressed: _submitOrder,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: AppColors.mainBlueMediumColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Dimensions.radius30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectorRow(
      String label, ImageIcon icon, int value, ValueChanged<int> onChanged) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.width10),
      child: Stack(
        children: [
          // First container (label and icon)
          Container(
            height: Dimensions.height15 * 3.8,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.candyPurpleColor, width: 2),
              borderRadius: BorderRadius.circular(Dimensions.radius30),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                  left: Dimensions.width15, right: Dimensions.width20 * 5),
              child: Row(
                children: [
                  icon,
                  SizedBox(width: 10),
                  Text(
                    label,
                    style: TextStyle(
                        color: AppColors.mainBlueDarkColor, fontSize: 18),
                  ),
                ],
              ),
            ),
          ),

          // Second container (value selector)
          Positioned(
            right: 0,
            child: Container(
              height: Dimensions.height15 * 3.8,
              width: Dimensions.width20 * 6.5,
              decoration: BoxDecoration(
                color: AppColors.candyPurpleColor,
                borderRadius: BorderRadius.circular(Dimensions.radius30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
            ),
          ),
        ],
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
      'description': enteredText,
    };

    widget.orderController
        .createOrder(OrderBody(
      eventId: widget.eventId,
      additionalOptions: orderDetails,
    ))
        .then((status) {
      if (status.isSuccess) {
        eventController.eventsStream(
            "ALL",
            0,
            11,
            '',
            EventFilters(
                eventType: "ALL", status: ['PENDING'], timeFilter: ''));
        ;
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
