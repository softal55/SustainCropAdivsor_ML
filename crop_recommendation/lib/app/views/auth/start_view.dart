import 'package:crop_recommendation/app/utils/app_colors.dart';
import 'package:crop_recommendation/app/utils/app_paths.dart';
import 'package:crop_recommendation/app/utils/app_strings.dart';
import 'package:crop_recommendation/app/views/auth/widgets/auth_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StartView extends StatelessWidget {
  const StartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage(AppPaths.onboardingImage),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  AppColors.secondary.withValues(alpha: 0.4),
                  BlendMode.darken,
                ),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                top: constraints.maxHeight * 0.45,
                left: constraints.maxWidth * 0.1,
                right: constraints.maxWidth * 0.1,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.appName,
                    style: TextStyle(
                      height: 1,
                      color: AppColors.background,
                      fontSize: 48,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    AppStrings.onboardingSubtitle,
                    style: TextStyle(color: AppColors.background),
                  ),
                  const SizedBox(height: 120),
                  AuthButton(
                    text: AppStrings.login,
                    isPrimary: true,
                    onPressed: () {
                      Get.toNamed('/login');
                    },
                  ),
                  const SizedBox(height: 20),
                  AuthButton(
                    text: AppStrings.createAccount,
                    isPrimary: false,
                    onPressed: () {
                      Get.toNamed('/register');
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
