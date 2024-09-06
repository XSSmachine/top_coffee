import 'package:collection/collection.dart';

class EventFilters {
  String eventType;
  List<String> status;
  String? timeFilter;

  EventFilters({
    required this.eventType,
    required this.status,
    required this.timeFilter,
  });

  factory EventFilters.fromMap(Map<String, dynamic> map) {
    return EventFilters(
      eventType: map['eventType'] as String,
      status: List<String>.from(map['status'] ?? []),
      timeFilter: map['timeFilter'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'eventType': eventType,
      'status': status.first,
      'timeFilter': timeFilter,
    };
  }

  EventFilters copyWith({
    String? eventType,
    List<String>? status,
    String? timeFilter,
  }) {
    return EventFilters(
      eventType: eventType ?? this.eventType,
      status: status ?? this.status,
      timeFilter: timeFilter ?? this.timeFilter,
    );
  }

  @override
  String toString() {
    return 'EventFilters(eventType: $eventType, status: $status, timeFilter: $timeFilter)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is EventFilters &&
        other.eventType == eventType &&
        listEquals(other.status, status) &&
        other.timeFilter == timeFilter;
  }

  @override
  int get hashCode =>
      eventType.hashCode ^ status.hashCode ^ timeFilter.hashCode;

  // Helper method to check if timeFilter is a date
  bool isTimeFilterDate() {
    if (timeFilter == null) return false;
    return DateTime.tryParse(timeFilter!) != null;
  }
}
