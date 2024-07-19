import 'package:flutter/cupertino.dart';


class AppIcon extends StatelessWidget {
  final IconData icon;
  final Color backgroungColor;
  final Color iconColor;
  final double size;
  final double iconSize;
  const AppIcon({super.key, required this.icon, this.backgroungColor= const Color(0xFFfcf4e4), this.iconColor= const Color(0xFF756d54), this.size=40, this.iconSize=16
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size/2),
        color: backgroungColor
      ),
      child: Icon(icon,
      color: iconColor,
      size: iconSize),
    );
  }
}
