import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:team_coffee/controllers/event_controller.dart';
import 'package:team_coffee/utils/dimensions.dart';
import 'package:team_coffee/widgets/current_event_widget.dart';
import 'package:team_coffee/widgets/event_type_chip.dart';

import '../../base/no_data_page.dart';
import '../../controllers/order_controller.dart';
import '../../controllers/user_controller.dart';
import '../../models/event_model.dart';
import '../../models/order_model.dart';
import '../../routes/route_helper.dart';
import '../../utils/colors.dart';
import '../../widgets/icon_and_text_widget.dart';

/// This class displays all events that user placed order on and also will display current
/// event which user created + all past completed events and orders
class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool isActive = true;
  bool showCurrentEvent = false;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    print(isActive.toString());
    await Get.find<OrderController>().getAllMyOrdersByStatus(isActive);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.only(top: Dimensions.height20 * 3),
            height: Dimensions.height30 * 4.8,
            decoration: BoxDecoration(
              color: AppColors.mainPurpleColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(Dimensions.radius20),
                bottomRight: Radius.circular(Dimensions.radius20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10.0,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: AnimatedToggleSwitch<bool>.size(
                  current: isActive,
                  values: const [true, false],
                  iconOpacity: 0.8,
                  indicatorSize: Size.fromWidth(Dimensions.width30 * 5),
                  customIconBuilder: (context, local, global) => Text(
                    local.value ? 'Active' : 'Completed',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: Dimensions.font16 - 2,
                      color: Colors.black,
                    ),
                  ),
                  borderWidth: 4.6,
                  iconAnimationType: AnimationType.onHover,
                  style: ToggleStyle(
                    indicatorColor: AppColors.mainPurpleColor,
                    borderColor: Colors.transparent,
                    backgroundColor: Colors.white,
                    borderRadius: BorderRadius.circular(30.0),
                    boxShadow: [
                      const BoxShadow(
                        color: Colors.black26,
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: Offset(0, 1.5),
                      ),
                    ],
                  ),
                  selectedIconScale: 1.0,
                  onChanged: (value) {
                    setState(() {
                      isActive = value;
                    });
                    _fetchOrders();
                  },
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                showCurrentEvent = !showCurrentEvent;
              });
            },
            child: Container(
              width: Dimensions.screenWidth / 3,
              height: Dimensions.height30,
              decoration: const BoxDecoration(color: Colors.white),
              child: Text(
                "    Click here !",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: Dimensions.font16,
                ),
              ),
            ),
          ),
          if (showCurrentEvent)
            FutureBuilder<EventModel>(
              future: Get.find<EventController>().getActiveEvent(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final currentEvent = snapshot.data;

                  if (currentEvent != null) {
                    return CurrentEventWidget(event: currentEvent);
                  } else {
                    return const SizedBox();
                  }
                }
              },
            ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _fetchOrders,
              child: GetBuilder<OrderController>(
                builder: (orderController) {
                  final orders = isActive
                      ? orderController.activeOrders
                      : orderController.completedOrders;
                  return orders.isEmpty
                      ? Center(
                          child: NoDataPage(
                          text: "There is no orders to display...",
                        ))
                      : ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: orders.length,
                          itemBuilder: (context, index) {
                            final order = orders[index];
                            return OrderCard(
                              status: order.status,
                              time: order.createdAt.toString(),
                              name: order.title,
                              foodType: order.eventType,
                              onTap: () {
                                Get.toNamed(
                                  RouteHelper.getEventDetail(
                                    order.eventId,
                                    "orders",
                                    order.orderId,
                                  ),
                                );
                              },
                            );
                          },
                        );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final String status;
  final String time;
  final String name;
  final String foodType;
  final VoidCallback onTap;

  const OrderCard(
      {super.key,
      required this.status,
      required this.time,
      required this.name,
      required this.foodType,
      required this.onTap});

  double _getProgressValue() {
    switch (status) {
      case 'PENDING':
        return 0.33;
      case 'IN_PROGRESS':
        return 0.66;
      case 'COMPLETED':
        return 1.0;
      default:
        return 0.0;
    }
  }

  String _getImagePath(String eventType) {
    switch (eventType) {
      case "FOOD":
        return 'assets/image/burek.png';
      case "COFFEE":
        return 'assets/image/turska.png';
      case "BEVERAGE":
        return 'assets/image/pice.png';
      default:
        return 'assets/image/placeholder.jpg'; // Fallback image
    }
  }

  @override
  Widget build(BuildContext context) {
    final value = _getProgressValue();
    final _formatter = DateFormat('yyyy-MM-dd HH:mm');
    ;
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 22.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(minHeight: 200), // Provide a minimum height
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Allow the column to shrink
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: Dimensions.width20),
                  height: 20,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(Dimensions.radius20),
                  ),
                  child: Stack(
                    //fit: StackFit.expand, // Ensure stack fills its container
                    children: [
                      LinearProgressIndicator(
                        value: value,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.mainPurpleColor),
                        backgroundColor: Colors.transparent,
                        minHeight: Dimensions.height20,
                        borderRadius:
                            BorderRadius.circular(Dimensions.radius20),
                      ),
                      LayoutBuilder(
                        builder: (context, constrains) {
                          var leftPadding = constrains.maxWidth * value -
                              Dimensions.iconSize16 -
                              5;
                          var topPadding =
                              (constrains.maxHeight - Dimensions.iconSize16) /
                                  2;
                          return Padding(
                            padding: EdgeInsets.only(
                                left: leftPadding, top: topPadding),
                            child: Icon(
                              Icons.rocket_launch_sharp,
                              color: Colors.white,
                              size: Dimensions.iconSize16.toDouble(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: Dimensions.height10 / 3,
                ),
                Padding(
                  padding: EdgeInsets.only(left: Dimensions.width20),
                  child: Text(
                    status.replaceAll("_", " "),
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                const Divider(),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.width15,
                      vertical: Dimensions.height10),
                  child: Row(
                    children: [
                      Container(
                        width: Dimensions.height30 * 3.7,
                        height: Dimensions.height30 * 3.7,
                        decoration: BoxDecoration(
                          color: AppColors.mainPurpleColor,
                          borderRadius:
                              BorderRadius.circular(Dimensions.radius30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 5.0,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(Dimensions.radius30),
                          child: Image.asset(
                            _getImagePath(foodType ?? "FOOD"),
                            width: Dimensions.height30 * 3.5,
                            height: Dimensions.height30 * 3.5,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: Dimensions.width15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.event, color: Colors.green),
                                const SizedBox(width: 5),
                                Flexible(
                                    child: Text(_formatter
                                        .format(DateTime.parse(time)))),
                              ],
                            ),
                            SizedBox(
                              height: Dimensions.height10,
                            ),
                            Row(
                              children: [
                                const Icon(Icons.label_important_sharp,
                                    color: Colors.deepOrangeAccent),
                                const SizedBox(width: 5),
                                Flexible(child: Text(name)),
                              ],
                            ),
                            SizedBox(
                              height: Dimensions.height10 / 2,
                            ),
                            Row(
                              children: [
                                const SizedBox(width: 5),
                                if (foodType == "COFFEE")
                                  FilterChip(
                                    label: const IconAndTextWidget(
                                      icon: Icons.coffee,
                                      text: "COFFEE",
                                      iconColor: Colors.white,
                                      isSmaller: true,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      side: const BorderSide(
                                          color: AppColors.orangeChipColor),
                                    ),
                                    backgroundColor: AppColors.orangeChipColor,
                                    onSelected: (bool value) {},
                                    selected: false,
                                  )
                                else if (foodType == "FOOD")
                                  FilterChip(
                                    label: const IconAndTextWidget(
                                      icon: Icons.restaurant,
                                      text: "FOOD",
                                      iconColor: Colors.white,
                                      isSmaller: true,
                                    ),
                                    backgroundColor: AppColors.greenChipColor,
                                    onSelected: (bool value) {},
                                    selected: false,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      side: const BorderSide(
                                          color: AppColors.greenChipColor),
                                    ),
                                  )
                                else
                                  FilterChip(
                                    label: const IconAndTextWidget(
                                      icon: Icons.liquor,
                                      text: "BEVERAGES",
                                      iconColor: Colors.white,
                                      isSmaller: true,
                                    ),
                                    backgroundColor: AppColors.blueChipColor,
                                    onSelected: (bool value) {},
                                    selected: false,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      side: const BorderSide(
                                          color: AppColors.blueChipColor),
                                    ),
                                  ),
                                const SizedBox(width: 8.0),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                GestureDetector(
                  onTap: onTap,
                  child: Container(
                    margin: EdgeInsets.all(Dimensions.width10 * 1.2),
                    padding: EdgeInsets.all(Dimensions.width15 / 2.3),
                    decoration: BoxDecoration(
                      color: AppColors.mainPurpleColor,
                      borderRadius: BorderRadius.circular(Dimensions.radius20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10.0,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Center(
                        child: Text(
                      "Order details",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: Dimensions.font16,
                          fontWeight: FontWeight.w500),
                    )),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
