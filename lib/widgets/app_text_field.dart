import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/dimensions.dart';


class AppTextField extends StatelessWidget {
  final TextEditingController textController;
  final String hintText;
  final IconData icon;
  int minLines;
  int maxLines;
  bool isMultiline;
  bool isObscure;
  AppTextField({super.key, required this.textController, required this.hintText, required this.icon, this.isObscure=false,
                this.minLines=1,this.maxLines=1,this.isMultiline=false
              });

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: Dimensions.height15,right: Dimensions.height15),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(Dimensions.radius30),

        ),
        child: TextField(
          minLines: minLines,
          maxLines: maxLines,
          keyboardType: isMultiline?TextInputType.multiline:TextInputType.text,
          obscureText: isObscure,
          controller: textController,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(icon, color: AppColors.mainColor,),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radius30),
                borderSide:const BorderSide(
                  width: 1.0,
                  color: Colors.grey,
                )
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radius30),
                borderSide:const BorderSide(
                  width: 1.0,
                  color: Colors.grey,
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
