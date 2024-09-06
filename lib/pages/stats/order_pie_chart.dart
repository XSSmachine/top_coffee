import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:team_coffee/utils/string_resources.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../controllers/order_controller.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';

class AlternatingPieChart extends StatefulWidget {
  const AlternatingPieChart({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AlternatingPieChartState();
}

class AlternatingPieChartState extends State<AlternatingPieChart> {
  OrderController orderController = Get.find<OrderController>();
  int touchedIndex = -1;
  bool showByStatus = true; // true for status, false for type
  List<Map<String, dynamic>> data = [];
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
      final response = await orderController.fetchOrderPieData();
      print(response.toString());
      final List<dynamic> jsonData = response;
      setState(() {
        data = List<Map<String, dynamic>>.from(jsonData);
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
    return data
        .where(
            (item) => item.containsKey(showByStatus ? 'orderStatus' : 'type'))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredData = getFilteredData();
    return Padding(
      padding: EdgeInsets.only(top: Dimensions.height10),
      child: Column(
        children: <Widget>[
          ToggleSwitch(
            activeBorders: [
              Border.all(
                color: Colors.orange.shade700,
                width: 2.0,
              ),
              Border.all(
                color: Colors.blue.shade500,
                width: 2.0,
              ),
            ],
            activeFgColor: Colors.black54,
            isVertical: true,
            minWidth: Dimensions.width30 * 4,
            radiusStyle: true,
            cornerRadius: Dimensions.radius15,
            initialLabelIndex: showByStatus ? 0 : 1,
            activeBgColors: [
              [Colors.deepOrangeAccent],
              [Colors.lightBlueAccent]
            ],
            labels: [AppStrings.byStatus.tr, AppStrings.byType.tr],
            onToggle: (index) {
              print('switched to: $index');
              if (index == 0) {
                setState(() {
                  showByStatus = true;
                });
              } else {
                setState(() {
                  showByStatus = false;
                });
              }
            },
          ),
          if (isLoading)
            Center(child: CircularProgressIndicator())
          else if (filteredData.isEmpty)
            Center(
                child: Expanded(
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: Dimensions.height45,
                    ),
                    Image.asset(
                      "assets/image/donuts.png",
                      scale: 0.5,
                      width: Dimensions.width20 * 10,
                      height: Dimensions.width20 * 10,
                    ),
                    Text(
                      AppStrings.noData.tr,
                      style: TextStyle(
                          fontSize: Dimensions.font20,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ))
          else
            AspectRatio(
              aspectRatio: 1.6,
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
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 0,
                  centerSpaceRadius: Dimensions.width20 * 2,
                  sections: showingSections(filteredData),
                ),
              ),
            ),
        ],
      ),
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

      List<Color> colors = [
        AppColors.contentColorBlue,
        AppColors.contentColorYellow,
        AppColors.contentColorPurple,
        AppColors.contentColorGreen,
        Colors.red,
        Colors.orange,
        Colors.pink,
      ];

      String key = showByStatus ? 'orderStatus' : 'type';

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
                '${item[key]}',
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
