import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:team_coffee/utils/dimensions.dart';
import 'package:team_coffee/widgets/current_event_widget.dart';

import '../../routes/route_helper.dart';


/**
 * This class displays all events that user placed order on and also will display current
 * event which user created + all past completed events and orders
 */
class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<bool> isSelected = [true, false];
  bool positive = false;
  bool showCurrentEvent = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.only(top: Dimensions.height20*3),
            height: Dimensions.height30*4.8,
            decoration: BoxDecoration(
              color: Color(0xFF4A43EC),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(Dimensions.radius20),bottomRight: Radius.circular(Dimensions.radius20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10.0,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: AnimatedToggleSwitch<bool>.size(
                  current: positive,
                  values: const [false, true],
                  iconOpacity: 0.8,
                  indicatorSize: Size.fromWidth(Dimensions.width30*5),
                  customIconBuilder: (context, local, global) => Text(
                      local.value ? 'Completed':'Active' ,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                          fontSize: Dimensions.font16-2,
                          color: Colors.black)),
                  borderWidth: 4.6,
                  iconAnimationType: AnimationType.onHover,
                  style: ToggleStyle(
                    indicatorColor: Color(0xFF4A43EC),
                    borderColor: Colors.transparent,
                    backgroundColor: Colors.white,
                    borderRadius: BorderRadius.circular(30.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: Offset(0, 1.5),
                      ),
                    ],
                  ),
                  selectedIconScale: 1.0,
                  onChanged: (b) => setState(() => positive = b),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              setState(() {
                if(showCurrentEvent){
                  showCurrentEvent=false;
                }else{
                  showCurrentEvent=true;
                }

              });
            },
            child: Container(
              width: Dimensions.screenWidth/3,
              height: Dimensions.height30,
              decoration: BoxDecoration(
                  color: Colors.white
              ),
              child: Text("    Click here !",style: TextStyle(color: Colors.black,fontSize: Dimensions.font16),),
            ),
          ),
          showCurrentEvent?
          Column(
            children: [
              CurrentEventWidget()
            ],
          ): SizedBox(height: 16.0),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: [
                OrderCard(
                  status: 'Pending',
                  time: '5:48',
                  name: 'Šime Rončević',
                  foodType: 'Food type',
                ),
                OrderCard(
                  status: 'In Progress',
                  time: '7:48',
                  name: 'Andrija Škontra',
                  foodType: 'Food type',
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final String status;
  final String time;
  final String name;
  final String foodType;

  OrderCard({
    required this.status,
    required this.time,
    required this.name,
    required this.foodType,
  });

  double _getProgressValue() {
    switch (status) {
      case 'Pending':
        return 0.33;
      case 'In Progress':
        return 0.66;
      case 'Completed':
        return 1.0;
      default:
        return 0.0;
    }
  }


  @override
  Widget build(BuildContext context) {
    final _value = _getProgressValue();
    return Card(
      elevation: 4,
      margin: EdgeInsets.only(left: 20.0,right: 20.0,bottom: 22.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: Dimensions.width20),
              height: 20,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(Dimensions.radius20),
              ),
              child: Stack(
                fit: StackFit.passthrough,
                children: [
                  LinearProgressIndicator(
                    value: _value,
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4A43EC)),
                    backgroundColor: Colors.transparent,
                    minHeight: Dimensions.height15,
                    borderRadius: BorderRadius.circular(Dimensions.radius20),
                  ),
                  LayoutBuilder(
                    builder: (context, constrains) {
                      var leftPadding = constrains.maxWidth * _value -
                          Dimensions.iconSize16 - 5;
                      var topPadding = (constrains.maxHeight -
                          Dimensions.iconSize16) / 2;
                      return Padding(
                        padding: EdgeInsets.only(
                            left: leftPadding, top: topPadding),
                        child: Icon(
                          Icons.rocket_launch_sharp,
                          color: Colors.white,
                          size: Dimensions.iconSize16.toDouble(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: Dimensions.height10/3,),
            Padding(
              padding: EdgeInsets.only(left: Dimensions.width20),
              child: Text(
                status,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),

            Divider(),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF4A43EC),
                      borderRadius: BorderRadius.circular(Dimensions.radius20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 5.0,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.fastfood,
                        size: 70,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: Dimensions.width15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.timer_sharp, color: Colors.green),
                          SizedBox(width: 5),
                          Text(time),
                        ],
                      ),
                      SizedBox(height: Dimensions.height10/2,),
                Row(
                  children: [
                    Icon(Icons.person_search, color: Colors.deepOrangeAccent),
                    SizedBox(width: 5),
                    Text(name),
                  ],
                ),
                      SizedBox(height: Dimensions.height10/2,),
                      Row(
                        children: [
                          Icon(Icons.face, color: Colors.amber),
                          SizedBox(width: 5),
                          Text(foodType),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(),
            GestureDetector(
              onTap: (){
                Get.toNamed(RouteHelper.getEventDetail("nekiid", "home","orderId"));
              },
              child: Container(
                margin: EdgeInsets.all(Dimensions.width10*1.2),
                padding: EdgeInsets.all(Dimensions.width15/2.3),
                decoration: BoxDecoration(
                  color: Color(0xFF4A43EC),
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10.0,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Center(child: Text("Order details",style: TextStyle(color: Colors.white, fontSize: Dimensions.font16,fontWeight: FontWeight.w500),)),
              ),
            )
          ],
        ),
      ),
    );
  }
}