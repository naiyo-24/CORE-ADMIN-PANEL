import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../controllers/auth_controller.dart';
import 'package:get/get.dart';

class WelcomeCard extends StatelessWidget {
  const WelcomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final textTheme = AppTheme.textThemeFromContext(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.darkRed, AppColors.mediumRed],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowBlack,
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome back! 👋',
            style: textTheme.headlineLarge?.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Obx(
            () => Text(
              authController.currentAdmin.value?.name ?? 'Admin User',
              style: textTheme.bodyLarge?.copyWith(
                color: AppColors.white.withAlpha(230),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white.withAlpha(51),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.white.withAlpha(77)),
                ),
                child: Text(
                  'Super Admin',
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
