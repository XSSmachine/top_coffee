import 'package:android_intent_plus/flag.dart';
import 'package:flutter/material.dart';
import 'package:android_intent_plus/android_intent.dart';

import 'dart:io' show Platform;

import 'package:get/get.dart';
import 'package:team_coffee/pages/auth/name_surname_page.dart';

import '../../controllers/auth_controller.dart';

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
        print("Error opening email app: $e");
      });
    }
  }

  void _continueRegistration(AuthController controller) {
    controller.checkEmail(widget.email);
    Get.to(NameSurnamePage());
  }

  Future<bool> _checkIsEmailVerified() async {
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
                  return Text('Checking email status...');
                }
                return Text(snapshot.data == true
                    ? 'Email is verified'
                    : 'Verify Your Email');
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
                    padding: const EdgeInsets.all(16.0),
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
                              size: 80,
                              color: Theme.of(context).primaryColor,
                            ),
                            SizedBox(height: 24),
                            Text(
                              isVerified
                                  ? 'Email is verified'
                                  : 'Verify Your Email',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            SizedBox(height: 16),
                            if (!isVerified)
                              Text(
                                'We\'ve sent a verification email to:',
                                textAlign: TextAlign.center,
                              ),
                            SizedBox(height: 8),
                            Text(
                              widget.email,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 24),
                            Text(
                              isVerified
                                  ? 'Please continue your registration.'
                                  : 'Please check your email and click on the verification link to complete your registration.',
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 32),
                            if (!isVerified)
                              ElevatedButton(
                                onPressed: _openEmailApp,
                                child: Text('Open Email App'),
                              ),
                            SizedBox(height: 32),
                            if (isVerified)
                              ElevatedButton(
                                onPressed: () =>
                                    _continueRegistration(controller),
                                child: Text('Finish your registration'),
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
