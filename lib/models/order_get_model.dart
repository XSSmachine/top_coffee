class OrderGetModel{
  late String _userProfileId;
  late String? _status;
  late Map<String,dynamic>? _additionalOptions;
  late int? _rating;
  late String? _createdAt;

  OrderGetModel({
    userProfileId,
    status,
    additionalOptions,
    rating,
    createdAt

  }){
    _userProfileId= userProfileId;
    _status=status;
    _additionalOptions=additionalOptions;
    _rating=rating;
    _createdAt=createdAt;




  }

  String? get userProfileId=>_userProfileId;

  String? get status=>_status;
  Map<String,dynamic>? get additionalOptions=>_additionalOptions;
  int? get rating => _rating;
  String? get createdAt=>_createdAt;



  OrderGetModel.fromJson(Map<String,dynamic> json){
    _userProfileId=json['userProfileId'];
    _status=json["status"]??"";
    _additionalOptions=json["additionalOptions"]??"";
    _rating=json["rating"];
    _createdAt=json["createdAt"];

  }

  Map<String,dynamic> toJson(){
    final Map<String, dynamic> data= <String, dynamic>{};
    data['userProfileId']=_userProfileId;
    data['status']=_status;
    data['additionalOptions']=_additionalOptions;
    data['rating']=_rating;
    data['cratedAt']=_createdAt;
    return data;

  }
}