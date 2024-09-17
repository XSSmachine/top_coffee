import 'package:flutter/material.dart';
import 'package:team_coffee/widgets/small_text.dart';
import '../utils/dimensions.dart';

enum IconAndTextSize { normal, small, extraSmall }

class IconAndTextWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color iconColor;
  final IconAndTextSize size;

  const IconAndTextWidget({
    Key? key,
    required this.icon,
    required this.text,
    required this.iconColor,
    this.size = IconAndTextSize.normal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double iconSize;
    double fontSize;
    double spacing;

    switch (size) {
      case IconAndTextSize.normal:
        iconSize = Dimensions.iconSize24;
        fontSize = Dimensions.font16 * 0.9;
        spacing = 5;
        break;
      case IconAndTextSize.small:
        iconSize = Dimensions.iconSize16;
        fontSize = Dimensions.font16 * 0.9;
        spacing = 3;
        break;
      case IconAndTextSize.extraSmall:
        iconSize = Dimensions.iconSize16 * 0.75;
        fontSize = Dimensions.font16 * 0.6;
        spacing = 2;
        break;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: iconColor,
          size: iconSize,
        ),
        SizedBox(width: spacing),
        SmallText(
          text: text,
          color: Colors.white,
          size: fontSize,
        ),
      ],
    );
  }
}
