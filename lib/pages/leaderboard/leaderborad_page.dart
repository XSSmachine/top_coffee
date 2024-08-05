import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/user_controller.dart';
import '../../models/user_model.dart';

/// This class will display leaderboard with top 10 users in the group

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final UserController userController = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    userController.getLeaderBoard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
      ),
      body: GetBuilder<UserController>(
        builder: (controller) {
          return ListView.builder(
            itemCount: controller.allUserList.length,
            itemBuilder: (context, index) {
              UserModel user = controller.allUserList[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: user.photoUri != null
                      ? NetworkImage(user.photoUri!)
                      : const AssetImage('assets/image/user.png')
                          as ImageProvider,
                ),
                title: Text(user.name ?? 'Unknown User'),
                subtitle: Row(
                  children: [
                    const Icon(Icons.event, size: 16),
                    const SizedBox(width: 4),
                    Text('${user.orderCount ?? 0}'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, size: 16, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text('${user.score ?? 0}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    if (index == 0)
                      const Icon(Icons.emoji_events, color: Colors.amber),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
