import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team_coffee/controllers/event_controller.dart';
import 'package:team_coffee/controllers/order_controller.dart';
import 'package:team_coffee/models/fetch_me_model.dart';
import 'package:team_coffee/pages/account/widgets/flag_icon_widget.dart';
import 'package:team_coffee/widgets/user_profile.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/user_controller.dart';
import '../../routes/route_helper.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../utils/string_resources.dart';
import '../../widgets/big_text.dart';
import '../../widgets/edit_profile_widget.dart';
import '../group/edit_group_screen.dart';

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
      await userController.getUserProfile();
      await userController.fetchProfilePhoto(); // Add this line
      setState(() {});
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
          "${userData!.firstName}/${userData.lastName}/${userData.userProfileId}/${userData.groupMembershipData}");
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
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Column(
                children: [
                  WordCustomCard(
                    user: Get.find<UserController>().user!,
                    userController: Get.find<UserController>(),
                    onEditProfile: _showEditProfileDialog,
                  ),
                  SizedBox(
                    height: Dimensions.height10,
                  ),
                  Card(
                    margin: EdgeInsets.all(Dimensions.width10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimensions.radius15),
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(Dimensions.radius15),
                          child: ColorFiltered(
                            colorFilter: ColorFilter.mode(
                              Colors.black
                                  .withOpacity(0.5), // Adjust opacity as needed
                              BlendMode.darken,
                            ),
                            child: Image.asset(
                              'assets/image/group_eating.jpg',
                              fit: BoxFit.cover,
                              height: Dimensions.height20 * 8,
                              width: double.infinity,
                            ),
                          ),
                        ),
                        Positioned(
                          top: Dimensions.height10,
                          left: Dimensions.width10,
                          right: Dimensions.width10,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      AppStrings.inviteFriends.tr,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: Dimensions.font20,
                                        fontWeight: FontWeight.w900,
                                        shadows: [
                                          Shadow(
                                            color: Colors.blue.shade900
                                                .withOpacity(0.9),
                                            offset: Offset(0.0, 0.0),
                                            blurRadius: 2,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Icon(Icons.arrow_forward,
                                      color: Colors.white),
                                ],
                              ),
                              SizedBox(height: Dimensions.height10),
                              Text(
                                AppStrings.inviteFriendsDesc.tr,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: Dimensions.font16,
                                  fontWeight: FontWeight.w700,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.9),
                                      offset: Offset(0.0, 0.0),
                                      blurRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Clickable rows
                  _buildClickableRow(
                      Icons.notifications, AppStrings.notifications.tr, () {
                    Get.toNamed(RouteHelper.notificationListPage);
                  }),
                  _buildClickableRow(
                      Icons.support, AppStrings.support.tr, () {}),
                  _buildClickableRow(
                      Icons.groups_rounded, AppStrings.editGroup.tr, () async {
                    final groupId = await authController.getGroupId();
                    Get.to(() => GroupScreen(
                          groupId: groupId,
                        ));
                  }),
                  // Second card
                  Card(
                    margin: EdgeInsets.all(Dimensions.width10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimensions.radius15),
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(Dimensions.radius15),
                          child: Image.asset(
                            'assets/image/food_table.jpg',
                            // Replace with your image
                            fit: BoxFit.cover,
                            height: Dimensions.height20 * 6,
                            width: double.infinity,
                          ),
                        ),
                        Positioned(
                          top: Dimensions.height10,
                          left: Dimensions.width10,
                          right: Dimensions.width10,
                          child: Text(
                            AppStrings.appMoto.tr,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: Dimensions.font16,
                              fontWeight: FontWeight.w800,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.9),
                                  offset: Offset(0.0, 0.0),
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: Dimensions.height10,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: Dimensions.width10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        GestureDetector(
                          onTap: () {
                            authController.clearSharedData();
                            userController.resetAllValues();
                            eventController.resetAllValues();
                            orderController.resetAllValues();
                            Get.toNamed(RouteHelper.getSignInPage());
                          },
                          child: Text(
                            AppStrings.logout.tr,
                            style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: Dimensions.font16 * 0.8),
                          ),
                        ),
                        Text(
                          "${AppStrings.version.tr} 2.0.0",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: Dimensions.font16 * 0.8),
                        ),
                        FlagIconWidget(),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: Dimensions.height20 * 2,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildClickableRow(IconData icon, String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: Dimensions.height10,
          horizontal: Dimensions.width15,
        ),
        child: Row(
          children: [
            Icon(icon, size: Dimensions.iconSize24),
            SizedBox(width: Dimensions.width15),
            Text(text, style: TextStyle(fontSize: Dimensions.font16)),
          ],
        ),
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
