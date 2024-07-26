class JoinGroup{
  String name;
  String password;
  JoinGroup({
    required this.name,
    required this.password
  });

  Map<String,dynamic> toJson(){
    final Map<String,dynamic> data = new Map<String,dynamic>();
    data["name"] = this.name;
    data["password"] = this.password;
    return data;
  }
}