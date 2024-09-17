import 'package:get/get.dart';
import 'package:flutter/material.dart';

class LocaleController extends GetxController {
  var locale = const Locale('hr', 'HR').obs;

  void changeLocale(String languageCode, String countryCode) {
    locale.value = Locale(languageCode, countryCode);
    Get.updateLocale(locale.value);
  }
}
