class UpdateGroupModel {
  String name;
  String desc;

  UpdateGroupModel({
    required this.name,
    required this.desc,
  });

  factory UpdateGroupModel.fromJson(Map<String, dynamic> json) {
    return UpdateGroupModel(
      name: json['name'],
      desc: json['description'],
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["firstName"] = name;
    data["description"] = desc;
    return data;
  }
}
