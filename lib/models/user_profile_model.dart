class UserProfileModel{
  String? id;
  String name;
  String surname;
  String? email;
  String? password;
  int? coffeeNumber;
  double? score;


  UserProfileModel({
    required this.id,
    required this.name,
    required this.surname,
    required this.email,
    required this.password,
    required this.coffeeNumber,
    required this.score,
  });


  factory UserProfileModel.fromJson(Map<String,dynamic> json){
    return UserProfileModel(
        id: json['_id'],
        name: json['firstName'],
        surname: json['lastName'],
        email: json['email'],
        password: json['password'],
        coffeeNumber: json['coffeeNumber'],
        score: json['score']);
  }
}