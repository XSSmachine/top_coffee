import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/dimensions.dart';
import '../../utils/string_resources.dart';
import '../splash/splash_page.dart';

class ErrorPage extends StatelessWidget {
  final String message;

  const ErrorPage({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.errorMsg.tr)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline,
                size: Dimensions.font20 * 3.2, color: Colors.red),
            SizedBox(height: Dimensions.height15),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: Dimensions.font16 * 1.1),
            ),
            SizedBox(height: Dimensions.height20 * 1.2),
            ElevatedButton(
              onPressed: () {
                // Restart the app or navigate back to the splash screen
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => SplashScreen()),
                  (Route<dynamic> route) => false,
                );
              },
              child: Text(AppStrings.tryAgainMsg.tr),
            ),
          ],
        ),
      ),
    );
  }
}
