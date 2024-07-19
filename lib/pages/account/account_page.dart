import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/user_controller.dart';
import '../../routes/route_helper.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/account_widget.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/big_text.dart';
import '../../widgets/stats_value_title.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final AuthController authController = Get.find<AuthController>();
  final UserController userController = Get.find<UserController>();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await authController.fetchAndSetUserToken();
    if (authController.userLoggedIn()) {
      print("User Token: ${authController.userToken}");
      await userController.getUserId(authController.userToken);
      await userController.getUserInfo();
      print("User has logged in");
    }
    setState(() {
      _isInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: authController.userLoggedIn()
          ? _buildLoggedInView()
          : _buildSignInPrompt(context),
    );
  }

  Widget _buildLoggedInView() {
    return GetBuilder<UserController>(
        builder: (userController) {
          return Container(
            width: double.maxFinite,
            margin: EdgeInsets.only(top: Dimensions.height30*2),
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: Dimensions.height30*10,
                      margin: EdgeInsets.only(right: 20,left: 20,top: Dimensions.height30*1.75),
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: AppColors.mainColor,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: Dimensions.height20*3,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.star,
                                  color: Colors.amberAccent,
                                  size: Dimensions.iconSize24),
                              SizedBox(width: 5,),
                              BigText(text: userController.user?.score==0?"4.00":userController.user?.score.toString().substring(0,3) ?? "5.00", size: 24,)
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              BigText(text: userController.user?.name ?? "User name", size: 32,),
                              SizedBox(width: Dimensions.width10,),
                              BigText(text: userController.user?.surname ?? "User name", size: 32,),
                            ],
                          ),

                          BigText(text: userController.user?.email ?? "user.name@kava.com", size: 16,),
                          SizedBox(height: Dimensions.height20,),
                          Padding(
                            padding: EdgeInsets.only(top: Dimensions.height20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                StatsValueTitle(title: "# of coffees made", dataValue:  userController.user?.coffeeNumber.toString() ?? "16"),
                                StatsValueTitle(title: "time per coffee", dataValue:  "2.15 min")
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: AppIcon(icon: Icons.person, backgroungColor: AppColors.iconColor1,
                        iconColor: Colors.white,iconSize: Dimensions.height30*2.5,size: Dimensions.height30*4.5,),
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: Dimensions.height20,),
                        AccountWidget(appIcon: AppIcon(icon: Icons.message_outlined, backgroungColor: AppColors.titleColor,
                          iconColor: Colors.white,iconSize: Dimensions.height10*2.5,size: Dimensions.height10*5,),
                            bigText: BigText(text: "Messages",)),
                        SizedBox(height: Dimensions.height20,),
                        GestureDetector(
                          onTap: () {
                            Get.find<AuthController>().clearSharedData();
                            Get.toNamed(RouteHelper.getSignInPage());
                          },
                          child: AccountWidget(appIcon: AppIcon(icon: Icons.logout, backgroungColor: Colors.redAccent,
                            iconColor: Colors.white,iconSize: Dimensions.height10*2.5,size: Dimensions.height10*5,),
                              bigText: BigText(text: "Logout",)),
                        ),
                        Container(),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        }
    );
  }

  Widget _buildSignInPrompt(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              width: double.maxFinite,
              height: Dimensions.height20*8,
              margin: EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radius20),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/image/signintocontinue.png")
                ),
              )
          ),
          SizedBox(height: Dimensions.height20),
          GestureDetector(
            onTap: () {
              Get.toNamed(RouteHelper.getSignInPage());
            },
            child: Container(
              width: double.maxFinite,
              height: Dimensions.height20*5,
              margin: EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20),
              decoration: BoxDecoration(
                color: AppColors.mainColor,
                borderRadius: BorderRadius.circular(Dimensions.radius20),
              ),
              child: Center(
                child: BigText(
                  text: "Sign in",
                  color: Colors.white,
                  size: Dimensions.font20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}