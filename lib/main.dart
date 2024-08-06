import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team_coffee/firebase_options.dart';
import 'package:team_coffee/routes/route_helper.dart';
import 'controllers/auth_controller.dart';
import 'data/api/firebase_api.dart';
import 'helper/dependencies.dart' as dependencies;
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseApi().initNotifications();

  await dependencies.init();
  await Get.find<AuthController>().fetchMe();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'SyncSnack',
      debugShowCheckedModeBanner: false,
      //home: GroupPage(),
      initialRoute: RouteHelper.splashPage,
      getPages: RouteHelper.routes,
    );
  }
}
