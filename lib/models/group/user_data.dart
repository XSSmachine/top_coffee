import 'group_membership.dart';

class UserData {
  final String userProfileId;
  final String email;
  final String firstName;
  final String lastName;
  final String? profileUri;
  final List<GroupMembership> groupMembershipData;
  final bool verified;

  UserData({
    required this.userProfileId,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.profileUri,
    required this.groupMembershipData,
    required this.verified,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      userProfileId: json['userProfileId'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      profileUri: json['profileUri'],
      groupMembershipData: (json['groupMembershipData'] as List)
          .map((e) => GroupMembership.fromJson(e))
          .toList(),
      verified: json['verified'],
    );
  }
}
