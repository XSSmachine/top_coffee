import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../base/custom_loader.dart';
import '../../base/show_custom_snackbar.dart';
import '../../controllers/auth_controller.dart';
import '../../models/signup_body_model.dart';
import '../../routes/route_helper.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/app_text_field.dart';

class NameSurnamePage extends StatelessWidget {
  NameSurnamePage({super.key});

  var nameController = TextEditingController();
  var surnameController = TextEditingController();

  var alreadyExists = true;
  var signUpImages = ["t.png", "f.png", "g.png"];

  @override
  Widget build(BuildContext context) {
    Future<void> registration(AuthController authController) async {
      String name = nameController.text.trim();
      String surname = surnameController.text.trim();

      if (name.isEmpty) {
        showCustomSnackBar("Type in your first name", title: "First name");
      } else if (surname.isEmpty) {
        showCustomSnackBar("Type in your last name", title: "Last name");
      } else {
        authController.userProfile.value?.name = name;
        authController.userProfile.value?.surname = surname;
        Get.toNamed(RouteHelper.getGroupPage());
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<AuthController>(builder: (authController) {
        return !authController.isLoading
            ? SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(
                      height: Dimensions.screenHeight * 0.07,
                    ),
                    //app logo
                    SizedBox(
                      height: Dimensions.screenHeight * 0.25,
                      child: Center(
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 130,
                          child: Image.asset(
                            "assets/image/chef_register.png",
                            width: 330,
                            height: 330,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Dimensions.height20,
                    ),
                    // your name
                    AppTextField(
                        textController: nameController,
                        hintText: "Name",
                        icon: Icons.person_outline),
                    SizedBox(
                      height: Dimensions.height20,
                    ),
                    //your phone
                    AppTextField(
                        textController: surnameController,
                        hintText: "Surname",
                        icon: Icons.person_rounded),
                    SizedBox(height: Dimensions.height20 * 1.5),

                    GestureDetector(
                      onTap: () async {
                        registration(authController);
                      },
                      child: Container(
                        width: Dimensions.screenWidth / 1.6,
                        height: Dimensions.screenHeight / 14,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(Dimensions.radius30),
                            color: AppColors.mainColor),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(Dimensions.radius20),
                            color: AppColors.mainBlueMediumColor,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "SIGN UP",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: Dimensions.font16),
                              ),
                              SizedBox(
                                width: Dimensions.width30 * 1.65,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radius30),
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
                    SizedBox(
                      height: Dimensions.height10,
                    ),
                    RichText(
                        //clickable text
                        text: TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Get.back(),
                            text: "Have an account already?",
                            style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: Dimensions.font20))),
                    SizedBox(
                      height: Dimensions.screenHeight * 0.05,
                    ),
                    RichText(
                        //clickable text
                        text: TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Get.back(),
                            text: "Use one of the following methods",
                            style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: Dimensions.font16))),
                    Wrap(
                      children: List.generate(
                          3,
                          (index) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  radius: Dimensions.radius30,
                                  backgroundImage: AssetImage(
                                      "assets/image/${signUpImages[index]}"),
                                ),
                              )),
                    )
                  ],
                ),
              )
            : const CustomLoader();
      }),
    );
  }
}
