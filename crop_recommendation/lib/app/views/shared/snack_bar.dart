 import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showCustomSnackbar({
    required String title,
    required String message,
    required Color backgroundColor,
  }) {
    Get.snackbar(
      title,
      message,
      backgroundColor: backgroundColor,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 5),
      borderRadius: 8.0,
      margin: const EdgeInsets.all(10.0),
      icon: Icon(Icons.info_outline, color: Colors.white),
      mainButton: TextButton(
        onPressed: () => Get.closeCurrentSnackbar(),
        child: const Icon(Icons.close, color: Colors.white),
      ),
    );
  }