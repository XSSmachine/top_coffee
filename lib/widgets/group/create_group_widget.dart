import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team_coffee/models/group/create_group.dart';

import '../../base/show_custom_snackbar.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/notification_controller.dart';
import '../../routes/route_helper.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../utils/string_resources.dart';
import '../app_text_field.dart';

class CreateGroupWidget extends StatefulWidget {
  final AuthController controller;
  final String page;

  const CreateGroupWidget(
      {Key? key, required this.controller, required this.page})
      : super(key: key);

  @override
  _CreateGroupWidgetState createState() => _CreateGroupWidgetState();
}

class _CreateGroupWidgetState extends State<CreateGroupWidget> {
  final NotificationController notificationController =
      Get.find<NotificationController>();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController password2Controller = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
    password2Controller.dispose();
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void createGroup(AuthController authController) {
      String name = nameController.text.trim();
      String description = descriptionController.text.trim();
      String password = passwordController.text.trim();
      String password2 = password2Controller.text.trim();

      if (name.isEmpty) {
        showCustomSnackBar("Type in your first name", title: "First name");
      } else if (description.isEmpty) {
        showCustomSnackBar("Type in your last name", title: "Last name");
      } else if (password2.isEmpty) {
        showCustomSnackBar("Type in correct password",
            title: "Confirm password");
      } else if (password != password2) {
        showCustomSnackBar("Type in correct password",
            title: "Confirm password");
      } else if (password.isEmpty) {
        showCustomSnackBar("Type in your password", title: "Password");
      } else if (password.length < 3) {
        showCustomSnackBar("Password needs to be at least 3 characters long",
            title: "Password");
      } else {
        CreateGroup signUpBody = CreateGroup(
            name: name, password: password, description: description);
        authController
            .createGroup(signUpBody, notificationController)
            .then((status) async {
          if (status.isSuccess) {
            print('Success group creating');
            print(widget.page);
            if (widget.page == "first") {
              Get.offNamed(RouteHelper.groupListPage);
            } else {
              Get.back();
            }
            showCustomSnackBar(status.message,
                isError: false,
                title: "Success",
                color: AppColors.mainBlueColor);
          } else if (status.message == "400") {
            print("ERROR ${status.message}");
            showCustomSnackBar(
                "Warning".tr + " " + "That name is already taken".tr);
          } else {
            print("ERROR ${status.message}");
            showCustomSnackBar(status.message);
          }
        });
      }
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          // your name
          SizedBox(
            height: Dimensions.height20 * 1.5,
          ),
          AppTextField(
              textController: nameController,
              hintText: "Group name".tr,
              icon: Icons.people_outline),
          SizedBox(
            height: Dimensions.height20,
          ),

          AppTextField(
            textController: descriptionController,
            hintText: "Short description".tr,
            icon: Icons.description_outlined,
            minLines: 2,
            maxLines: 3,
            isMultiline: true,
          ),
          SizedBox(
            height: Dimensions.height20,
          ),
          //your password
          AppTextField(
            textController: passwordController,
            hintText: "Your password".tr,
            icon: Icons.lock_outline,
            isObscure: true,
          ),
          SizedBox(
            height: Dimensions.height20,
          ),
          //
          AppTextField(
            textController: password2Controller,
            hintText: "Confirm password".tr,
            icon: Icons.lock_outline,
            isObscure: true,
          ),
          SizedBox(height: Dimensions.height20 * 1.5),
          GestureDetector(
            onTap: () {
              createGroup(widget.controller);
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
                  color: AppColors.mainBlueColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      AppStrings.createTitle.tr,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: Dimensions.font16,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      width: Dimensions.width30 * 1.85,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(Dimensions.radius30),
                        color: AppColors.mainBlueColor,
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
