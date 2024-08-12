import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team_coffee/controllers/event_controller.dart';
import 'package:team_coffee/controllers/order_controller.dart';
import 'package:team_coffee/models/fetch_me_model.dart';
import 'package:team_coffee/widgets/user_profile.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/user_controller.dart';
import '../../routes/route_helper.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/account_widget.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/big_text.dart';
import '../../widgets/edit_profile_widget.dart';

/// This class displays user profile
class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  bool _isInitialized = false;
  final AuthController authController = Get.find<AuthController>();
  final UserController userController = Get.find<UserController>();
  final EventController eventController = Get.find<EventController>();
  final OrderController orderController = Get.find<OrderController>();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _showEditProfileDialog() async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          initialData: userController.user!,
          userController: userController,
        );
      },
    );

    if (result == true) {
      // Profile updated successfully, refresh the user data
      await userController.getUserProfile();
      setState(() {}); // Rebuild the widget to reflect changes
    }
  }

  Future<void> _initializeData() async {
    await authController.fetchAndSetUserToken();
    if (authController.userLoggedIn()) {
      print("User Token: ${authController.userToken}");
      await Get.find<UserController>().getUserProfile();
      FetchMeModel? userData = Get.find<UserController>().user;
      print("User has logged in");
      print(
          "${userData!.name}/${userData.surname}/${userData.profileId}/${userData.groupId}");
    }
    setState(() {
      _isInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: authController.userLoggedIn()
          ? _buildLoggedInView()
          : _buildSignInPrompt(context),
    );
  }

  Widget _buildLoggedInView() {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(top: Dimensions.height30 * 1),
      child: Column(
        children: [
          WordCustomCard(
            user: Get.find<UserController>().user!,
            userController: Get.find<UserController>(),
            onEditProfile: _showEditProfileDialog,
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: Dimensions.height20,
                  ),
                  AccountWidget(
                      appIcon: AppIcon(
                        icon: Icons.message_outlined,
                        backgroungColor: AppColors.titleColor,
                        iconColor: Colors.white,
                        iconSize: Dimensions.height10 * 2.5,
                        size: Dimensions.height10 * 5,
                      ),
                      bigText: BigText(
                        text: "Messages",
                      )),
                  SizedBox(
                    height: Dimensions.height20,
                  ),
                  GestureDetector(
                    onTap: () {
                      authController.clearSharedData();
                      userController.resetAllValues();
                      eventController.resetAllValues();
                      orderController.resetAllValues();
                      Get.toNamed(RouteHelper.getSignInPage());
                    },
                    child: AccountWidget(
                        appIcon: AppIcon(
                          icon: Icons.logout,
                          backgroungColor: Colors.black,
                          iconColor: Colors.white,
                          iconSize: Dimensions.height10 * 2.5,
                          size: Dimensions.height10 * 5,
                        ),
                        bigText: BigText(
                          text: "Logout",
                        )),
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

  Widget _buildSignInPrompt(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              width: double.maxFinite,
              height: Dimensions.height20 * 8,
              margin: EdgeInsets.only(
                  left: Dimensions.width20, right: Dimensions.width20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radius20),
                image: const DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/image/signintocontinue.png")),
              )),
          SizedBox(height: Dimensions.height20),
          GestureDetector(
            onTap: () {
              Get.toNamed(RouteHelper.getSignInPage());
            },
            child: Container(
              width: double.maxFinite,
              height: Dimensions.height20 * 5,
              margin: EdgeInsets.only(
                  left: Dimensions.width20, right: Dimensions.width20),
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
