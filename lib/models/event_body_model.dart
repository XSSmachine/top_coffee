class EventBody{
  String creatorId;
  int time;

  EventBody({
    required this.creatorId,
    required this.time,
  });

  Map<String,dynamic> toJson(){
    final Map<String,dynamic> data = new Map<String,dynamic>();
    data["userId"] = this.creatorId;
    data["pendingTime"] = this.time;

    return data;
  }
}