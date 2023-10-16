import 'package:disan/Core/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final ButtonStyle primaryButtonStyle = ButtonStyle(
  minimumSize: MaterialStateProperty.all(Size(Get.width, Get.height * 0.05)),
  backgroundColor: MaterialStateProperty.all(primaryColor),
  // Add more properties like padding, shape, etc.
);
