class SignupBody{
  String name;
  String surname;
  String email;
  String password;
  SignupBody({
    required this.name,
    required this.surname,
    required this.email,
    required this.password
});

  Map<String,dynamic> toJson(){
    final Map<String,dynamic> data = new Map<String,dynamic>();
    data["firstName"] = this.name;
    data["lastName"] = this.surname;
    data["email"] = this.email;
    data["password"] = this.password;
    return data;
  }
}