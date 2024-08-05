class UserModel {
  String? photoUri;
  String name;
  String surname;
  int? orderCount;
  double? score;

  UserModel({
    required this.photoUri,
    required this.name,
    required this.surname,
    required this.orderCount,
    required this.score,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      photoUri: json['photoUrl'],
      name: json['firstName'],
      surname: json['lastName'],
      score: json['score'],
      orderCount: json['orderCount'],
    );
  }
}
