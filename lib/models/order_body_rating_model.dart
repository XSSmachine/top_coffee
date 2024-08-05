class OrderBodyRating{
  String orderId;
  int ratingUpdate;


  OrderBodyRating({

    required this.orderId,
    required this.ratingUpdate,

  });

  Map<String,dynamic> toJson(){
    final Map<String,dynamic> data = <String,dynamic>{};
    data["coffeeOrderId"] = orderId;
    data["ratingUpdate"] = ratingUpdate;

    return data;
  }
}