import 'dart:async';

import 'package:flutter/material.dart';


class CoffeeBrewingAnnouncement extends StatefulWidget {
  final int initialRemainingSeconds;
  final String creatorName;
  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;
  final VoidCallback onAccept;
  final VoidCallback onDeny;
  final VoidCallback onTimerExpired;
  final String userStatus;


  const CoffeeBrewingAnnouncement({
    super.key,
    required this.initialRemainingSeconds,
    this.creatorName = "Creator",
    this.backgroundColor = Colors.orange,
    this.textColor = Colors.black,
    this.iconColor = Colors.black,
    required this.onAccept,
    required this.onDeny,
    required this.onTimerExpired,
    required this.userStatus ,
  });

  @override
  _CoffeeBrewingAnnouncementState createState() => _CoffeeBrewingAnnouncementState();
}

class _CoffeeBrewingAnnouncementState extends State<CoffeeBrewingAnnouncement> with SingleTickerProviderStateMixin {
  late int remainingSeconds;
  late Timer timer;
  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation;
  bool isLastMinute = false;

  @override
  void initState() {
    super.initState();
    remainingSeconds = widget.initialRemainingSeconds;
    startTimer();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    _colorAnimation = ColorTween(begin: widget.textColor, end: Colors.red).animate(_animationController);
  }

  @override
  void dispose() {
    timer.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingSeconds > 0) {
          remainingSeconds--;
          if (remainingSeconds <= 60) {
            isLastMinute = true;
          }
        } else {
          timer.cancel();
          widget.onTimerExpired();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: widget.backgroundColor,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.coffee,
            size: 60,
            color: widget.iconColor,
          ),
          const SizedBox(height: 10),
          Text(
            "Coffee will start brewing in:",
            style: TextStyle(color: widget.textColor, fontSize: 20),
          ),
          Text(
            "${remainingSeconds ~/ 60}:${(remainingSeconds % 60).toString().padLeft(2, '0')}",
            style: TextStyle(color: isLastMinute ? _colorAnimation.value : widget.textColor, fontSize: 40, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text(
            "${widget.creatorName} is going to make some coffee,\ndo you want one too?",
            textAlign: TextAlign.center,
            style: TextStyle(color: widget.textColor, fontSize: 19),
          ),
          const SizedBox(height: 20),
        if (widget.userStatus=="USER")
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: const Icon(Icons.check_circle, color: Colors.green, size: 40),
          onPressed: widget.onAccept,
        ),
        const SizedBox(width: 40),
        IconButton(
          icon: const Icon(Icons.cancel, color: Colors.red, size: 40),
          onPressed: widget.onDeny,
        ),
      ],
    )
    else if(widget.userStatus == "CREATOR")
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "My brewing event is pending",
                style: TextStyle(color: widget.textColor, fontSize: 18),
              ),
            ],
          )
    else if(widget.userStatus == "CUSTOMER")
    Text(
    "Order is placed",
    style: TextStyle(color: widget.textColor, fontSize: 18),
    ),

        ],
      ),
    );
  }
}
