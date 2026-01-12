import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../theme/app_theme.dart';
import '../../controllers/auth_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final textTheme = AppTheme.textThemeFromContext(context);
    final padding = AppTheme.pagePadding(context);
    final isMobile = MediaQuery.of(context).size.width < AppBreakpoints.mobile;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: padding,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isMobile ? double.infinity : 500,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo
                  Center(
                    child: SizedBox(
                      width: AppTheme.logoSize(context, variant: 'medium'),
                      height: AppTheme.logoSize(context, variant: 'medium'),

                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'assets/logo/logo.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: AppColors.darkRed,
                              child: Icon(
                                Icons.flight,
                                size:
                                    AppTheme.logoSize(
                                      context,
                                      variant: 'medium',
                                    ) *
                                    0.5,
                                color: AppColors.white,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Header
                  Text(
                    'Welcome Back! 👋',
                    style: textTheme.displayLarge?.copyWith(
                      color: AppColors.darkGray,
                      fontWeight: FontWeight.w900,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 8),

                  // Caption
                  Text(
                    'Manage your aviation crew & operations',
                    style: textTheme.bodyLarge?.copyWith(
                      color: AppColors.darkGrayLight,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 40),

                  // Email Input
                  Text(
                    'Email Address',
                    style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkGray,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: authController.emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: textTheme.bodyLarge,
                    decoration: InputDecoration(
                      hintText: 'admin@vwings24x7.com',
                      hintStyle: textTheme.bodyLarge?.copyWith(
                        color: AppColors.darkGrayLight.withAlpha(128),
                      ),
                      prefixIcon: const Icon(
                        FontAwesomeIcons.envelope,
                        size: 20,
                        color: AppColors.darkRed,
                      ),
                      filled: true,
                      fillColor: AppColors.lightGray,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors.borderGray,
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.darkRed,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Password Input
                  Text(
                    'Password',
                    style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkGray,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Obx(
                    () => TextField(
                      controller: authController.passwordController,
                      obscureText: !authController.isPasswordVisible.value,
                      style: textTheme.bodyLarge,
                      decoration: InputDecoration(
                        hintText: '••••••••',
                        hintStyle: textTheme.bodyLarge?.copyWith(
                          color: AppColors.darkGrayLight.withAlpha(128),
                        ),
                        prefixIcon: const Icon(
                          FontAwesomeIcons.lock,
                          size: 20,
                          color: AppColors.darkRed,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            authController.isPasswordVisible.value
                                ? FontAwesomeIcons.eye
                                : FontAwesomeIcons.eyeSlash,
                            size: 20,
                            color: AppColors.darkGrayLight,
                          ),
                          onPressed: authController.togglePasswordVisibility,
                        ),
                        filled: true,
                        fillColor: AppColors.lightGray,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.borderGray,
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.darkRed,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: authController.forgotPassword,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                      ),
                      child: Text(
                        'Forgot Password?',
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.darkRed,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Login Button
                  Obx(
                    () => ElevatedButton(
                      onPressed: authController.isLoading.value
                          ? null
                          : authController.login,
                      style: AppTheme.primaryButtonStyle(context, large: true),
                      child: authController.isLoading.value
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.white,
                                ),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  FontAwesomeIcons.arrowRightToBracket,
                                  size: 18,
                                ),
                                const SizedBox(width: 12),
                                Text('Sign In', style: textTheme.labelLarge),
                              ],
                            ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Footer
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.darkGrayLight,
                        ),
                        children: [
                          const TextSpan(text: 'Powered by '),
                          TextSpan(text: '✈️', style: textTheme.bodySmall),
                          const TextSpan(text: ' Naiyo24 Pvt. Ltd.'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
