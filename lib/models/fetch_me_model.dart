class FetchMeModel{
  String profileId;
  String email;
  String name;
  String surname;
  String groupId;
  String? profileUri;


  FetchMeModel({
    required this.profileId,
    required this.email,
    required this.name,
    required this.surname,
    required this.groupId,
    this.profileUri
  });


  factory FetchMeModel.fromJson(Map<String,dynamic> json){
    return FetchMeModel(
        profileId: json['userProfileId'],
        email: json['email'],
        name: json['firstName'],
        surname: json['lastName'],
        groupId: json['groupId'],
        profileUri: json['profileUri'],
        );
  }
}