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
    final Map<String,dynamic> data = new Map<String,dynamic>();
    data["name"] = this.name;
    data["description"] = this.description;
    data["password"] = this.password;
    return data;
  }
}