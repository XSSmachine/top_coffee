class JwtModel{
  String id;
  String? email;



  JwtModel({
    required this.id,
    required this.email,
  });


  factory JwtModel.fromJson(Map<String,dynamic> json){
    return JwtModel(
        id: json['userId'],
        email: json['sub'],);
  }
}