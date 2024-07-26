import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/route_helper.dart';
import '../utils/dimensions.dart';

class CurrentEventWidget extends StatefulWidget {
  @override
  _CurrentEventWidgetState createState() => _CurrentEventWidgetState();
}

  class _CurrentEventWidgetState extends State<CurrentEventWidget> {
  double _shadowOpacity = 0.6;

  void _animateShadow() {
  setState(() {
  _shadowOpacity = _shadowOpacity == 0.6 ? 1.0 : 0.6;
  });
  }

  @override
  void initState() {
  super.initState();
  // Start the animation loop
  _startAnimationLoop();
  }

  void _startAnimationLoop() async {
  while (true) {
  await Future.delayed(Duration(seconds: 1));
  _animateShadow();
  }
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = "${now.day}-${now.month}-${now.year}";

    return Container(
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(_shadowOpacity),
            spreadRadius: 4,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.event, size: 40, color: Color(0xff5669FF)),
              SizedBox(width: 10),
              Text(
                'TITLE EVENT',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(0xff5669FF),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  'IN PROGRESS',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(Dimensions.radius15),
                ),
                child: Row(
                  children: [
                    Icon(Icons.fastfood, color: Colors.white, size: 16),
                    SizedBox(width: 5),
                    Text(
                      'Food',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10),

            ],
          ),
          Divider(color: Colors.black),
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () {
                  Get.toNamed(RouteHelper.getAllOrderPage());
              },
              style: ElevatedButton.styleFrom(
                elevation: 2,
                foregroundColor: Color(0xff5669FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                ),
              ),
              child: Text('My orders',style: TextStyle(fontSize: Dimensions.font16,fontWeight: FontWeight.w700),),
            ),
          ),
        ],
      ),
    );
  }


}