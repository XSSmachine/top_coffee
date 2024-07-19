class OrderGetModel{
  late String _id;
  late String? _type;
  late int? _sugarQuantity;
  late int? _milkQuantity;


  OrderGetModel({
    id,
    type,
    sugarQuantity,
    milkQuantity,

  }){
    _id=id;
    _type = type;
    _sugarQuantity=sugarQuantity;
    _milkQuantity=milkQuantity;


  }

  String? get id=>_id;

  String? get type=>_type;
  int? get sugarQuantity=>_sugarQuantity;
  int? get milkQuantity => _milkQuantity;



  OrderGetModel.fromJson(Map<String,dynamic> json){
    _id=json['coffeeOrderId'];
    _type=json["type"]??"";
    _sugarQuantity=json["sugarQuantity"]??"";
    _milkQuantity=json["milkQuantity"];

  }

  Map<String,dynamic> toJson(){
    final Map<String, dynamic> data= Map<String, dynamic>();
    data['coffeeOrderId']=this._id;
    data['type']=this._type;
    data['sugarQuantity']=this._sugarQuantity;
    data['milkQuantity']=this._milkQuantity;
    return data;

  }
}