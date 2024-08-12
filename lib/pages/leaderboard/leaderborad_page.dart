import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team_coffee/utils/app_constants.dart';

import '../../controllers/user_controller.dart';
import '../../models/user_model.dart';
import '../../utils/dimensions.dart';

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
    _initializeLeaderboard();
  }

  Future<void> _initializeLeaderboard() async {
    await userController.getLeaderBoard();
  }

  Future<void> _refreshLeaderboard() async {
    await userController.getLeaderBoard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
      ),
      body: GetBuilder<UserController>(
        builder: (controller) {
          if (controller.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          return RefreshIndicator(
            onRefresh: _refreshLeaderboard,
            child: ListView.builder(
              itemCount: controller.allUserList.length,
              itemBuilder: (context, index) {
                UserModel user = controller.allUserList[index];
                return ListTile(
                  leading: CircleAvatar(
                    radius: Dimensions.radius30,
                    backgroundImage: user.photoUri != null
                        ? NetworkImage(user.photoUri!)
                        : const AssetImage('assets/image/user.png')
                            as ImageProvider,
                  ),
                  title: Text(
                    user.name ?? 'Unknown User',
                    style: TextStyle(
                        fontSize: index != 0
                            ? Dimensions.font20 * 0.8
                            : Dimensions.font20),
                  ),
                  subtitle: Row(
                    children: [
                      Icon(Icons.event, size: Dimensions.iconSize16),
                      const SizedBox(width: 4),
                      Text('${user.orderCount ?? 0}'),
                    ],
                  ),
                  trailing: user.score != 0.0
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star,
                                size: Dimensions.iconSize24,
                                color: Colors.amber),
                            SizedBox(width: 4),
                            Text(user.score!.toStringAsFixed(2),
                                style: TextStyle(
                                    fontSize: Dimensions.font20,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(width: 8),
                            if (index == 0)
                              Icon(
                                Icons.emoji_events,
                                color: Colors.amber,
                                size: Dimensions.iconSize24 * 1.4,
                              ),
                          ],
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.accessible_outlined,
                                size: Dimensions.iconSize24,
                                color: Colors.brown),
                            const SizedBox(width: 4),
                            Text('UNRANKED',
                                style: TextStyle(
                                    fontSize: Dimensions.font16 * 0.8,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(width: 4),
                          ],
                        ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
