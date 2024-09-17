import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:team_coffee/utils/string_resources.dart';
import '../../controllers/event_controller.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';

class PieChartSample2 extends StatefulWidget {
  const PieChartSample2({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PieChart2State();
}

class PieChart2State extends State<PieChartSample2> {
  EventController eventController = Get.find<EventController>();
  int touchedIndex = -1;
  String selectedType = 'ALL';
  String selectedStatus = 'ALL';
  List<Map<String, dynamic>> data = [];
  List<String> types = ['ALL'];
  List<String> statuses = ['ALL'];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await eventController.fetchEventPieData();

      final List<dynamic> jsonData = response;
      setState(() {
        data = List<Map<String, dynamic>>.from(jsonData);
        types = [
          'ALL',
          ...{...data.map((item) => item['type'] as String)}.toList()
        ];
        statuses = [
          'ALL',
          ...{...data.map((item) => item['eventStatus'] as String)}.toList()
        ];
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> getFilteredData() {
    return data.where((item) {
      bool typeMatch = selectedType == 'ALL' || item['type'] == selectedType;
      bool statusMatch =
          selectedStatus == 'ALL' || item['eventStatus'] == selectedStatus;
      return typeMatch && statusMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredData = getFilteredData();

    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (filteredData.isEmpty) {
      return Center(
          child: Expanded(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: Dimensions.height30,
              ),
              Image.asset(
                "assets/image/donuts.png",
                width: Dimensions.width20 * 10,
                height: Dimensions.width20 * 10,
              ),
              Text(
                AppStrings.noData.tr,
                style: TextStyle(
                    fontSize: Dimensions.font20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ));
    }

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            DropdownButton<String>(
              key: ValueKey('typeDropdown'),
              value: selectedType,
              items: types.map((String value) {
                return DropdownMenuItem<String>(
                  key: ValueKey(value),
                  value: value,
                  child: Text(value.tr),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedType = newValue!;
                });
              },
            ),
            DropdownButton<String>(
              key: ValueKey('statusDropdown'),
              value: selectedStatus,
              items: statuses.map((String value) {
                return DropdownMenuItem<String>(
                  key: ValueKey(value),
                  value: value,
                  child: Text(value.tr),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedStatus = newValue!;
                });
              },
            ),
          ],
        ),
        AspectRatio(
          aspectRatio: 1.3,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex =
                        pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              borderData: FlBorderData(show: false),
              sectionsSpace: 0,
              centerSpaceRadius: 40,
              sections: showingSections(filteredData),
            ),
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> showingSections(
      List<Map<String, dynamic>> filteredData) {
    return filteredData.asMap().entries.map((entry) {
      final int idx = entry.key;
      final Map<String, dynamic> item = entry.value;
      final bool isTouched = idx == touchedIndex;
      final double fontSize = isTouched ? 25.0 : 16.0;
      final double radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      final String eventStatus = item['eventStatus']?.toString() ?? '';
      final String eventType = item['type']?.toString() ?? '';

      List<Color> colors = [
        AppColors.contentColorBlue,
        AppColors.contentColorYellow,
        AppColors.contentColorPurple,
        AppColors.contentColorGreen,
        Colors.red,
        Colors.orange,
        Colors.pink,
      ];

      return PieChartSectionData(
        color: colors[idx % colors.length],
        value: item['count'].toDouble(),
        title: '${item['count']}',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: AppColors.mainTextColor1,
          shadows: shadows,
        ),
        badgeWidget: isTouched
            ? _Badge(
                '${eventStatus.tr}\n(${eventType.tr})',
                size: 40,
                borderColor: colors[idx % colors.length],
              )
            : null,
        badgePositionPercentageOffset: .98,
      );
    }).toList();
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final double size;
  final Color borderColor;

  const _Badge(
    this.text, {
    Key? key,
    required this.size,
    required this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size * 2,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: borderColor,
            fontSize: size * .2,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
