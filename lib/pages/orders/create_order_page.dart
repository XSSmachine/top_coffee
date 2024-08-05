import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:team_coffee/controllers/order_controller.dart';
import 'package:team_coffee/models/order_body_model.dart';
import 'package:team_coffee/pages/orders/all_orders_screen.dart';

import '../../base/show_custom_snackbar.dart';
import '../../routes/route_helper.dart';
import '../../utils/colors.dart';

/// This class displays a form which user fills to create new order
/// IDEA: To display different forms for different eventType
class CoolTextFieldScreen extends StatefulWidget {
  final String eventId;
  final String eventType;
  CoolTextFieldScreen({
    super.key,
    required this.eventId,
    required this.eventType,
  });

  @override
  _CoolTextFieldScreenState createState() => _CoolTextFieldScreenState();
}

class _CoolTextFieldScreenState extends State<CoolTextFieldScreen> {
  final TextEditingController _textController = TextEditingController();
  final OrderController orderController = Get.find<OrderController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Create new order'),
      ),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _textController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: 'Write what you want...',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Handle button press
                  String enteredText = _textController.text;
                  print('Entered text: $enteredText');
                  print('Entered eventId: ${widget.eventId}');
                  orderController
                      .createOrder(OrderBody(
                          eventId: widget.eventId,
                          additionalOptions: {"orderDetails": enteredText}))
                      .then((status) {
                    if (status.isSuccess) {
                      print("Success order creation");
                      showCustomSnackBar("Successfully created an order",
                          isError: false,
                          title: "Order submitted",
                          color: AppColors.mainBlueColor);
                      Get.toNamed(RouteHelper.getInitial());
                    } else if (status.message == "409") {
                      showCustomSnackBar("You already submitted your order",
                          isError: false, title: "Duplicate orders");
                    } else {
                      showCustomSnackBar(status.message);
                    }
                  });
                },
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
      ),
    );
  }
}
