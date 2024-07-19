import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/dimensions.dart';


class AppTextField extends StatelessWidget {
  final TextEditingController textController;
  final String hintText;
  final IconData icon;
  bool isObscure;
  AppTextField({super.key, required this.textController, required this.hintText, required this.icon, this.isObscure=false});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: Dimensions.height15,right: Dimensions.height15),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(Dimensions.radius30/2),
            boxShadow: [
              BoxShadow(
                  blurRadius: 5,
                  spreadRadius: 7,
                  offset: Offset(1,8),
                  color: Colors.grey.withOpacity(0.2)
              )
            ]
        ),
        child: TextField(
          obscureText: isObscure,
          controller: textController,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(icon, color: AppColors.yellowColor,),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radius30),
                borderSide:BorderSide(
                  width: 1.0,
                  color: Colors.white,
                )
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radius30),
                borderSide:BorderSide(
                  width: 1.0,
                  color: Colors.white,
                )
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius30),

            ),
          ),
        )
    );
  }
}
