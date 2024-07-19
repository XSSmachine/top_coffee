class JwtModel{
  String id;
  String name;
  String surname;
  String? email;



  JwtModel({
    required this.id,
    required this.name,
    required this.surname,
    required this.email,
  });


  factory JwtModel.fromJson(Map<String,dynamic> json){
    return JwtModel(
        id: json['userId'],
        name: json['firstName'],
        surname: json['lastName'],
        email: json['sub'],);
  }
}