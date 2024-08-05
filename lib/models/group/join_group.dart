class JoinGroup{
  String name;
  String password;
  JoinGroup({
    required this.name,
    required this.password
  });

  Map<String,dynamic> toJson(){
    final Map<String,dynamic> data = <String,dynamic>{};
    data["name"] = name;
    data["password"] = password;
    return data;
  }
}