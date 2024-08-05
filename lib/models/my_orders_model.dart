import 'package:intl/intl.dart';

enum OrderStatus {
  IN_PROGRESS,
  READY,
  CANCELLED
  // Add other status values as needed
}

class MyOrder {
  final String orderId;
  final String userProfileId;
  final String firstName;
  final String lastName;
  final Map<String, dynamic> additionalOptions;
  final OrderStatus status;
  final String createdAt;
  bool? isChecked;

  MyOrder({
    required this.orderId,
    required this.userProfileId,
    required this.firstName,
    required this.lastName,
    required this.additionalOptions,
    required this.status,
    required this.createdAt,
    this.isChecked,
  });

  factory MyOrder.fromJson(Map<String, dynamic> json) {
    return MyOrder(
      orderId: json['orderId'],
      userProfileId: json['userProfileId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      additionalOptions: json['additionalOptions'],
      status: OrderStatus.values.firstWhere(
        (e) => e.toString() == 'OrderStatus.${json['status']}',
        orElse: () => OrderStatus.IN_PROGRESS,
      ),
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'userProfileId': userProfileId,
      'firstName': firstName,
      'lastName': lastName,
      'additionalOptions': additionalOptions,
      'status': status.toString().split('.').last,
      'createdAt': createdAt,
    };
  }
}

class MyOrdersModel {
  final List<MyOrder> orders;

  MyOrdersModel({required this.orders});

  factory MyOrdersModel.fromJson(List<dynamic> json) {
    return MyOrdersModel(
      orders: json.map((orderJson) => MyOrder.fromJson(orderJson)).toList(),
    );
  }

  List<Map<String, dynamic>> toJson() {
    return orders.map((order) => order.toJson()).toList();
  }
}
