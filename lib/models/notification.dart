class NotificationModel {
  final String notificationType;
  final String userProfileId;
  final String firstName;
  final String lastName;
  final String eventId;
  final String? photoUri;
  final String? orderId;
  final Map<String, dynamic> additionalOptions;
  final DateTime createdAt;
  final String? groupId;
  final String? title;
  final String? description;
  final String? eventType;
  final DateTime? pendingUntil;
  final String? recipientUserProfileId;

  NotificationModel({
    required this.notificationType,
    required this.userProfileId,
    required this.firstName,
    required this.lastName,
    required this.eventId,
    this.photoUri,
    this.orderId,
    required this.additionalOptions,
    required this.createdAt,
    this.groupId,
    this.title,
    this.description,
    this.eventType,
    this.pendingUntil,
    this.recipientUserProfileId,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      notificationType: json['notificationType'] as String? ?? 'unknown',
      userProfileId: json['userProfileId'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      eventId: json['eventId'] as String? ?? '',
      photoUri: json['photoUri'] as String?,
      orderId: json['orderId'] as String?,
      additionalOptions:
          json['additionalOptions'] as Map<String, dynamic>? ?? {},
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      groupId: json['groupId'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      eventType: json['eventType'] as String?,
      pendingUntil: json['pendingUntil'] != null
          ? DateTime.tryParse(json['pendingUntil'] as String)
          : null,
      recipientUserProfileId: json['recipientUserProfileId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notificationType': notificationType,
      'userProfileId': userProfileId,
      'firstName': firstName,
      'lastName': lastName,
      'eventId': eventId,
      'photoUri': photoUri,
      'orderId': orderId,
      'additionalOptions': additionalOptions,
      'createdAt': createdAt.toIso8601String(),
      'groupId': groupId,
      'title': title,
      'description': description,
      'eventType': eventType,
      'pendingUntil': pendingUntil?.toIso8601String(),
      'recipientUserProfileId': recipientUserProfileId,
    };
  }

  String get fullName => '$firstName $lastName';

  @override
  String toString() {
    return 'NotificationModel(notificationType: $notificationType, userProfileId: $userProfileId, fullName: $fullName, eventId: $eventId, orderId: $orderId, groupId: $groupId, title: $title, description: $description, eventType: $eventType, pendingUntil: $pendingUntil, recipientUserProfileId: $recipientUserProfileId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NotificationModel &&
        other.notificationType == notificationType &&
        other.userProfileId == userProfileId &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.eventId == eventId &&
        other.photoUri == photoUri &&
        other.orderId == orderId &&
        other.additionalOptions == additionalOptions &&
        other.createdAt == createdAt &&
        other.groupId == groupId &&
        other.title == title &&
        other.description == description &&
        other.eventType == eventType &&
        other.pendingUntil == pendingUntil &&
        other.recipientUserProfileId == recipientUserProfileId;
  }

  @override
  int get hashCode {
    return notificationType.hashCode ^
        userProfileId.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        eventId.hashCode ^
        photoUri.hashCode ^
        orderId.hashCode ^
        additionalOptions.hashCode ^
        createdAt.hashCode ^
        groupId.hashCode ^
        title.hashCode ^
        description.hashCode ^
        eventType.hashCode ^
        pendingUntil.hashCode ^
        recipientUserProfileId.hashCode;
  }
}
