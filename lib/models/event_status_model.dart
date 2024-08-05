
class EventStatusModel{
  late String? _id;
  late String _creator;
  late String? _status;




  EventStatusModel({
    id,
    required creator,
    status,

  }){
    _id=id;
    _creator = creator;
    _status=status;


  }

  String? get id=>_id;
  String get creator=>_creator;
  String? get status=>_status;



  EventStatusModel.fromJson(Map<String,dynamic> json){
    _id=json['eventId'];
    _creator=json["userId"]??"";
    _status=json["status"]??"";

  }

  Map<String,dynamic> toJson(){
    final Map<String, dynamic> data= <String, dynamic>{};
    data['eventId']=_id;
    data['userId']=_creator;
    data['status']=_status;
    return data;

  }
}