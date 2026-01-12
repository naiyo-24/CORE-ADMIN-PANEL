import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../controllers/dashboard_controller.dart';
import 'package:get/get.dart';

class CountCard extends StatelessWidget {
  final String label;
  final int count;
  final IconData icon;
  final Color accentColor;

  const CountCard({
    super.key,
    required this.label,
    required this.count,
    required this.icon,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTheme.textThemeFromContext(context);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderGray, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowBlack,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: accentColor.withAlpha(38),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: accentColor, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            '$count',
            style: textTheme.displayLarge?.copyWith(
              color: AppColors.darkGray,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.darkGrayLight,
            ),
          ),
        ],
      ),
    );
  }
}

class CountCardsGrid extends StatelessWidget {
  const CountCardsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardController = Get.find<DashboardController>();
    final isMobile = MediaQuery.of(context).size.width < AppBreakpoints.mobile;
    final isTablet = MediaQuery.of(context).size.width < AppBreakpoints.tablet;

    return Obx(() {
      final metrics = dashboardController.metrics.value;

      return GridView.count(
        crossAxisCount: isMobile ? 2 : (isTablet ? 3 : 4),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          CountCard(
            label: 'Total Students',
            count: metrics.totalStudents,
            icon: Icons.school,
            accentColor: AppColors.accentBlue,
          ),
          CountCard(
            label: 'Total Teachers',
            count: metrics.totalTeachers,
            icon: Icons.person,
            accentColor: AppColors.mediumRedLight,
          ),
          CountCard(
            label: 'Total Counsellors',
            count: metrics.totalCounsellors,
            icon: Icons.people,
            accentColor: AppColors.successGreen,
          ),
          CountCard(
            label: 'Total Courses',
            count: metrics.totalCourses,
            icon: Icons.book,
            accentColor: AppColors.warningOrange,
          ),
        ],
      );
    });
  }
}
