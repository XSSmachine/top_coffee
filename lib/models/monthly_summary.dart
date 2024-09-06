class MonthlySummary {
  final int year;
  final int month;
  final int count;

  MonthlySummary(
      {required this.year, required this.month, required this.count});

  factory MonthlySummary.fromJson(Map<String, dynamic> json) {
    return MonthlySummary(
      year: json['year'],
      month: json['month'],
      count: json['count'],
    );
  }
}
