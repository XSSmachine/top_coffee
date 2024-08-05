import 'package:flutter/material.dart';

import '../splash/splash_page.dart';

class ErrorPage extends StatelessWidget {
  final String message;

  const ErrorPage({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red),
            SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Restart the app or navigate back to the splash screen
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => SplashScreen()),
                  (Route<dynamic> route) => false,
                );
              },
              child: Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
