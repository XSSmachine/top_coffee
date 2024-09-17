import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team_coffee/pages/auth/sign_in_page.dart';
import 'package:team_coffee/pages/auth/verify_email_page.dart';
import '../../base/custom_loader.dart';
import '../../base/show_custom_snackbar.dart';
import '../../controllers/auth_controller.dart';
import '../../models/signup_body_model.dart';
import '../../routes/route_helper.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../utils/string_resources.dart';
import '../../widgets/app_text_field.dart';

/// This class displays sign up form

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();

  var alreadyExists = true;
  //var signUpImages = ["t.png", "f.png", "g.png"];

  @override
  Widget build(BuildContext context) {
    Future<void> registration(AuthController authController) async {
      String confirmPassword = confirmPasswordController.text.trim();
      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      if (password != confirmPassword) {
        showCustomSnackBar(AppStrings.sameConfirmPass.tr,
            title: AppStrings.confirmPass.tr);
      } else if (confirmPassword.isEmpty) {
        showCustomSnackBar(AppStrings.confirmPass.tr,
            title: AppStrings.confirmPass.tr);
      } else if (email.isEmpty) {
        showCustomSnackBar(AppStrings.typeInEmail.tr,
            title: AppStrings.email.tr);
      } else if (!GetUtils.isEmail(email)) {
        showCustomSnackBar(AppStrings.typeInEmail.tr,
            title: "${AppStrings.valid.tr} ${AppStrings.email}");
      } else if (password.isEmpty) {
        showCustomSnackBar(AppStrings.typeInPassword.tr,
            title: AppStrings.pass.tr);
      } else if (password.length < 3) {
        showCustomSnackBar(AppStrings.passWarningMsg.tr,
            title: AppStrings.pass.tr);
      } else {
        SignupBody signUpBody = SignupBody(
          email: email,
          password: password,
        );
        authController.registration(signUpBody).then((status) {
          if (status.isSuccess) {
            showCustomSnackBar(AppStrings.successRegistration.tr,
                isError: false,
                title: AppStrings.successMsg.tr,
                color: AppColors.mainBlueColor);
            Get.offNamedUntil(
                RouteHelper.getVerifyEmailPage(email), (route) => false);
          } else {
            showCustomSnackBar(status.message);
          }
        });
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
                          radius: Dimensions.radius20 * 6.5,
                          child: Image.asset(
                            "assets/image/chef_register.png",
                            width: Dimensions.width10 * 33,
                            height: Dimensions.width10 * 33,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Dimensions.height20,
                    ),
                    //your email
                    AppTextField(
                        textController: emailController,
                        hintText: AppStrings.email.tr,
                        icon: Icons.email_outlined),
                    SizedBox(
                      height: Dimensions.height20,
                    ),
                    //your password
                    AppTextField(
                      textController: passwordController,
                      hintText: AppStrings.pass.tr,
                      icon: Icons.lock_outline,
                      isObscure: true,
                    ),
                    SizedBox(
                      height: Dimensions.height20,
                    ),
                    AppTextField(
                      textController: confirmPasswordController,
                      hintText: AppStrings.confirmPass.tr,
                      icon: Icons.lock_outline,
                      isObscure: true,
                    ),
                    SizedBox(
                      height: Dimensions.height20,
                    ),
                    // your name

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
                                AppStrings.signUpBold,
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
                              ..onTap = () {
                                if (Get.previousRoute.isNotEmpty) {
                                  Get.back();
                                } else {
                                  // Handle the case when there's no previous route
                                  Get.offAll(() =>
                                      SignInPage()); // Replace with your login page
                                }
                              },
                            text: AppStrings.confirmQuestionAccount.tr,
                            style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: Dimensions.font20))),
                    SizedBox(
                      height: Dimensions.screenHeight * 0.05,
                    ),
                    /*RichText(
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
                    )*/
                  ],
                ),
              )
            : const CustomLoader();
      }),
    );
  }
}
