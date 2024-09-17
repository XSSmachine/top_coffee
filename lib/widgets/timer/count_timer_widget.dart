import 'dart:async';

import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../utils/dimensions.dart';

import 'dart:async';

import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../utils/dimensions.dart';

class CountTimer extends StatefulWidget {
  final String startTimeISO;
  final double size;
  final bool showContainer;

  const CountTimer({
    Key? key,
    required this.startTimeISO,
    this.size = 10,
    this.showContainer = true,
  }) : super(key: key);

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountTimer> {
  late DateTime startTime;
  late Timer timer;
  late Duration elapsedTime;

  @override
  void initState() {
    super.initState();
    startTime = DateTime.parse(widget.startTimeISO);
    elapsedTime = Duration.zero;
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        elapsedTime = DateTime.now().difference(startTime);
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    return "${twoDigits(duration.inHours)} h  $twoDigitMinutes min";
  }

  Color _getBackgroundColor() {
    if (elapsedTime.inMinutes <= 5) {
      return AppColors.greenChipColor.withOpacity(0.8);
    } else if (elapsedTime.inMinutes <= 10) {
      return AppColors.orangeChipColor.withOpacity(0.8);
    } else {
      return AppColors.contentColorRed.withOpacity(0.8);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget timerText = Text(
      formatDuration(elapsedTime),
      style: TextStyle(
        color: Colors.black,
        fontSize: widget.size,
        fontWeight: FontWeight.bold,
      ),
    );

    if (widget.showContainer) {
      return Container(
        padding: EdgeInsets.all(Dimensions.height10 / 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radius15 / 2),
          color: _getBackgroundColor(),
        ),
        child: timerText,
      );
    } else {
      return timerText;
    }
  }
}
