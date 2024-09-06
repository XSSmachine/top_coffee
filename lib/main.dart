import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:team_coffee/firebase_options.dart';
import 'package:team_coffee/routes/route_helper.dart';
import 'package:team_coffee/utils/translation_maps.dart';
import 'controllers/auth_controller.dart';
import 'controllers/notification_controller.dart';
import 'data/api/firebase_api.dart';
import 'helper/deeplink_handler.dart';
import 'helper/dependencies.dart' as dependencies;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseApi().initNotifications();
  await dependencies.init();
  await Get.find<NotificationController>().requestPermission();
  //final AppLinksDeepLink _appLinksDeepLink = AppLinksDeepLink.instance;
  //await _appLinksDeepLink.initDeepLinks();

  await Get.find<AuthController>().fetchMe();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: Messages(),
      locale: Get.deviceLocale,
      fallbackLocale:
          Locale('hr', 'HR'), // Fallback language in case of failure
      supportedLocales: [
        Locale('en', 'US'),
        Locale('hr', 'HR'),
        // Add other supported locales here
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      title: 'SyncSnack',
      debugShowCheckedModeBanner: false,
      //home: GroupPage(),
      initialRoute: RouteHelper.splashPage,
      getPages: RouteHelper.routes,
    );
  }
}
