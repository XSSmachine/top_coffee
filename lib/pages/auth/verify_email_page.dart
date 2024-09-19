import 'package:android_intent_plus/flag.dart';
import 'package:flutter/material.dart';
import 'package:android_intent_plus/android_intent.dart';

import 'dart:io' show Platform;

import 'package:get/get.dart';
import 'package:team_coffee/pages/auth/name_surname_page.dart';

import '../../controllers/auth_controller.dart';
import '../../utils/dimensions.dart';
import '../../utils/string_resources.dart';

class VerifyEmailScreen extends StatefulWidget {
  final String email;

  const VerifyEmailScreen({Key? key, required this.email}) : super(key: key);

  @override
  _VerifyEmailScreenState createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  late Future<bool> _isEmailVerified;

  @override
  void initState() {
    super.initState();
    _isEmailVerified = _checkIsEmailVerified();
  }

  void _openEmailApp() async {
    if (Platform.isAndroid) {
      const intent = AndroidIntent(
        action: 'android.intent.action.MAIN',
        category: 'android.intent.category.APP_EMAIL',
        flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
      );
      intent.launch().catchError((e) {
        print("${AppStrings.emailIntentErrorMsg.tr} $e");
      });
    }
  }

  void _continueRegistration(AuthController controller) {
    controller.checkEmail(widget.email);
    Get.to(NameSurnamePage());
  }

  Future<bool> _checkIsEmailVerified() async {
    print("I am verifying this email -> ${widget.email}");
    final controller = Get.find<AuthController>();
    return await controller.checkEmail(widget.email);
  }

  Future<void> _refreshEmailVerification() async {
    setState(() {
      _isEmailVerified = _checkIsEmailVerified();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: FutureBuilder<bool>(
              future: _isEmailVerified,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text(AppStrings.emailCheckingStatus.tr);
                }
                return Text(snapshot.data == true
                    ? AppStrings.emailVerifiedMsg.tr
                    : AppStrings.emailWarningMsg.tr);
              },
            ),
            automaticallyImplyLeading: false,
          ),
          body: RefreshIndicator(
            onRefresh: _refreshEmailVerification,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(Dimensions.height15),
                    child: FutureBuilder<bool>(
                      future: _isEmailVerified,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        final isVerified = snapshot.data == true;
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.email,
                              size: Dimensions.height20 * 4,
                              color: Theme.of(context).primaryColor,
                            ),
                            SizedBox(height: Dimensions.height20 * 1.2),
                            Text(
                              isVerified
                                  ? AppStrings.emailVerifiedMsg.tr
                                  : AppStrings.emailWarningMsg.tr,
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            SizedBox(height: Dimensions.height15),
                            if (!isVerified)
                              Text(
                                AppStrings.emailSentTo.tr,
                                textAlign: TextAlign.center,
                              ),
                            SizedBox(height: Dimensions.height15 / 2),
                            Text(
                              widget.email,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: Dimensions.height20 * 1.2),
                            Text(
                              isVerified
                                  ? AppStrings.continueRegistration.tr
                                  : AppStrings.checkEmail.tr,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: Dimensions.height20 * 1.6),
                            if (!isVerified)
                              ElevatedButton(
                                onPressed: _openEmailApp,
                                child: Text(AppStrings.openEmail.tr),
                              ),
                            SizedBox(height: Dimensions.height20 * 1.6),
                            if (isVerified)
                              ElevatedButton(
                                onPressed: () =>
                                    _continueRegistration(controller),
                                child: Text(AppStrings.finishRegistration.tr),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
