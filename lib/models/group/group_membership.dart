class GroupMembership {
  final String groupId;
  final List<String> roles;

  GroupMembership({required this.groupId, required this.roles});

  factory GroupMembership.fromJson(Map<String, dynamic> json) {
    return GroupMembership(
      groupId: json['groupId'],
      roles: List<String>.from(json['roles']),
    );
  }
}
