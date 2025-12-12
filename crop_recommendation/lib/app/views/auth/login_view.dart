import 'package:crop_recommendation/app/controllers/auth_controller.dart';
import 'package:crop_recommendation/app/utils/app_colors.dart';
import 'package:crop_recommendation/app/views/auth/widgets/auth_button.dart';
import 'package:crop_recommendation/app/views/auth/widgets/email_field.dart';
import 'package:crop_recommendation/app/views/auth/widgets/password_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.secondary,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 36),
            onPressed: () => Get.back(),
          ),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                top: constraints.maxHeight * 0.2,
                left: constraints.maxWidth * 0.1,
                right: constraints.maxWidth * 0.1,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back!',
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontSize: 40,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 40),
                    EmailField(controller: _emailController),
                    const SizedBox(height: 20),
                    PasswordField(
                      controller: _passwordController,
                      labelText: 'Password',
                    ),
                    const SizedBox(height: 5),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          // TODO: Add navigation or reset logic
                        },
                        child: Text(
                          'Forgot password?',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            decoration: TextDecoration.underline,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: AuthButton(
                        text: 'Login',
                        isPrimary: true,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            authController.login(
                              _emailController.text,
                              _passwordController.text,
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: "You don't have an account? ",
                          style: TextStyle(color: AppColors.secondary),
                          children: [
                            TextSpan(
                              text: 'Sign up.',
                              style: TextStyle(
                                color: AppColors.primary,
                                decoration: TextDecoration.underline,
                                decorationColor: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer:
                                  TapGestureRecognizer()
                                    ..onTap = () {
                                      Get.back();
                                    },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
