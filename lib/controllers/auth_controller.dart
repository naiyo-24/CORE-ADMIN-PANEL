import 'package:application_admin_panel/widgets/snackber_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/admin.dart';
import '../routes/app_routes.dart';
import '../services/auth_services.dart';

class AuthController extends GetxController {
  // Form controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Observable state
  final Rx<Admin?> currentAdmin = Rx<Admin?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // Login method
  Future<void> login() async {
    // Validate inputs
    if (emailController.text.trim().isEmpty) {
      safeSnackbar(
        'Error',
        'Please enter your email',
        backgroundColor: const Color(0xFFE53935),
        colorText: const Color(0xFFFEFEFE),
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
      );
      return;
    }
    if (passwordController.text.isEmpty) {
      safeSnackbar(
        'Error',
        'Please enter your password',
        backgroundColor: const Color(0xFFE53935),
        colorText: const Color(0xFFFEFEFE),
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
      );
      return;
    }
    isLoading.value = true;
    try {
      final admin = await AuthServices.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      currentAdmin.value = admin;

      Get.offAllNamed(AppRoutes.dashboard);
    } catch (e) {
      safeSnackbar(
        'Error',
        e.toString().replaceAll('Exception: ', ''),
        backgroundColor: const Color(0xFFE53935),
        colorText: const Color(0xFFFEFEFE),
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Forgot password
  Future<void> forgotPassword() async {
    if (emailController.text.trim().isEmpty) {
      safeSnackbar(
        'Info',
        'Please enter your email first',
        backgroundColor: const Color(0xFFFFA726),
        colorText: const Color(0xFF000000),
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    safeSnackbar(
      'Oops!',
      'Contact support to reset your password.',
      backgroundColor: const Color(0xFF1E88E5),
      colorText: const Color(0xFFFEFEFE),
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
    );
  }

  // Logout
  void logout() {
    currentAdmin.value = null;
    emailController.clear();
    passwordController.clear();
    Get.offAllNamed(AppRoutes.splash);
  }
}
