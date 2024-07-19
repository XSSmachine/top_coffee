class OrderModel{
  late String _id;
  late String _eventId;
  late String _userId;
  late String? _type;
  late int? _sugarQuantity;
  late int? _milkQuantity;
  late int? _rating;

  OrderModel({
    id,
    required eventId,
    required userId,
    type,
    sugarQuantity,
    milkQuantity,
    rating,
  }){
    _id=id;
    _eventId=eventId;
    _userId = userId;
    _type = type;
    _sugarQuantity=sugarQuantity;
    _milkQuantity=milkQuantity;
    _rating=rating;

  }

  String? get id=>_id;
  String get eventId=>_eventId;
  String get userId=>_userId;
  String? get type=>_type;
  int? get sugarQuantity=>_sugarQuantity;
  int? get milkQuantity => _milkQuantity;
  int? get rating=>_rating;


  OrderModel.fromJson(Map<String,dynamic> json){
    _id=json['coffeeOrderId'];
    _eventId=json["eventId"]??"";
    _userId=json["userId"]??"";
    _type=json["type"]??"";
    _sugarQuantity=json["sugarQuantity"]??"";
    _milkQuantity=json["milkQuantity"];
    _rating=json["rating"];
  }

  Map<String,dynamic> toJson(){
    final Map<String, dynamic> data= Map<String, dynamic>();
    data['coffeeOrderId']=this._id;
    data['eventId']=this._eventId;
    data['userId']=this._userId;
    data['type']=this._type;
    data['sugarQuantity']=this._sugarQuantity;
    data['milkQuantity']=this._milkQuantity;
    data['rating']=this._rating;
    return data;

  }
}