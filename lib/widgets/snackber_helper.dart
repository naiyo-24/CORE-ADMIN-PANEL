import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../theme/app_theme.dart';

void safeSnackbar(
  String title,
  String message, {
  Color? backgroundColor,
  Color? colorText,
  SnackPosition? snackPosition,
  EdgeInsets? margin,
  Duration? duration,
}) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Get.snackbar(
      title,
      message,
      backgroundColor: backgroundColor ?? AppColors.errorRed,
      colorText: colorText ?? AppColors.white,
      snackPosition: snackPosition ?? SnackPosition.TOP,
      margin: margin,
      duration: duration,
    );
  });
}
