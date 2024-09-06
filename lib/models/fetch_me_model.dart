import 'group/group_membership.dart';

class FetchMeModel {
  String userProfileId;
  String email;
  String firstName;
  String lastName;
  String? profileUri;
  List<GroupMembership> groupMembershipData;
  bool verified;

  FetchMeModel({
    required this.userProfileId,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.profileUri,
    required this.groupMembershipData,
    required this.verified,
  });

  factory FetchMeModel.fromJson(Map<String, dynamic> json) {
    return FetchMeModel(
      userProfileId: json['userProfileId'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      profileUri: json['profileUri'],
      groupMembershipData: (json['groupMembershipData'] as List<dynamic>)
          .map((groupData) => GroupMembership.fromJson(groupData))
          .toList(),
      verified: json['verified'],
    );
  }
}
