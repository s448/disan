import 'package:disan/Core/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void customSnackbar(String title, String subtitle) {
  Get.snackbar(
    title,
    subtitle,
    backgroundColor: primaryColor,
    colorText: Colors.white,
    duration: const Duration(seconds: 5),
  );
}

void dangerSnackbar(String title, String subtitle) {
  Get.snackbar(
    title,
    subtitle,
    backgroundColor: Colors.redAccent,
    colorText: Colors.white,
    duration: const Duration(seconds: 5),
  );
}
