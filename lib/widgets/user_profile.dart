import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:team_coffee/models/fetch_me_model.dart';

import '../controllers/user_controller.dart';
import '../utils/colors.dart';
import '../utils/dimensions.dart';

class WordCustomCard extends StatefulWidget {
  final FetchMeModel user;
  final UserController userController;
  final Function() onEditProfile;

  const WordCustomCard(
      {super.key,
      required this.user,
      required this.userController,
      required this.onEditProfile});

  @override
  _WordCustomCardState createState() => _WordCustomCardState();
}

class _WordCustomCardState extends State<WordCustomCard> {
  @override
  void initState() {
    super.initState();
    fetchProfilePicture();
  }

  Future<void> fetchProfilePicture() async {
    await widget.userController.fetchProfilePhoto();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Card(
          color: Colors.white,
          margin: const EdgeInsets.only(top: 50),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(() {
                  if (widget.userController.profileImage.value != null) {
                    return CircleAvatar(
                      radius: 80,
                      backgroundImage: MemoryImage(
                          widget.userController.profileImage.value!),
                    );
                  } else {
                    return const CircleAvatar(
                      radius: 80,
                      child: Icon(Icons.person, size: 80),
                    );
                  }
                }),
                SizedBox(height: Dimensions.height30), // Space for the image
                Text(
                  '${widget.user.name} ${widget.user.surname}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          '350',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Orders',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 20),
                    Column(
                      children: [
                        Text(
                          '106',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Events',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: widget.onEditProfile,
                  icon: const Icon(Icons.edit),
                  label: const Text(
                    'Edit Profile',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: AppColors.mainBlueColor,
                    backgroundColor: Colors.white,
                    side: const BorderSide(
                        color: AppColors.mainBlueColor, width: 2.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
