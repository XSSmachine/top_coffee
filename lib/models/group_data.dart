class Group {
  final String groupId;
  final String name;
  final String description;
  final String? photoUrl;

  Group({
    required this.groupId,
    required this.name,
    required this.description,
    this.photoUrl,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      groupId: json['groupId'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      photoUrl: json['photoUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'groupId': groupId,
      'name': name,
      'description': description,
      'photoUrl': photoUrl,
    };
  }
}
