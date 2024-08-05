import 'dart:async';

import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../utils/dimensions.dart';

class CountTimer extends StatefulWidget {
  final String startTimeISO;
  final double size;

  const CountTimer({super.key, required this.startTimeISO, this.size = 10});

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
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      formatDuration(elapsedTime),
      style: TextStyle(
        color: AppColors.redChipColor,
        fontSize: widget.size,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
