import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:team_coffee/utils/dimensions.dart';

import '../big_text.dart';

class BrewCoffeeWidget extends StatelessWidget {
  final VoidCallback onStartBrewing;

  BrewCoffeeWidget({super.key, required this.onStartBrewing});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.only(left:Dimensions.height10,right:Dimensions.height10),
        width: double.maxFinite,
        height: Dimensions.height20*10,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.transparent, // This will be covered by the image
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background image
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/image/cup of coffee.png',
                  fit: BoxFit.fitHeight,
                ),

              ),
            ),
            // Overlay Column
            Positioned(
              bottom: 60, // Adjust the vertical position
              right: 140,
              left: 110,
              child:


                ElevatedButton(

                  onPressed: onStartBrewing,
                  child: Text("Start Brewing!"),
                  style: ElevatedButton.styleFrom(
                    elevation: 0.0,
                    foregroundColor: Colors.black, // Button color
                    backgroundColor: Colors.transparent, // Text color
                  ),
                ),

            ),
          ],
        ),
      ),
    );
  }
}


