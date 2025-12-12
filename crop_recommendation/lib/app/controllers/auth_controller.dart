import 'package:crop_recommendation/app/models/user.dart';
import 'package:crop_recommendation/app/services/auth_service.dart';
import 'package:crop_recommendation/app/utils/app_colors.dart';
import 'package:crop_recommendation/app/views/shared/snack_bar.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  var isLoggedIn = false.obs;

  var obscurePassword = true.obs;

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  final AuthService _authService = AuthService();

  Future<void> login(String email, String password) async {
    bool success = await _authService.login(email: email, password: password);

    if (success) {
      isLoggedIn.value = true;
      Get.offAllNamed('/fields');
    } else {
      showCustomSnackbar(
        title: 'Login Failed',
        message: 'Invalid email or password',
        backgroundColor: AppColors.error,
      );
    }
  }

  Future<void> register(User user) async {
    bool success = await _authService.register(user: user);

    // --- MODIFIED BLOCK ---
    // On successful registration, we are now logged in.
    // Navigate to '/fields' instead of '/otp'.
    if (success) {
      isLoggedIn.value = true;
      Get.offAllNamed('/fields');
    } else {
      showCustomSnackbar(
        title: 'Registration Failed',
        message: 'Email may already be in use.',
        backgroundColor: AppColors.error,
      );
    }
    // --- END MODIFIED BLOCK ---
  }

  // --- DELETED ---
  // The entire verifyOtp method has been removed.
  // --- END DELETED ---

  Future<void> logout() async {
    await _authService.logout();
    isLoggedIn.value = false;
    Get.offAllNamed('/');
  }
}
