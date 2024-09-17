import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team_coffee/controllers/event_controller.dart';
import 'package:team_coffee/pages/auth/sign_up_page.dart';

import '../../base/custom_loader.dart';
import '../../base/show_custom_snackbar.dart';
import '../../controllers/auth_controller.dart';
import '../../models/filter_model.dart';
import '../../routes/route_helper.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../utils/string_resources.dart';
import '../../widgets/app_text_field.dart';
import 'name_surname_page.dart';

/// This class displays log in form
class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> with TickerProviderStateMixin {
  EventController eventController = Get.find<EventController>();
  late AnimationController _donutsController;
  late AnimationController _friesController;
  late AnimationController _kafaController;
  late Animation<double> _donutsAnimation;
  late Animation<double> _friesAnimation;
  late Animation<double> _kafaAnimation;
  bool _rememberMe = true;

  @override
  void initState() {
    super.initState();
    _donutsController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _friesController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _kafaController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _donutsAnimation = Tween<double>(begin: 0, end: 30).animate(
      CurvedAnimation(
        parent: _donutsController,
        curve: Curves.easeInOut,
      ),
    );
    _friesAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(
        parent: _friesController,
        curve: Curves.easeInQuad,
      ),
    );
    _kafaAnimation = Tween<double>(begin: 0, end: 20).animate(
      CurvedAnimation(
        parent: _kafaController,
        curve: Curves.easeInOutBack,
      ),
    );

    _donutsController.repeat(reverse: true);
    _friesController.repeat(reverse: true);
    _kafaController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _donutsController.dispose();
    _friesController.dispose();
    _kafaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();

    var passwordController = TextEditingController();

    void login(AuthController authController) {
      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      if (email.isEmpty) {
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
        authController.login(email, password).then((status) {
          if (status.isSuccess) {
            authController.getUserId();
            /*eventController.fetchFilteredEvents(
              page: 0,
              size: eventController.pageSize,
              search: '',
              filters: EventFilters(
                eventType: eventController.selectedEventType.value,
                status: eventController.selectedEventStatus.value,
                timeFilter: eventController.selectedTimeFilter.value,
              ),
            );*/
            ;
            print(AppStrings.successMsg.tr);
            Get.toNamed(RouteHelper.getGroupListPage());
          } else if (status.message == "Email is not verified.") {
            showCustomSnackBar(AppStrings.emailWarningMsg.tr);
            Get.offNamedUntil(
                RouteHelper.getVerifyEmailPage(email), (route) => false);
          } else if (status.message == "User registration is not complete.") {
            showCustomSnackBar(AppStrings.userWarningMsg.tr);
            Get.off(NameSurnamePage());
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
                        height: Dimensions.screenHeight * 0.05,
                      ),
                      //app logo
                      Container(
                        margin: EdgeInsets.zero,
                        height: Dimensions.screenHeight * 0.423,
                        width: double.infinity,
                        child: Stack(
                          children: [
                            Positioned(
                              top: -Dimensions.height10 * 4,
                              right: Dimensions.height30 * 6,
                              child: AnimatedBuilder(
                                animation: _donutsAnimation,
                                builder: (context, child) {
                                  return Transform.translate(
                                    offset: Offset(0, _donutsAnimation.value),
                                    child: Transform.rotate(
                                      angle: _donutsAnimation.value * 0.01,
                                      child: child,
                                    ),
                                  );
                                },
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: Dimensions.radius20 * 6.5,
                                  child: Image.asset(
                                    "assets/image/donuts.png",
                                    width: Dimensions.width10 * 33,
                                    height: Dimensions.width10 * 33,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: Dimensions.width15 * 1.5,
                              right: Dimensions.height30 * 0.2,
                              child: AnimatedBuilder(
                                animation: _kafaAnimation,
                                builder: (context, child) {
                                  return Transform.translate(
                                    offset: Offset(0, _kafaAnimation.value),
                                    child: Transform.rotate(
                                      angle: _kafaAnimation.value * 0.01,
                                      child: child,
                                    ),
                                  );
                                },
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: Dimensions.radius20 * 4,
                                  child: Image.asset(
                                    "assets/image/kafa.png",
                                    width: Dimensions.width10 * 15,
                                    height: Dimensions.width10 * 15,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: Dimensions.height45 * 4.8,
                              right: Dimensions.height30 * 2.2,
                              child: AnimatedBuilder(
                                animation: _friesAnimation,
                                builder: (context, child) {
                                  return Transform.translate(
                                    offset: Offset(0, _friesAnimation.value),
                                    child: Transform.rotate(
                                      angle: _friesAnimation.value * 0.01,
                                      child: child,
                                    ),
                                  );
                                },
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: Dimensions.radius20 * 3.5,
                                  child: Image.asset(
                                    "assets/image/fries.png",
                                    width: Dimensions.width10 * 18,
                                    height: Dimensions.width10 * 18,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Sync",
                                      style: TextStyle(
                                          fontSize: Dimensions.font20 * 2,
                                          fontWeight: FontWeight.w600,
                                          height: 0.8),
                                    ),
                                    Text(
                                      "Snack",
                                      style: TextStyle(
                                          fontSize: Dimensions.font20 * 2,
                                          fontWeight: FontWeight.w900,
                                          height: 0.8),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: Dimensions.height45 * 7.1,
                              right: Dimensions.height30 * 7.8,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.radius20),
                                    color: Colors.white),
                                child: Text(
                                  AppStrings.signIn.tr,
                                  style: TextStyle(
                                    fontSize: Dimensions.font20 * 1.5,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: Dimensions.height20),
                      //your email
                      AppTextField(
                        textController: emailController,
                        hintText: AppStrings.email.tr,
                        icon: Icons.email_outlined,
                      ),
                      SizedBox(height: Dimensions.height20),
                      //your password
                      AppTextField(
                        textController: passwordController,
                        hintText: AppStrings.pass.tr,
                        icon: Icons.lock_outline,
                        isObscure: true,
                      ),
                      SizedBox(height: Dimensions.height20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            Switch.adaptive(
                              value: _rememberMe,
                              activeColor: AppColors.mainBlueMediumColor,
                              onChanged: (bool value) {
                                setState(() {
                                  _rememberMe = value;
                                });
                              },
                            ),
                            SizedBox(
                              width: Dimensions.width10 * 0.80,
                            ),
                            Text(
                              AppStrings.rememberMe.tr,
                              style: TextStyle(
                                  fontSize: Dimensions.font16 * 0.90,
                                  fontWeight: FontWeight.w400),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                // Navigate to forgot password page
                              },
                              child: Text(
                                AppStrings.forgotPass.tr,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: Dimensions.font16 * 0.85,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: Dimensions.screenHeight * 0.05),
                      GestureDetector(
                        onTap: () {
                          login(authController);
                        },
                        child: Container(
                          width: Dimensions.screenWidth / 1.6,
                          height: Dimensions.screenHeight / 14,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(Dimensions.radius15),
                            color: AppColors.mainBlueDarkColor,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                AppStrings.signInBold.tr,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: Dimensions.font16,
                                ),
                              ),
                              SizedBox(width: Dimensions.width30 * 1.65),
                              Container(
                                padding:
                                    EdgeInsets.all(Dimensions.height15 / 3),
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
                              SizedBox(width: Dimensions.width20),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: Dimensions.screenHeight * 0.05),
                      RichText(
                          text: TextSpan(
                        text: "${AppStrings.noAccountQuestion.tr} ",
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: Dimensions.font20,
                        ),
                        children: [
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Get.to(
                                    () => SignUpPage(),
                                    transition: Transition.fade,
                                  ),
                            text: AppStrings.signUp.tr,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.mainBlackColor,
                              fontSize: Dimensions.font20,
                            ),
                          ),
                        ],
                      )),
                    ],
                  ),
                )
              : const CustomLoader();
        }));
  }
}
