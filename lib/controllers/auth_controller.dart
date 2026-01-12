import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/admin.dart';
import '../routes/app_routes.dart';

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
      Get.snackbar(
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
      Get.snackbar(
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
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // TODO: Replace with actual API call
      // For now, accept any email/password for demo
      final admin = Admin(
        id: '1',
        email: emailController.text.trim(),
        name: 'Admin User',
        role: 'Super Admin',
        createdAt: DateTime.now(),
      );

      currentAdmin.value = admin;

      Get.snackbar(
        'Success',
        'Welcome back, ${admin.name}!',
        backgroundColor: const Color(0xFF4CAF50),
        colorText: const Color(0xFFFEFEFE),
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
      );

      // Navigate to dashboard
      // TODO: Replace with actual dashboard route when created
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Login failed. Please try again.',
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
      Get.snackbar(
        'Info',
        'Please enter your email first',
        backgroundColor: const Color(0xFFFFA726),
        colorText: const Color(0xFF000000),
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    Get.snackbar(
      'Password Reset',
      'Reset link sent to ${emailController.text.trim()}',
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
