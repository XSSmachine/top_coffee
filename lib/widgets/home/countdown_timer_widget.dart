import 'dart:async';

import 'package:flutter/cupertino.dart';

import '../../utils/colors.dart';

class CountdownTimer extends StatefulWidget {
  final int initialMinutes;
  final VoidCallback onTimerExpired;

  const CountdownTimer({Key? key, required this.initialMinutes, required this.onTimerExpired}) : super(key: key);

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late int remainingSeconds;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    remainingSeconds = widget.initialMinutes * 60;
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
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
    return Center(
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.mainColor,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Coffee will start brewing in:",
              style: TextStyle(color: AppColors.mainBlackColor, fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              "${remainingSeconds ~/ 60}:${(remainingSeconds % 60).toString().padLeft(2, '0')}",
              style: TextStyle(color: AppColors.mainBlackColor, fontSize: 40, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}