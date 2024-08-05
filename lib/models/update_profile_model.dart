class UpdateProfileModel {
  String name;
  String surname;

  UpdateProfileModel({
    required this.name,
    required this.surname,
  });

  factory UpdateProfileModel.fromJson(Map<String, dynamic> json) {
    return UpdateProfileModel(
      name: json['firstName'],
      surname: json['lastName'],
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["firstName"] = name;
    data["lastName"] = surname;
    return data;
  }
}
