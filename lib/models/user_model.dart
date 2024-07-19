class UserModel{
  String? id;
  String name;
  String surname;
  String? email;
  String? password;
  int? coffeeNumber;
  double? score;


  UserModel({
    required this.id,
    required this.name,
    required this.surname,
    required this.email,
    required this.password,
    required this.coffeeNumber,
    required this.score,
  });


  factory UserModel.fromJson(Map<String,dynamic> json){
    return UserModel(
        id: json['_id'],
        name: json['firstName'],
        surname: json['lastName'],
        email: json['email'],
        password: json['password'],
        coffeeNumber: json['coffeeCounter'],
        score: json['coffeeRating']);
  }
}