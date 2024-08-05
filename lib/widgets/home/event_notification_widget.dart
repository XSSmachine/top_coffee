import 'package:flutter/material.dart';

class CoffeeBrewingNotification extends StatelessWidget {
  final String message;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  const CoffeeBrewingNotification({
    super.key,
    this.message = "Creator is currently brewing coffee for the team!",
    this.backgroundColor = Colors.orange,
    this.textColor = Colors.black,
    this.fontSize = 20,
    this.borderRadius = 20,
    this.padding = const EdgeInsets.all(16.0),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: backgroundColor,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            style: TextStyle(color: textColor, fontSize: fontSize),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}