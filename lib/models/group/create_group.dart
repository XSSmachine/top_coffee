class CreateGroup{
  String name;
  String description;
  String password;
  CreateGroup({
    required this.name,
    required this.description,
    required this.password
  });

  Map<String,dynamic> toJson(){
    final Map<String,dynamic> data = <String,dynamic>{};
    data["name"] = name;
    data["description"] = description;
    data["password"] = password;
    return data;
  }
}