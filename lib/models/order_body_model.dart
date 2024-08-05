class OrderBody {
  String eventId;
  Map<String, dynamic> additionalOptions;

  OrderBody({
    required this.eventId,
    required this.additionalOptions,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["eventId"] = eventId;
    data["additionalOptions"] = additionalOptions;

    return data;
  }

  factory OrderBody.fromJson(Map<String, dynamic> json) {
    return OrderBody(
      eventId: json['eventId'],
      additionalOptions: json['additionalOptions'],
    );
  }
}
