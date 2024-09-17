import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/locale_controller.dart';

class FlagIconWidget extends StatelessWidget {
  final LocaleController localeController = Get.find<LocaleController>();

  FlagIconWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isEnglish = localeController.locale.value.languageCode == 'en';
      return GestureDetector(
        onTap: () {
          if (isEnglish) {
            localeController.changeLocale('hr', 'HR');
          } else {
            localeController.changeLocale('en', 'US');
          }
        },
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                isEnglish
                    ? 'assets/image/uk_flag.png'
                    : 'assets/image/croatian_flag.png',
              ),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      );
    });
  }
}
