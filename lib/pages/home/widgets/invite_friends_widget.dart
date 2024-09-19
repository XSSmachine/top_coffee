import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:share_plus/share_plus.dart';
import '../../../controllers/auth_controller.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimensions.dart';
import '../../../utils/string_resources.dart';

class CustomCard extends StatelessWidget {
  AuthController authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: Dimensions.width10,
          right: Dimensions.width10,
          top: Dimensions.height20,
          bottom: Dimensions.height15),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius15),
        ),
        elevation: 4,
        child: Container(
          height: Dimensions.height20 * 8, // Adjust height as per your design

          decoration: BoxDecoration(
            color: Colors.white, // Background color similar to the image
            borderRadius: BorderRadius.circular(Dimensions.radius15),
          ),
          child: Stack(
            children: [
              // Left side content (Title, Subtitle, Button)
              Positioned(
                right: Dimensions.width10 / 2,
                top: 0,
                bottom: -Dimensions.height10 * 4,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.radius30 * 5),
                  child: Image.asset(
                    'assets/image/invite_image2.jpg', // Replace with your image asset
                    height: Dimensions.width20 * 9,
                    width: Dimensions.width20 * 9,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              Positioned(
                left: Dimensions.height15,
                top: Dimensions.height15,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.inviteFriends.tr,
                      style: TextStyle(
                        fontSize: Dimensions.font20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: Dimensions.height10),
                    Text(
                      AppStrings.shareMealsTogether.tr,
                      style: TextStyle(
                        fontSize: Dimensions.font16,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: Dimensions.height15),
                    Row(
                      children: [
                        SizedBox(
                          width: Dimensions.width20 * 1.3,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            String userProfileId = authController.getUserId();
                            String groupId = await authController.getGroupId();
                            String groupName =
                                await authController.getGroupName(groupId);
                            String link = await authController
                                .generateInviteLink(userProfileId);
                            link = link.replaceAll('localhost',
                                'lobster-app-6i7x3.ondigitalocean.app');

                            Share.share(
                                "${AppStrings.joinGroup} $groupName ${AppStrings.followLink.tr}: $link");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.mainBlueDarkColor,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(Dimensions.radius15),
                            ),
                          ),
                          child: Text(
                            AppStrings.inviteBtn.tr,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: Dimensions.font16),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Right side image
            ],
          ),
        ),
      ),
    );
  }
}
