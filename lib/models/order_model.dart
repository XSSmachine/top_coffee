
class OrderModel {
  String eventId;
  String orderId;
  String? userProfileId;
  String title;
  String? description;
  String groupId;
  String status;
  String eventType;
  DateTime createdAt;

  OrderModel({
    required this.eventId,
    required this.orderId,
    required this.userProfileId,
    required this.title,
    required this.description,
    required this.groupId,
    required this.status,
    required this.eventType,
    required this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      eventId: json['eventId'],
      orderId: json['orderId'],
      userProfileId: json['userProfileId'],
      title: json['title'],
      description: json['description'],
      groupId: json['groupId'],
      status: json['status'],
      eventType: json['eventType'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'eventId': eventId,
      'orderId': orderId,
      'userProfileId': userProfileId,
      'title': title,
      'description': description,
      'groupId': groupId,
      'status': status,
      'eventType': eventType,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
