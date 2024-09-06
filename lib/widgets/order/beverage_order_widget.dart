import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../base/show_custom_snackbar.dart';
import '../../controllers/event_controller.dart';
import '../../controllers/order_controller.dart';
import '../../models/filter_model.dart';
import '../../models/order_body_model.dart';
import '../../routes/route_helper.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';

class BeverageOrderScreen extends StatefulWidget {
  final String eventId;
  final OrderController orderController;

  const BeverageOrderScreen({
    Key? key,
    required this.eventId,
    required this.orderController,
  }) : super(key: key);

  @override
  _BeverageOrderScreenState createState() => _BeverageOrderScreenState();
}

class _BeverageOrderScreenState extends State<BeverageOrderScreen> {
  EventController eventController = Get.find<EventController>();
  final List<Map<String, dynamic>> beverages = [
    {'name': 'Beer', 'icon': Icons.sports_bar, 'color': Colors.amber},
    {'name': 'Wine', 'icon': Icons.wine_bar, 'color': Colors.redAccent},
    {'name': 'Cocktail', 'icon': Icons.local_bar, 'color': Colors.pinkAccent},
    {
      'name': 'Soda',
      'icon': Icons.local_drink,
      'color': Colors.deepOrangeAccent
    },
    {'name': 'Water', 'icon': Icons.water_drop, 'color': Colors.blueAccent},
    {'name': 'Juice', 'icon': Icons.local_cafe, 'color': Colors.orangeAccent},
  ];
  Set<String> selectedBeverages = {};
  final TextEditingController _additionalInfoController =
      TextEditingController();

  @override
  void dispose() {
    _additionalInfoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(Dimensions.height20 * 3),
        child: AppBar(
          backgroundColor: AppColors.mainBlueColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(Dimensions.radius20),
            ),
          ),
          title: Text(
            'Beverage Order',
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: beverages.length,
                itemBuilder: (context, index) {
                  return _buildBeverageButton(beverages[index]);
                },
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Additional specifications:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.width10),
              child: TextField(
                maxLines: 5,
                controller: _additionalInfoController,
                decoration: InputDecoration(
                  hintText: ' - Sok od bazge\n - Kanta leda'
                      '\n - Pina colada',
                  filled: true,
                  fillColor: Colors.grey[300],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Dimensions.radius20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitOrder,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: AppColors.mainBlueColor,
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
          ],
        ),
      ),
    );
  }

  Widget _buildBeverageButton(Map<String, dynamic> beverage) {
    bool isSelected = selectedBeverages.contains(beverage['name']);
    return ElevatedButton(
      onPressed: () {
        setState(() {
          if (isSelected) {
            selectedBeverages.remove(beverage['name']);
          } else {
            selectedBeverages.add(beverage['name']);
          }
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 50,
            width: 50,
            child: Stack(children: [
              Positioned.fill(
                  child: Align(
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: new BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                ),
                alignment: Alignment.center,
              )),
              Positioned.fill(
                child: Icon(
                  beverage['icon'],
                  color: beverage['color'],
                  size: 32,
                ),
              )
            ]),
          ),
          SizedBox(height: 8),
          Text(
            beverage['name'],
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      style: ElevatedButton.styleFrom(
        foregroundColor: isSelected ? beverage['color'] : Colors.white,
        backgroundColor: !isSelected
            ? Colors.white
            : AppColors.mainBlueColor.withOpacity(0.8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: isSelected ? 8 : 2,
      ),
    );
  }

  void _submitOrder() {
    if (selectedBeverages.isEmpty) {
      showCustomSnackBar("Please select at least one beverage",
          title: "Empty order");
      return;
    }

    Map<String, dynamic> orderDetails = {
      'description': selectedBeverages.toList(),
      'additionalInfo': _additionalInfoController.text,
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
        showCustomSnackBar(
          "Successfully created an order",
          isError: false,
          title: "Order submitted",
          color: AppColors.mainBlueColor,
        );
        Get.offNamed(RouteHelper.getInitial());
      } else if (status.message == "409") {
        showCustomSnackBar(
          "You already submitted your order",
          isError: false,
          title: "Duplicate orders",
        );
      } else {
        showCustomSnackBar(status.message);
      }
    });
  }
}
