
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:lottie/lottie.dart';
import 'package:team_coffee/widgets/big_text.dart';
import 'package:team_coffee/widgets/icon_and_text_widget.dart';
import 'package:team_coffee/widgets/small_text.dart';

import '../../routes/route_helper.dart';
import '../../utils/dimensions.dart';


/**
 * This class is the home screen, displaying all active events
 * and also gives brief overview on what app is about.
 */
class TopAppbar extends StatelessWidget {
  TopAppbar({super.key});

  final List<String> pendingEvents = List.generate(
      100, (index) => "Event $index");


  Future<void> _refreshData() async {
  // Simulate data fetching delay
  await Future.delayed(Duration(seconds: 2));
  // Perform data fetching and update the UI
  // ...
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent.withOpacity(0.0),
            forceMaterialTransparency: true,
            pinned: true,
            floating: true,
            snap: false,
            expandedHeight: 175.0,
            collapsedHeight: 175,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 210.0,
                    decoration: BoxDecoration(
                      color: Color(0xFF4A43EC),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 50.0,
                    left: 20.0,
                    right: 20.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Center(
                              child: Text(
                                'SyncSnack',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(width: 70),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(Dimensions.radius20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 2.0,
                                    offset: Offset(0, 0),
                                  ),
                                ],
                              ),
                              child: IconButton(
                                icon: Icon(Icons.notifications_none, size: 24, color: Colors.white),
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Container(
                          padding: EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: Color(0xFF4A43EC),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.search_outlined, color: Colors.grey, size: 24),
                              SizedBox(width: 10.0),
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Search...',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: IconAndTextWidget(
                                  icon: Icons.filter_list,
                                  text: "Filters",
                                  iconColor: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 180.0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 60.0,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            SizedBox(width: Dimensions.width10,),
                            FilterChip(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                                side: BorderSide(color: Color(0xFFF0635A)),
                              ),
                              label: IconAndTextWidget(
                                icon: Icons.fastfood,
                                text: "Mix",
                                iconColor: Colors.white,
                              ),
                              backgroundColor: Color(0xFFF0635A),
                              onSelected: (bool value) {},
                            ),
                            SizedBox(width: 8.0),
                            FilterChip(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                                side: BorderSide(color: Color(0xFFF59762)),
                              ),
                              label: IconAndTextWidget(
                                icon: Icons.coffee,
                                text: "Coffee",
                                iconColor: Colors.white,
                              ),
                              backgroundColor: Color(0xFFF59762),
                              onSelected: (bool value) {},
                            ),
                            SizedBox(width: 8.0),
                            FilterChip(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                                side: BorderSide(color: Color(0xFF29D697)),
                              ),
                              label: IconAndTextWidget(
                                icon: IconData(0xec29, fontFamily: 'MaterialIcons'),
                                text: "Food",
                                iconColor: Colors.white,
                              ),
                              backgroundColor: Color(0xFF29D697),
                              onSelected: (bool value) {},
                            ),
                            SizedBox(width: 8.0),
                            FilterChip(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                                side: BorderSide(color: Color(0xFF46CDFB)),
                              ),
                              label: IconAndTextWidget(
                                icon: IconData(0xe383, fontFamily: 'MaterialIcons'),
                                text: "Drinks",
                                iconColor: Colors.white,
                              ),
                              backgroundColor: Color(0xFF46CDFB),
                              onSelected: (bool value) {},
                            ),
                            SizedBox(width: 20.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Active events",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Handle "See more" tap
                    },
                    child: Row(
                      children: [
                        Text(
                          "See more",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                          ),
                        ),
                        Icon(Icons.arrow_right, color: Colors.blue),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

  SliverToBoxAdapter(
            child: Container(
              height: Dimensions.height45 * 6,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Center(
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed(RouteHelper.getEventDetail("nekiid", "home",null));
                      },
                      child: Container(
                          width: 300,
                          margin: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.0),
                              boxShadow: [
                          BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,

                          offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16.0),
                                    topRight: Radius.circular(16.0),
                                  ),
                                  child: Image.network(
                                    'https://via.placeholder.com/300x150', // Replace with your image URL
                                    height: 150,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 8.0,
                                  left: 8.0,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Text(
                                      '10:23',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 8.0,
                                  right: 8.0,
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Stipe marenda',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8.0),
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: NetworkImage('https://via.placeholder.com/40'), // Replace with your image URL
                                        radius: 16.0,
                                      ),
                                      SizedBox(width: 4.0),
                                      CircleAvatar(
                                        backgroundImage: NetworkImage('https://via.placeholder.com/40'), // Replace with your image URL
                                        radius: 16.0,
                                      ),
                                      SizedBox(width: 4.0),
                                      CircleAvatar(
                                        backgroundImage: NetworkImage('https://via.placeholder.com/40'), // Replace with your image URL
                                        radius: 16.0,
                                      ),
                                      SizedBox(width: 8.0),
                                      Text(
                                        '+20 Going',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'By Šime',
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.grey,
                                        size: 16.0,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'How does it work?',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        children: [
                          Lottie.asset('/Users/karlokovacevic/Documents/team_coffee/assets/image/animation02.json',
                          width:130,
                          height:130,
                          fit:BoxFit.fill),
                    SizedBox(width: 8.0),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: 'Discover, Order, Enjoy: ',
                        style: TextStyle(
                          fontSize: 18.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Your Team\'s Snack Experience Made Simple',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 17
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                        ]

                      ),

                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

