
class EventModel {
  late String? _eventId;
  late String? _groupId;
  late String _userProfileId;
  late String _userProfileFirstName;
  late String _userProfileLastName;
  late String? _createdAt;
  late String? _pendingUntil;
  late String? _title;
  late String? _description;
  late String? _status;
  late String? _eventType;

  EventModel({
    groupId,
    eventId,
    required userProfileId,
    required userProfileFirstName,
    required userProfileLastName,
    pendingUntil,
    createdAt,
    status,
    title,
    description,
    eventType,
  }) {
    _eventId = eventId;
    _groupId = groupId;
    _userProfileId = userProfileId;
    _userProfileFirstName = userProfileFirstName;
    _userProfileLastName = userProfileLastName;
    _pendingUntil = pendingUntil;
    _createdAt = createdAt;
    _status = status;
    _title = title;
    _description = description;
    _eventType = eventType;
  }

  String? get eventId => _eventId;
  String? get groupId => _groupId;
  String get userProfileId => _userProfileId;
  String get userProfileFirstName => _userProfileFirstName;
  String get userProfileLastName => _userProfileLastName;
  String? get pendingUntil => _pendingUntil;
  String? get createdAt => _createdAt;
  String? get status => _status;
  String? get title => _title;
  String? get description => _description;
  String? get eventType => _eventType;

  EventModel.fromJson(Map<String, dynamic> json) {
    _eventId = json['eventId'];
    _groupId = json['groupId'];
    _userProfileId = json["userProfileId"] ?? "";
    _userProfileFirstName = json["userProfileFirstName"] ?? "";
    _userProfileLastName = json["userProfileLastName"] ?? "";
    _pendingUntil = json["pendingUntil"] ?? "";
    _createdAt = json["createdAt"] ?? "";
    _status = json["status"] ?? "";
    _eventType = json["eventType"];
    _title = json["title"] ?? "";
    _description = json["description"] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['eventId'] = _eventId;
    data['groupId'] = _groupId;
    data['userProfileId'] = _userProfileId;
    data['userProfileFirstName'] = _userProfileFirstName;
    data['userProfileLastName'] = _userProfileLastName;
    data['pendingUntil'] = _pendingUntil;
    data['createdAt'] = _createdAt;
    data['eventType'] = _eventType;
    data['title'] = _title;
    data['description'] = _description;
    data['status'] = _status;
    return data;
  }
}
