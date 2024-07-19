import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controllers/user_controller.dart';
import '../../models/user_model.dart';




class LeaderboardScreen extends StatefulWidget {
  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {

  @override
  void initState() {
    super.initState();
    _loadResource();
  }

  Future<void> _loadResource() async {
    await Get.find<UserController>().getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    print("current height is " + MediaQuery.of(context).size.height.toString());
    print("current width is " + MediaQuery.of(context).size.width.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboard'),
      ),
      body: GetBuilder<UserController>(
        builder: (userController) {
          if (userController.isLoaded) {
            if (userController.allUserList.isNotEmpty) {
              return RefreshIndicator(
                onRefresh: _loadResource,
                child: ListView.builder(
                  itemCount: userController.allUserList.length,
                  itemBuilder: (context, index) {
                    final user = userController.allUserList[index];
                    print(user.score);
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(
                            '/Users/karlokovacevic/Documents/team_coffee/assets/image/user.png'),
                      ),
                      title: Text('${user.name}'),
                      subtitle: Row(
                        children: [
                          Icon(Icons.coffee, size: 16),
                          SizedBox(width: 4),
                          Text('${user.coffeeNumber}'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, size: 16, color: Colors.amber),
                          SizedBox(width: 4),
                          Text('${user.score?.toStringAsFixed(2)}',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          SizedBox(width: 8),
                          if (index == 0)
                            Icon(Icons.emoji_events, color: Colors.amber),
                        ],
                      ),
                    );
                  },
                ),
              );
            } else {
              return Center(child: Text('No users found'));
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
