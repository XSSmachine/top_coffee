import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:team_coffee/controllers/event_controller.dart';
import 'package:team_coffee/models/event_body_model.dart';

import '../../controllers/user_controller.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  //first we need to get events that are pending or in progress and based on whether you created an event
  // you get assigned as creator and get specific widget flow for creator and user
  String announcementStatus = 'NONE'; // 'NONE', 'PENDING', 'IN_PROGRESS', 'COMPLETED' <- this is just to test without backend
  String userStatus = "";
  String currentUser = 'John Doe';
  String coffeeBrewer = 'Jane Smith';
  List<String>  coffeeOrders = ["Espresso, Milk:3, Sugar:2","Latte, Milk:1, Sugar:4","Cappucciono, Milk:4, Sugar:1"];// i need to get this data from event controller
  List<String> coffeeTypes = ['Espresso', 'Latte', 'Cappuccino'];
  String selectedCoffeeType = 'Espresso';
  int selectedSugar = 0;
  int selectedMilk = 0;
  List<bool> orderStatus = List.generate(3, (_) => false);

  String currentRole = 'User'; // Default role
  List<String> roles = ['User', 'Creator'];

  int remainingSeconds = 0;
  Timer? _timer;

  bool isRated = false;
  bool showRatingScreen = false;
  bool wantCoffee = false;
  bool isVisible = true;

 int _selectedMilkQuantity=3;
 int _selectedSugarQuantity=3;

  get selectedMilkQuantity => _selectedMilkQuantity;

  get selectedSugarQuantity => _selectedSugarQuantity;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // this needs to assign userrole to creator
  void startBrewing(int minutes) {
    setState(() {
      announcementStatus = 'PENDING';
      remainingSeconds = minutes * 60;
      _startTimer();
    });
  }

  //this timer automatically starts when event is created until event is in progress
  // so users have time to make an order
  void _startTimer() {
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingSeconds > 0) {
          remainingSeconds--;
        } else {
          _timer?.cancel();
          announcementStatus = 'IN_PROGRESS';
        }
      });
    });
  }

  void completeBrewing() {
    setState(() {
      announcementStatus = 'NONE';
    });
  }

  bool allOrdersCompleted() {
    return orderStatus.every((status) => status);
  }

  void addOrder() {
    // Dummy method to add order
  }

  void finishOrder() {
    setState(() {
      announcementStatus = 'COMPLETED';
      showRatingScreen=true;
      userStatus="";
      // Reset order status for next time
      orderStatus = List.generate(coffeeOrders.length, (_) => false);
    });
  }



  @override
  Widget build(BuildContext context) {
    UserController user = Get.find<UserController>();
    return GetBuilder<EventController>(builder: (eventController){

      return Scaffold(
        appBar: AppBar(
          title: Text(currentRole.toString()),
          actions: [
            DropdownButton<String>(
              value: currentRole,
              icon: Icon(Icons.keyboard_arrow_down_outlined, color: Colors.black54),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.white),
              dropdownColor: AppColors.iconColor1,
              underline: Container(
                height: 2,
                color: Colors.white,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  print(newValue);
                  print(announcementStatus);
                  currentRole = newValue!;
                  announcementStatus=announcementStatus;
                });
              },
              items: roles.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(width: 20),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (announcementStatus == 'NONE' || announcementStatus == 'COMPLETED' && currentRole=="Creator")
                Center(
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.mainColor,
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Brew some coffee for the team!",
                          style: TextStyle(color: AppColors.mainBlackColor,
                              fontSize: 20),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () =>
                              setState(() {
                                announcementStatus = "TIME";
                                currentRole="Creator";

                              }
                              ),
                          child: Text("Start Brewing"),
                        ),
                      ],
                    ),
                  ),
                ),
              if (announcementStatus == 'TIME' && currentRole=='Creator')
                Container(
                  padding: EdgeInsets.all(8.0),                  decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.orangeAccent,
                ),
                  child: Column(
                    children: [
                      Text(
                        "In how many minutes will you start brewing coffee?",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              print(user.getUserIDFromPrefs().toString());
                              eventController.createEvent(EventBody(creatorId: user.getUserIDFromPrefs().toString(), time: 5));
                              startBrewing(5);
                              //announcementStatus = "PENDING";
                            },
                            child: Text("5 min"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              startBrewing(0);
                              //announcementStatus = "PENDING";
                            },
                            child: Text("10 min"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              startBrewing(1);
                              //announcementStatus = "PENDING";
                            },
                            child: Text("15 min"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              if (announcementStatus == 'PENDING' && currentRole=="Creator"&& userStatus=="")
                Center(
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.mainColor,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Coffee will start brewing in:",
                          style: TextStyle(color: AppColors.mainBlackColor, fontSize: 20),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "${remainingSeconds ~/ 60}:${(remainingSeconds % 60).toString().padLeft(2, '0')}",
                          style: TextStyle(color: AppColors.mainBlackColor, fontSize: 40, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              if (announcementStatus == 'IN_PROGRESS' && currentRole=="Creator")
                Expanded( // Wrap the entire Container in an Expanded widget
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.greenAccent,
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Coffee Orders",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        SizedBox(height: 10),
                        Expanded( // This Expanded is now okay because it's inside a Column that has a defined size
                          child: ListView.builder(
                            itemCount: coffeeOrders.length,
                            itemBuilder: (context, index) {
                              return CheckboxListTile(
                                title: Text(coffeeOrders[index]),
                                value: orderStatus[index],
                                onChanged: (bool? value) {
                                  setState(() {
                                    orderStatus[index] = value ?? false;
                                  });
                                },
                              );
                            },
                          ),
                        ),
                        ElevatedButton(
                          onPressed: allOrdersCompleted() ? finishOrder : null,
                          child: Text("Finish Order"),
                        ),
                      ],
                    ),
                  ),
                ),
              if (announcementStatus == 'PENDING' && currentRole == "User" && wantCoffee==false)
                Center(
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.mainColor,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.coffee,
                          size: 60,
                          color: AppColors.mainBlackColor,
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Coffee will start brewing in:",
                          style: TextStyle(color: AppColors.mainBlackColor, fontSize: 20),
                        ),
                        Text(
                          "${remainingSeconds ~/ 60}:${(remainingSeconds % 60).toString().padLeft(2, '0')}",
                          style: TextStyle(color: AppColors.mainBlackColor, fontSize: 40, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Creator is going to make some coffee,\ndo you want one too?",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.mainBlackColor, fontSize: 19),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              icon: Icon(Icons.check_circle, color: Colors.green, size: 40),
                              onPressed: () {
                                // Handle accept
                                setState(() {
                                  wantCoffee = true;
                                });
                              },
                            ),
                            SizedBox(width: 40),
                            IconButton(
                              icon: Icon(Icons.cancel, color: Colors.red, size: 40),
                              onPressed: () {
                                // Handle deny
                                // You can add your logic here
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

              if (announcementStatus == 'PENDING' && currentRole=="User" && wantCoffee && isVisible )
                Container(
                  padding: EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.greenAccent,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Coffee Order",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      SizedBox(height: 10),
                      DropdownButton<String>(
                        value: selectedCoffeeType,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedCoffeeType = newValue!;
                          });
                        },
                        items: coffeeTypes.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Select Milk Quantity:",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          for (int i = 0; i <= 5; i++)
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _selectedMilkQuantity = i;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: selectedMilkQuantity == i ? Colors.blue : Colors.grey,
                              ),
                              child: Text("$i"),
                            ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Select Sugar Quantity:",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          for (int i = 0; i <= 5; i++)
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _selectedSugarQuantity = i;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: selectedSugarQuantity == i ? Colors.blue : Colors.grey,
                              ),
                              child: Text("$i"),
                            ),
                        ],
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // Place your logic for ordering here
                          // You can access selectedCoffeeType, selectedMilkQuantity, selectedSugarQuantity here
                          // Example logic:
                          print("Order placed with:");
                          print("Coffee Type: $selectedCoffeeType");
                          print("Milk Quantity: $selectedMilkQuantity");
                          print("Sugar Quantity: $selectedSugarQuantity");
                          setState(() {
                            userStatus="Waiting";
                            isVisible=false;
                          });

                        },
                        child: Text("Order Up!"),
                      ),
                    ],
                  ),
                ),

              if (userStatus == 'Waiting' && currentRole=="User")
                Center(
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.mainColor,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Creator is currently brewing coffe for the team!",
                          style: TextStyle(color: AppColors.mainBlackColor, fontSize: 20),
                        ),

                      ],
                    ),
                  ),
                ),

              if (isRated == false && currentRole=="User" && showRatingScreen && announcementStatus=="COMPLETED")
                Align(
                  alignment: Alignment.center,
                  child: Container(

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        RatingBar.builder(
                          initialRating: 3,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            switch (index) {
                              case 0:
                                return Icon(
                                  Icons.star,
                                  color: Colors.amberAccent,
                                );
                              case 1:
                                return Icon(
                                  Icons.star,
                                  color: Colors.amberAccent,
                                );
                              case 2:
                                return Icon(
                                  Icons.star,
                                  color: Colors.amberAccent,
                                );
                              case 3:
                                return Icon(
                                  Icons.star,
                                  color: Colors.amberAccent,
                                );
                              case 4:
                                return Icon(
                                  Icons.star,
                                  color: Colors.amberAccent,
                                );
                              default:
                                return Icon(
                                  Icons.sentiment_neutral,
                                  color: Colors.amber,
                                );
                            }
                          },
                          onRatingUpdate: (rating) {
                            print(rating);
                          },
                        ),
                        SizedBox(height: Dimensions.height20,),
                        TextButton(
                          style: TextButton.styleFrom(
                            textStyle: TextStyle(
                              height: 1.2,
                              fontFamily: 'Dubai',
                              fontSize: 13,
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              isRated=true;
                              announcementStatus="NONE";
                              userStatus="";
                              isVisible=true;
                            });

                          },
                          child: const Text('Rate the coffee'),)
                      ],
                    ),


                  ),
                ),
              if (announcementStatus == 'in_progress')
                Container(
                  // ... (keep the existing 'in_progress' state UI)
                ),


            ],
          ),
        ),
      );
    });
  }
}

