import 'order_model.dart';

class Event {
final String id;
final String creatorId;
final String creatorName;
String status;
final int startTime;
DateTime? endTime;
final List<String> participants;
final List<Order> orders;
bool? orderPlaced;


Event( {
  required this.id,
  required this.creatorId,
  required this.creatorName,
  required this.status,
  required this.startTime,
  this.endTime,
  required this.participants,
  required this.orders,
  this.orderPlaced,

});

@override
String toString() {
  return 'Event(id: $id, creatorId: $creatorId, creatorName: $creatorName, status: $status, startTime: $startTime, endTime: $endTime, participants: $participants, orders: $orders, orderPlaced: $orderPlaced)';
}


  void setOrderPlaced(bool value) {
    this.orderPlaced = value;
  }

}


class Order {
  final String userId;
  final String coffeeType;
  final int milkQuantity;
  final int sugarQuantity;
  final int? rating;

  Order({
    required this.userId,
    required this.coffeeType,
    required this.milkQuantity,
    required this.sugarQuantity,
     this.rating,
  });
}