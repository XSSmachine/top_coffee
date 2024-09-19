class UserProfileModel {
  String? userId;
  String name;
  String surname;

  UserProfileModel({
    required this.userId,
    required this.name,
    required this.surname,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      userId: json['userId'],
      name: json['firstName'],
      surname: json['lastName'],
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["firstName"] = name;
    data["userId"] = userId;
    data["lastName"] = surname;

    return data;
  }
}
