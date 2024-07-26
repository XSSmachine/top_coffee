class UserModel{
  String? id;
  String name;
  String surname;
  String? groupId;
  double? score;


  UserModel({
    required this.id,
    required this.name,
    required this.surname,
    required this.groupId,
    required this.score,
  });


  factory UserModel.fromJson(Map<String,dynamic> json){
    return UserModel(
        id: json['userId'],
        name: json['firstName'],
        surname: json['lastName'],
        score: json['score'],
        groupId: json['groupId'],
        );
  }
}