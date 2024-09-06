class EventCount {
  final String eventStatus;
  final String type;
  final int count;

  EventCount({
    required this.eventStatus,
    required this.type,
    required this.count,
  });

  factory EventCount.fromJson(Map<String, dynamic> json) {
    return EventCount(
      eventStatus: json['eventStatus'],
      type: json['type'],
      count: json['count'],
    );
  }
}

extension EventCountListExtension on List<EventCount> {
  int sumAllCounts() {
    return fold(0, (sum, item) => sum + item.count);
  }

  int sumCountsByType(String type) {
    return where((item) => item.type == type)
        .fold(0, (sum, item) => sum + item.count);
  }

  int sumCountsByStatus(String status) {
    return where((item) => item.eventStatus == status)
        .fold(0, (sum, item) => sum + item.count);
  }
}
