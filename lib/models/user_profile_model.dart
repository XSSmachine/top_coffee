class UserProfileModel{
  String? userId;
  String name;
  String surname;
  String? groupId;


  UserProfileModel({
    required this.userId,
    required this.name,
    required this.surname,
    required this.groupId,
  });


  factory UserProfileModel.fromJson(Map<String,dynamic> json){
    return UserProfileModel(
        userId: json['userId'],
        name: json['firstName'],
        surname: json['lastName'],
        groupId: json['groupId'],
        );
  }
  Map<String,dynamic> toJson(){
    final Map<String,dynamic> data = new Map<String,dynamic>();
    data["firstName"] = this.name;
    data["userId"] = this.userId;
    data["lastName"] = this.surname;
    data["groupId"] = this.groupId;
    return data;
  }
}