import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../utils/string_resources.dart';
import 'extensions.dart';
import '../controllers/order_controller.dart';
import '../models/event_model.dart';
import '../models/my_orders_model.dart';
import '../models/order_model.dart';
import '../routes/route_helper.dart';
import '../utils/colors.dart';
import '../utils/dimensions.dart';

class CurrentEventWidget extends StatefulWidget {
  final EventModel event;

  const CurrentEventWidget({super.key, required this.event});

  @override
  _CurrentEventWidgetState createState() => _CurrentEventWidgetState();
}

class _CurrentEventWidgetState extends State<CurrentEventWidget> {
  double _shadowOpacity = 0.6;
  OrderController orderController = Get.find<OrderController>();
  int orders = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    fetchOrders();
    _startAnimationLoop();
    // Start periodic fetch
    _timer = Timer.periodic(Duration(seconds: 10), (timer) => fetchOrders());
  }

  @override
  void reassemble() {
    super.reassemble();
    fetchOrders();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startAnimationLoop() async {
    while (true) {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        _animateShadow();
      } else {
        break;
      }
    }
  }

  void _animateShadow() {
    setState(() {
      _shadowOpacity = _shadowOpacity == 0.6 ? 1.0 : 0.6;
    });
  }

  void fetchOrders() async {
    try {
      final orderList =
          await orderController.getAllOrdersForMyEvent(widget.event.eventId!);
      if (mounted) {
        setState(() {
          orders = orderList.length;
        });
      }
    } catch (e) {
      print('Error fetching orders: $e');
    }
  }

  String formatDate(String? dateString) {
    if (dateString == null) return 'Not specified';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd.MM.yyyy.').format(date);
    } catch (e) {
      return 'Invalid date';
    }
  }

  String formatStatus(String? status) {
    if (status == null) return 'Unknown';
    return status.split('_').map((word) => word.capitalized()).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimensions.width20),
      margin: EdgeInsets.symmetric(
          horizontal: Dimensions.width20, vertical: Dimensions.height10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.radius20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(Dimensions.width10),
                decoration: BoxDecoration(
                  color: AppColors.mainBlueDarkColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(Dimensions.radius15),
                ),
                child: Icon(Icons.event,
                    size: Dimensions.iconSize24,
                    color: AppColors.mainBlueDarkColor),
              ),
              SizedBox(width: Dimensions.width15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.event.title ?? "Title",
                      style: TextStyle(
                        fontSize: Dimensions.font20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: Dimensions.height10 / 2),
                    Text(
                      "${AppStrings.Date.tr}: ${formatDate(widget.event.createdAt)}",
                      style: TextStyle(
                        fontSize: Dimensions.font16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.width10,
                    vertical: Dimensions.height10 / 2),
                decoration: BoxDecoration(
                  color: _getStatusColor(widget.event.status),
                  borderRadius: BorderRadius.circular(Dimensions.radius15),
                ),
                child: Text(
                  formatStatus(widget.event.status).tr,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: Dimensions.font16 * 0.8,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: Dimensions.height15),
          Row(
            children: [
              _buildInfoChip(Icons.fastfood, widget.event.eventType ?? "Food",
                  Colors.green),
              SizedBox(width: Dimensions.width10),
              _buildInfoChip(Icons.people, "$orders ${AppStrings.Attendees.tr}",
                  Colors.orange),
            ],
          ),
          SizedBox(height: Dimensions.height15),
          ElevatedButton(
            onPressed: () {
              Get.toNamed(RouteHelper.getAllOrderPage(widget.event.eventId!));
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: AppColors.mainBlueDarkColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimensions.radius15),
              ),
              padding: EdgeInsets.symmetric(vertical: Dimensions.height15),
            ),
            child: Center(
              child: Text(
                AppStrings.viewMyOrders.tr,
                style: TextStyle(
                  fontSize: Dimensions.font16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width10, vertical: Dimensions.height10 / 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(Dimensions.radius15),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: Dimensions.iconSize16),
          SizedBox(width: Dimensions.width10 / 2),
          Text(
            label.tr,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: Dimensions.font16 * 0.8,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
