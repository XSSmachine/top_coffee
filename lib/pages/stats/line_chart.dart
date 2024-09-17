import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:team_coffee/controllers/event_controller.dart';
import '../../controllers/order_controller.dart';
import '../../models/monthly_summary.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';

class _LineChart extends StatelessWidget {
  const _LineChart({
    required this.isShowingMainData,
    required this.ordersData,
    required this.eventsData,
  });

  final bool isShowingMainData;
  final List<MonthlySummary> ordersData;
  final List<MonthlySummary> eventsData;

  @override
  Widget build(BuildContext context) {
    print(ordersData.length);
    print(eventsData.first.count);
    return LineChart(
      isShowingMainData ? sampleData1 : sampleData2,
      duration: const Duration(milliseconds: 250),
    );
  }

  LineChartData get sampleData1 => LineChartData(
        lineTouchData: lineTouchData1,
        gridData: gridData,
        titlesData: titlesData1,
        borderData: borderData,
        lineBarsData: [
          lineChartBarData1_1,
          lineChartBarData1_2,
        ],
        minX: 0,
        maxX: 5,
        maxY: max(
                ordersData
                    .sublist(ordersData.length - 6, ordersData.length - 1)
                    .map((e) => e.count)
                    .reduce(max),
                eventsData
                    .sublist(eventsData.length - 6, eventsData.length - 1)
                    .map((e) => e.count)
                    .reduce(max))
            .toDouble(),
        minY: 0,
      );

  LineChartData get sampleData2 => LineChartData(
        lineTouchData: lineTouchData2,
        gridData: gridData,
        titlesData: titlesData1,
        borderData: borderData,
        lineBarsData: lineBarsData2,
        minX: 0,
        maxX: 5,
        maxY: max(
                ordersData
                    .sublist(max(0, ordersData.length - 6))
                    .map((e) => e.count)
                    .reduce(max),
                eventsData
                    .sublist(max(0, eventsData.length - 6))
                    .map((e) => e.count)
                    .reduce(max))
            .toDouble(),
        minY: 0,
      );

  LineTouchData get lineTouchData1 => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (touchedSpot) => Colors.blueGrey.withOpacity(0.8),
        ),
      );

  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  List<LineChartBarData> get lineBarsData1 => [
        lineChartBarData1_1,
        lineChartBarData1_2,
        lineChartBarData1_3,
      ];

  LineTouchData get lineTouchData2 => const LineTouchData(
        enabled: false,
      );

  FlTitlesData get titlesData2 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  List<LineChartBarData> get lineBarsData2 => [
        lineChartBarData2_1,
        lineChartBarData2_2,
      ];

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    int maxCount = max(
        ordersData
            .sublist(ordersData.length - 6, ordersData.length - 1)
            .map((e) => e.count)
            .reduce(max),
        eventsData
            .sublist(eventsData.length - 6, eventsData.length - 1)
            .map((e) => e.count)
            .reduce(max));

    double interval = maxCount / 2;
    String text = (value * interval).toStringAsFixed(0);

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 1,
        reservedSize: 40,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    int index = value.toInt();
    if (index >= 0 && index < 6 && index < ordersData.length) {
      final monthIndex = ordersData.length - 6 + index;
      final month = ordersData[monthIndex].month;
      final monthName = DateFormat('MMM').format(DateTime(2024, month));
      text = Text(monthName, style: style);
    } else {
      text = const Text('');
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  FlGridData get gridData => const FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border(
          bottom:
              BorderSide(color: AppColors.primary.withOpacity(0.2), width: 4),
          left: const BorderSide(color: Colors.transparent),
          right: const BorderSide(color: Colors.transparent),
          top: const BorderSide(color: Colors.transparent),
        ),
      );

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
        isCurved: true,
        color: AppColors.contentColorGreen,
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: ordersData
            .asMap()
            .entries
            .toList()
            .sublist(max(0, ordersData.length - 6))
            .asMap()
            .entries
            .map((entry) {
          return FlSpot(
              entry.key.toDouble(), entry.value.value.count.toDouble());
        }).toList(),
      );

  LineChartBarData get lineChartBarData1_2 => LineChartBarData(
        isCurved: true,
        color: AppColors.contentColorPink,
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: eventsData
            .asMap()
            .entries
            .toList()
            .sublist(max(0, eventsData.length - 6))
            .asMap()
            .entries
            .map((entry) {
          return FlSpot(
              entry.key.toDouble(), entry.value.value.count.toDouble());
        }).toList(),
      );

  LineChartBarData get lineChartBarData1_3 => LineChartBarData(
        isCurved: true,
        color: AppColors.contentColorCyan,
        barWidth: 8,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: const [
          FlSpot(1, 2.8),
          FlSpot(3, 1.9),
          FlSpot(6, 3),
          FlSpot(10, 1.3),
          FlSpot(13, 2.5),
        ],
      );

  LineChartBarData get lineChartBarData2_1 => LineChartBarData(
        isCurved: true,
        curveSmoothness: 0,
        color: AppColors.contentColorGreen.withOpacity(0.5),
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: ordersData
            .asMap()
            .entries
            .toList()
            .sublist(max(0, ordersData.length - 6))
            .asMap()
            .entries
            .map((entry) {
          return FlSpot(
              entry.key.toDouble(), entry.value.value.count.toDouble());
        }).toList(),
      );

  LineChartBarData get lineChartBarData2_2 => LineChartBarData(
        isCurved: true,
        color: AppColors.contentColorPink.withOpacity(0.5),
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          color: AppColors.contentColorPink.withOpacity(0.2),
        ),
        spots: eventsData
            .asMap()
            .entries
            .toList()
            .sublist(max(0, eventsData.length - 6))
            .asMap()
            .entries
            .map((entry) {
          return FlSpot(
              entry.key.toDouble(), entry.value.value.count.toDouble());
        }).toList(),
      );

  LineChartBarData get lineChartBarData2_3 => LineChartBarData(
        isCurved: true,
        curveSmoothness: 0,
        color: AppColors.contentColorCyan.withOpacity(0.5),
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
        spots: const [
          FlSpot(1, 3.8),
          FlSpot(3, 1.9),
          FlSpot(6, 5),
          FlSpot(10, 3.3),
          FlSpot(13, 4.5),
        ],
      );
}

class LineChartSample1 extends StatefulWidget {
  const LineChartSample1({super.key});

  @override
  State<StatefulWidget> createState() => LineChartSample1State();
}

class LineChartSample1State extends State<LineChartSample1> {
  EventController eventController = Get.find<EventController>();
  OrderController orderController = Get.find<OrderController>();
  late bool isShowingMainData;
  List<MonthlySummary> ordersData = [];
  List<MonthlySummary> eventsData = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true; // Set loading to true when starting to fetch data
    });
    try {
      ordersData = await orderController.fetchOrdersStatistics();
      eventsData = await eventController.fetchEventsStatistics();
      setState(() {
        isLoading = false; // Set loading to false when data is fetched
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false; // Set loading to false even if there's an error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.23,
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 37),
              Text(
                'Monthly Statistics'.tr,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Dimensions.font26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 37),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16, left: 6),
                  child: isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                          color: Colors.white,
                        )) // Show loading indicator
                      : _LineChart(
                          isShowingMainData: isShowingMainData,
                          ordersData: ordersData,
                          eventsData: eventsData,
                        ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
          if (!isLoading) // Only show the refresh button when not loading
            IconButton(
              icon: Icon(
                Icons.refresh,
                color: Colors.black.withOpacity(isShowingMainData ? 1.0 : 0.5),
              ),
              onPressed: () {
                setState(() {
                  isShowingMainData = !isShowingMainData;
                });
              },
            ),
        ],
      ),
    );
  }
}
