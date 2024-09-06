class GroupMember {
  final String userProfileId;
  final String firstName;
  final String lastName;
  final List<String> roles;
  final String? photoUrl;

  GroupMember({
    required this.userProfileId,
    required this.firstName,
    required this.lastName,
    required this.roles,
    this.photoUrl,
  });

  factory GroupMember.fromJson(Map<String, dynamic> json) {
    return GroupMember(
      userProfileId: json['userProfileId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      roles: List<String>.from(json['roles']),
      photoUrl: json['photoUrl'],
    );
  }
}
