import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../theme/app_theme.dart';
import '../../routes/app_routes.dart';
import '../../controllers/auth_controller.dart';

class SideNavBar extends StatelessWidget {
  final int currentIndex;

  const SideNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTheme.textThemeFromContext(context);
    final width = AppTheme.navBarWidth(context);
    final isMobile = MediaQuery.of(context).size.width < AppBreakpoints.mobile;

    // Navigation items with icons and labels
    final navItems = [
      {
        'index': 0,
        'label': 'Dashboard',
        'icon': FontAwesomeIcons.chartLine,
        'route': AppRoutes.dashboard,
      },
      {
        'index': 1,
        'label': 'Student Management',
        'icon': FontAwesomeIcons.graduationCap,
        'route': AppRoutes.students,
      },
      {
        'index': 2,
        'label': 'Teacher Management',
        'icon': FontAwesomeIcons.chalkboardUser,
        'route': AppRoutes.teachers,
      },
      {
        'index': 3,
        'label': 'Counsellor Management',
        'icon': FontAwesomeIcons.userTie,
        'route': AppRoutes.counsellors,
      },
      {
        'index': 4,
        'label': 'Course Management',
        'icon': FontAwesomeIcons.bookOpen,
        'route': AppRoutes.courses,
      },
      {
        'index': 5,
        'label': 'Classroom Management',
        'icon': FontAwesomeIcons.chalkboard,
        'route': '',
      },
      {
        'index': 6,
        'label': 'Fee Management',
        'icon': FontAwesomeIcons.moneyBill,
        'route': '',
      },
      {
        'index': 7,
        'label': 'Salary Payments',
        'icon': FontAwesomeIcons.wallet,
        'route': '',
      },
      {
        'index': 8,
        'label': 'Commission Payouts',
        'icon': FontAwesomeIcons.percent,
        'route': '',
      },
      {
        'index': 9,
        'label': 'Announcements',
        'icon': FontAwesomeIcons.bullhorn,
        'route': '',
      },
      {
        'index': 10,
        'label': 'Help Center',
        'icon': FontAwesomeIcons.circleQuestion,
        'route': '',
      },
    ];

    if (isMobile) {
      return const SizedBox.shrink();
    }

    return Container(
      width: width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          right: BorderSide(color: AppColors.borderGray, width: 1.5),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowBlack,
            blurRadius: 10,
            offset: const Offset(4, 0),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header with Logo and Company Name
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo
                  SizedBox(
                    width: 60,
                    height: 60,

                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/logo/logo.png',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppColors.darkRed,
                            child: const Icon(
                              Icons.flight,
                              size: 32,
                              color: AppColors.white,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Company Name
                  Text(
                    'VWings24x7',
                    style: textTheme.headlineMedium?.copyWith(
                      color: AppColors.darkRed,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Admin Panel',
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.darkGrayLight,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            Divider(color: AppColors.borderGray, height: 1, thickness: 1),

            // Navigation Items
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 16),
                itemCount: navItems.length,
                separatorBuilder: (context, index) => const SizedBox(height: 4),
                itemBuilder: (context, index) {
                  final item = navItems[index];
                  final isActive = currentIndex == item['index'];

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: TextButton(
                      onPressed: () {
                        if (item['route'] != '') {
                          Get.offNamed(item['route'] as String);
                        }
                      },
                      style: AppTheme.navBarItemStyle(
                        context,
                        isActive: isActive,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            item['icon'] as IconData,
                            size: 18,
                            color: isActive
                                ? AppColors.darkRed
                                : AppColors.darkGrayLight,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              item['label'] as String,
                              style: textTheme.bodyLarge?.copyWith(
                                color: isActive
                                    ? AppColors.darkRed
                                    : AppColors.darkGrayLight,
                                fontWeight: isActive
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            Divider(color: AppColors.borderGray, height: 1, thickness: 1),

            // Logout Button
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextButton.icon(
                onPressed: () {
                  Get.find<AuthController>().logout();
                },
                style: AppTheme.navBarItemStyle(context, isActive: false),
                icon: const Icon(FontAwesomeIcons.rightFromBracket, size: 18),
                label: const Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
