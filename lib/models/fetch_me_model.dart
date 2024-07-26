class FetchMeModel{
  String email;
  String name;
  String surname;
  String? profileUri;


  FetchMeModel({
    required this.email,
    required this.name,
    required this.surname,
    this.profileUri
  });


  factory FetchMeModel.fromJson(Map<String,dynamic> json){
    return FetchMeModel(
        email: json['email'],
        name: json['firstName'],
        surname: json['lastName'],
        profileUri: json['profileUri'],
        );
  }
}