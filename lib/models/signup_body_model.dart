class SignupBody{
  String email;
  String password;
  String name;
  String surname;
  SignupBody({
    required this.email,
    required this.password,
    required this.name,
    required this.surname,
});

  Map<String,dynamic> toJson(){
    final Map<String,dynamic> data = <String,dynamic>{};
    data["email"] = email;
    data["password"] = password;
    data["firstName"] = name;
    data["lastName"] = surname;
    return data;
  }
}