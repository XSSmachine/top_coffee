class StatusCount {
  final String status;
  final int count;

  StatusCount({required this.status, required this.count});

  factory StatusCount.fromJson(Map<String, dynamic> json) {
    return StatusCount(
      status: json['type'] ?? json['orderStatus'],
      count: json['count'],
    );
  }
}

extension StatusCountListExtension on List<StatusCount> {
  int sumOrderStatusCounts() {
    return where((item) =>
            ['COMPLETED', 'CANCELLED', 'IN_PROGRESS'].contains(item.status))
        .map((item) => item.count as num)
        .fold(0, (sum, count) => sum + count.toInt());
  }
}
