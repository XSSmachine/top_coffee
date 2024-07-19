class OrderBody{
  String eventId;
  String creatorId;
  String type;
  int sugarQuantity;
  int milkQuantity;

  OrderBody({
    required this.eventId,
    required this.creatorId,
    required this.type,
    required this.sugarQuantity,
    required this.milkQuantity
  });

  Map<String,dynamic> toJson(){
    final Map<String,dynamic> data = new Map<String,dynamic>();
    data["eventId"] = this.eventId;
    data["creatorId"] = this.creatorId;
    data["type"] = this.type;
    data["sugarQuantity"] = this.sugarQuantity;
    data["milkQuantity"] = this.milkQuantity;

    return data;
  }
}