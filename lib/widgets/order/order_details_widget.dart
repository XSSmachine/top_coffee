import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team_coffee/utils/dimensions.dart';
import 'package:team_coffee/widgets/home/order_rating_widget.dart';
import 'package:team_coffee/widgets/order/rate_order_widget.dart';

import '../../controllers/order_controller.dart';
import '../../utils/colors.dart';

class OrderDetailsWidget extends StatefulWidget {
  final String orderId;
  final String eventStatus;

  const OrderDetailsWidget(
      {Key? key, required this.orderId, required this.eventStatus})
      : super(key: key);

  @override
  _OrderDetailsWidgetState createState() => _OrderDetailsWidgetState();
}

class _OrderDetailsWidgetState extends State<OrderDetailsWidget> {
  bool _isCancelled = false;
  late Future<void> _orderFuture;
  final OrderController controller = Get.find<OrderController>();

  String _formatAdditionalOptions(Map<String, dynamic> additionalOptions) {
    if (additionalOptions == null || additionalOptions.isEmpty) {
      return "• No additional options";
    }

    try {
      // Parse the string as a JSON object
      //final Map<String, dynamic> options = json.decode(additionalOptions);

      List<String> formattedOptions = [];

      additionalOptions.forEach((key, value) {
        if (value != null && value.toString().isNotEmpty) {
          formattedOptions.add("• $key: $value");
        }
      });

      return formattedOptions.join('\n').replaceAll("description", "opis");
    } catch (e) {
      // Handle parsing errors
      print("Error parsing additional options: $e");
      return "• Error: Unable to parse additional options";
    }
  }

  @override
  void initState() {
    super.initState();
    _orderFuture = controller.getSingleOrder(widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _orderFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Stack(
            children: [
              Container(
                width: double.maxFinite,
                padding: EdgeInsets.only(
                  left: Dimensions.height20,
                  right: Dimensions.height20,
                  bottom: Dimensions.height20,
                  top: Dimensions.height10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.mainBlueColor,
                  borderRadius: BorderRadius.circular(Dimensions.radius15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'MY ORDER'.tr,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: Dimensions.font20,
                          ),
                        ),
                        controller.currentOrder!.status != "CANCELLED" &&
                                widget.eventStatus == "PENDING"
                            ? ElevatedButton(
                                onPressed: _isCancelled
                                    ? null
                                    : () {
                                        controller.updateOrderStatus(
                                            widget.orderId, "CANCELLED");
                                        setState(() {
                                          _isCancelled = true;
                                        });
                                      },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: const Text('CANCEL'),
                              )
                            : controller.currentOrder!.status == "COMPLETED" &&
                                    widget.eventStatus == "COMPLETED" &&
                                    controller.currentOrder!.rating == 0
                                ? ElevatedButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return RateOrderWidget(
                                            onSubmit: (rating) {
                                              // Handle the submitted rating
                                              controller.rateOrder(
                                                  widget.orderId,
                                                  rating.toInt());
                                              // You can add your logic here, like sending the rating to a server
                                            },
                                          );
                                        },
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.amber,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: const Text(
                                      'RATE',
                                      style: TextStyle(color: Colors.black87),
                                    ),
                                  )
                                : controller.currentOrder!.status ==
                                            "COMPLETED" &&
                                        widget.eventStatus == "COMPLETED" &&
                                        controller.currentOrder!.rating != 0
                                    ? Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: List.generate(5, (index) {
                                          return Icon(
                                            Icons.star,
                                            color: index <
                                                    controller
                                                        .currentOrder!.rating!
                                                ? Colors.amber
                                                : Colors.grey,
                                            size: 24,
                                          );
                                        }),
                                      )
                                    : SizedBox.shrink()
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _formatAdditionalOptions(
                          controller.currentOrder!.additionalOptions!),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'STATUS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Dimensions.font16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          _isCancelled
                              ? "CANCELLED"
                              : controller.currentOrder!.status!
                                      .replaceAll("_", " ")
                                      .tr ??
                                  "Null",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (_isCancelled ||
                  controller.currentOrder!.status == "CANCELLED")
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(Dimensions.radius15),
                    ),
                    child: Center(
                      child: Text(
                        'CANCELLED',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Dimensions.font26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ); // Your existing widget tree
        }
      },
    );
  }
}
