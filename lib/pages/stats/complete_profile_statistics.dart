import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team_coffee/pages/stats/line_chart.dart';
import 'package:team_coffee/pages/stats/event_pie_chart.dart';
import 'package:team_coffee/utils/string_resources.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import 'order_pie_chart.dart';

class CompleteProfileStatistics extends StatefulWidget {
  const CompleteProfileStatistics({Key? key}) : super(key: key);

  @override
  State<CompleteProfileStatistics> createState() =>
      _CompleteProfileStatisticsState();
}

class _CompleteProfileStatisticsState extends State<CompleteProfileStatistics> {
  bool showOrdersPieChart = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBlueDarkColor,
      appBar: AppBar(
        title: Text(AppStrings.profileStats.tr),
        backgroundColor: AppColors.mainBlueDarkColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(Dimensions.width10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LineChartSample1(),
                SizedBox(height: Dimensions.height20),
                Divider(),
                SizedBox(height: Dimensions.height10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ToggleSwitch(
                      minWidth: Dimensions.width30 * 4,
                      initialLabelIndex: showOrdersPieChart ? 0 : 1,
                      cornerRadius: Dimensions.radius30,
                      activeFgColor: Colors.white,
                      inactiveBgColor: Colors.grey,
                      inactiveFgColor: Colors.black,
                      totalSwitches: 2,
                      radiusStyle: true,
                      animate: true,
                      curve: Curves.decelerate,
                      animationDuration: 20,
                      labels: [
                        AppStrings.ordersFilter.tr,
                        AppStrings.eventsTitle.tr
                      ],
                      icons: [Icons.fastfood, Icons.event_available],
                      activeBgColors: [
                        [AppColors.orangeChipColor],
                        [AppColors.redChipColor]
                      ],
                      onToggle: (index) {
                        print('switched to: $index');
                        if (index == 0) {
                          setState(() {
                            showOrdersPieChart = true;
                          });
                        } else {
                          setState(() {
                            showOrdersPieChart = false;
                          });
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(height: Dimensions.height10),
                if (showOrdersPieChart)
                  const AlternatingPieChart()
                else
                  const PieChartSample2(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
