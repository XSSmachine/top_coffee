import 'order_model.dart';

class EventModel{
  late String? _id;
  late String _creator;
  late String? _startTime;
  late String? _status;
  late int _pendingTime;
  late List<String> _orders;



  EventModel({
    id,
    required creator,
    startTime,
    status,
    pendingTime,
    orders,
  }){
    _id=id;
    _creator = creator;
    _startTime = startTime;
    _status=status;
    _pendingTime=pendingTime;
    _orders=orders;

  }

  String? get id=>_id;
  String get creator=>_creator;
  String? get startTIme=>_startTime;
  String? get status=>_status;
  int get pendingTime => _pendingTime;
  List<String> get orders=>_orders;


  EventModel.fromJson(Map<String,dynamic> json){
    _id=json['eventId'];
    _creator=json["userId"]??"";
    _startTime=json["startTime"]??"";
    _status=json["status"]??"";
    _pendingTime=json["pendingTime"];
    if (json['orderIds'] != null) {
      _orders = <String>[];
      json['orderIds'].forEach((v) {
        _orders.add(v.toString());
      });
    }
  }

  Map<String,dynamic> toJson(){
    final Map<String, dynamic> data= Map<String, dynamic>();
    data['_id']=this._id;
    data['userId']=this._creator;
    data['startTime']=this._startTime;
    data['pendingTime']=this._pendingTime;
    data['orderIds']=this._orders;
    data['status']=this._status;
    return data;

  }
}