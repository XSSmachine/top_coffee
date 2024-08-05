import 'dart:async';

import 'package:flutter/cupertino.dart';

import '../../utils/colors.dart';
import '../../utils/dimensions.dart';

class CountdownTimer extends StatefulWidget {
  final double initialMinutes;
  final VoidCallback onTimerExpired;

  const CountdownTimer(
      {super.key, required this.initialMinutes, required this.onTimerExpired});

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late int remainingSeconds;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    remainingSeconds = (widget.initialMinutes * 60).round() + 5;
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingSeconds > 0) {
          remainingSeconds--;
        } else {
          timer.cancel();
          widget.onTimerExpired();
        }
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      "${remainingSeconds ~/ 60}:${(remainingSeconds % 60).toString().padLeft(2, '0')}",
      style: TextStyle(
          color: AppColors.mainBlackColor,
          fontSize: Dimensions.font20 * 0.7,
          fontWeight: FontWeight.bold),
    );
  }
}
