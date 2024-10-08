import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team_coffee/models/group/join_group.dart';

import '../../base/show_custom_snackbar.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/notification_controller.dart';
import '../../routes/route_helper.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../utils/string_resources.dart';
import '../app_text_field.dart';

class JoinGroupWidget extends StatefulWidget {
  final AuthController controller;
  final String page;

  const JoinGroupWidget(
      {Key? key, required this.controller, required this.page})
      : super(key: key);

  @override
  _JoinGroupWidgetState createState() => _JoinGroupWidgetState();
}

class _JoinGroupWidgetState extends State<JoinGroupWidget> {
  final notificationController = Get.find<NotificationController>();

  final TextEditingController groupPasswordController = TextEditingController();
  final TextEditingController groupNameController = TextEditingController();

  @override
  void dispose() {
    groupPasswordController.dispose();
    groupNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var groupPasswordController = TextEditingController();
    var groupNameController = TextEditingController();

    void login(AuthController authController) {
      String name = groupNameController.text.trim();
      String password = groupPasswordController.text.trim();

      if (name.isEmpty) {
        showCustomSnackBar("Type in group name", title: "Group name");
      } else if (password.isEmpty) {
        showCustomSnackBar("Type in group password", title: "Password");
      } else if (password.length < 3) {
        showCustomSnackBar("Password needs to be at least 3 characters long",
            title: "Password");
      } else {
        authController
            .joinGroup(JoinGroup(name: name, password: password),
                notificationController)
            .then((status) async {
          if (status.isSuccess) {
            showCustomSnackBar("Success joining your group",
                isError: false,
                title: "Success",
                color: AppColors.mainBlueColor);
            print("PAGE -> " + widget.page);
            if (widget.page == "first") {
              Get.offNamed(RouteHelper.groupListPage);
            } else {
              print("PAGE -> " + widget.page);
              Get.back();
            }
          } else {
            showCustomSnackBar(status.message);
          }
        });
      }
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: Dimensions.height20 * 2,
          ),
          AppTextField(
              textController: groupNameController,
              hintText: "Group name".tr,
              icon: Icons.people_outline),
          SizedBox(
            height: Dimensions.height20,
          ),
          AppTextField(
            textController: groupPasswordController,
            hintText: AppStrings.pass.tr,
            icon: Icons.lock_outline,
            isObscure: true,
          ),
          SizedBox(
            height: Dimensions.height20 * 2,
          ),
          GestureDetector(
            onTap: () {
              login(widget.controller);
            },
            child: Container(
              width: Dimensions.screenWidth / 1.6,
              height: Dimensions.screenHeight / 14,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius30),
                  color: AppColors.mainColor),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                  color: AppColors.mainBlueMediumColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "CONTINUE".tr,
                      style: TextStyle(
                          color: Colors.white, fontSize: Dimensions.font16),
                    ),
                    SizedBox(
                      width: Dimensions.width30 * 1.65,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(Dimensions.radius30),
                        color: AppColors.mainBlueDarkColor,
                      ),
                      child: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: Dimensions.width20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
