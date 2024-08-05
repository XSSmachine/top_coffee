class EventBody{

  String title;
  String description;

  String eventType;
  int time;

  EventBody({

    required this.time,
    required this.title,
    required this.description,
    required this.eventType,

  });

  Map<String,dynamic> toJson(){
    final Map<String,dynamic> data = <String,dynamic>{};
    //data["creatorId"] = this.creatorId;
    data["title"] = title;
    data["description"] = description;
    //data["groupId"] = this.groupId;
    data["eventType"] = eventType;
    data["pendingTime"] = time;

    return data;
  }
}