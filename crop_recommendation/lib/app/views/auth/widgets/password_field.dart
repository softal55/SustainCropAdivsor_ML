import 'package:crop_recommendation/app/controllers/auth_controller.dart';
import 'package:crop_recommendation/app/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;

  const PasswordField({
    super.key,
    required this.controller,
    required this.labelText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Obx(() => TextFormField(
          controller: controller,
          obscureText: authController.obscurePassword.value,
          decoration: InputDecoration(
            labelText: labelText,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            suffixIcon: IconButton(
              icon: Icon(authController.obscurePassword.value
                  ? Icons.visibility
                  : Icons.visibility_off),
              onPressed: authController.togglePasswordVisibility,
            ),
          ),
          validator: validator ?? Validator.passwordValidator,
        ));
  }
}
