import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../utils/colors.dart';
import '../utils/dimensions.dart';
import '../widgets/big_text.dart';

void showCustomSnackBar(String message,
    {bool isError = true,
    String title = "Error",
    Color color = Colors.redAccent}) {
  Get.snackbar(title, message,
      titleText: BigText(
        text: title,
        color: Colors.white,
      ),
      messageText: Text(message, style: const TextStyle(color: Colors.white)),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      backgroundColor: color);
}

void showCustomEventSnackBar({
  required String name,
  required String surname,
  required String eventTitle,
  required String imageUrl,
  Color backgroundColor = AppColors.blueChipColor,
  Duration duration = const Duration(seconds: 3),
}) {
  final now = DateTime.now();
  final formattedDate = DateFormat('yyyy-MM-dd').format(now);
  final formattedTime = DateFormat('HH:mm').format(now);

  Get.snackbar(
    '', // Empty title
    '', // Empty message
    duration: duration,
    backgroundColor: backgroundColor,
    colorText: Colors.white,
    snackPosition: SnackPosition.TOP,
    padding: const EdgeInsets.all(16),
    titleText: Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Image.network(
            imageUrl,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$name $surname',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Created new event: $eventTitle',
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
              const SizedBox(height: 4),
            ],
          ),
        ),
      ],
    ),
    messageText: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: Dimensions.height10,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(40)),
        ),
        Text(
          'Created at $formattedTime',
          style: const TextStyle(fontSize: 12, color: Colors.white70),
        ),
      ],
    ),
  );
}
