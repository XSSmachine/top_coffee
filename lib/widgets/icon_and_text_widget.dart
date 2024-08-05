import 'package:flutter/material.dart';
import 'package:team_coffee/widgets/small_text.dart';
import '../utils/dimensions.dart';

class IconAndTextWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color iconColor;
  const IconAndTextWidget({super.key, 
    required this.icon, 
    required this.text,
    required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: iconColor,size: Dimensions.iconSize24,),
        const SizedBox(width: 5,),
        SmallText(text: text,color: Colors.white,),
      ]
      
      
      ,
    );
  }
}
