class OrderBodyRating{
  String orderId;
  int ratingUpdate;


  OrderBodyRating({

    required this.orderId,
    required this.ratingUpdate,

  });

  Map<String,dynamic> toJson(){
    final Map<String,dynamic> data = new Map<String,dynamic>();
    data["coffeeOrderId"] = this.orderId;
    data["ratingUpdate"] = this.ratingUpdate;

    return data;
  }
}