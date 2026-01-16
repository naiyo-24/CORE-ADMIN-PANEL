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
        'route': AppRoutes.classrooms,
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

    if (isMobile) return const SizedBox.shrink();

    return Container(
      width: width,
      height: MediaQuery.of(context).size.height,
      color: AppColors.white,
      child: SafeArea(
        child: Stack(
          children: [
            // Slim left accent bar
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 6,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  gradient: LinearGradient(
                    colors: [AppColors.darkRed, AppColors.mediumRed],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadowBlack,
                      blurRadius: 12,
                      offset: const Offset(2, 0),
                    ),
                  ],
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 18),
                  // Logo row with badge
                  Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadowBlack,
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            'assets/logo/logo.png',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(
                                  Icons.flight,
                                  color: AppColors.white,
                                  size: 28,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'VWings24x7',
                            style: textTheme.headlineMedium?.copyWith(
                              color: AppColors.darkGray,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.6,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.mediumRed.withAlpha(45),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Admin',
                              style: textTheme.bodySmall?.copyWith(
                                color: AppColors.darkRed,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Navigation
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.only(top: 8, bottom: 12),
                      itemCount: navItems.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 6),
                      itemBuilder: (context, index) {
                        final item = navItems[index];
                        final isActive = currentIndex == item['index'];

                        return MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              if (item['route'] != '') {
                                Get.offNamed(item['route'] as String);
                              }
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 220),
                              curve: Curves.easeInOut,
                              height: AppTheme.navBarItemHeight(context),
                              padding: AppTheme.navBarItemPadding(context),
                              decoration: BoxDecoration(
                                color: isActive
                                    ? AppColors.darkRed.withAlpha(25)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  // Icon with circular background when active
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: isActive
                                          ? AppColors.darkRed
                                          : AppColors.lightGray,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Icon(
                                        item['icon'] as IconData,
                                        size: 18,
                                        color: isActive
                                            ? AppColors.white
                                            : AppColors.darkGray,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      item['label'] as String,
                                      style: textTheme.bodyLarge?.copyWith(
                                        color: isActive
                                            ? AppColors.darkRed
                                            : AppColors.darkGray,
                                        fontWeight: isActive
                                            ? FontWeight.w800
                                            : FontWeight.w600,
                                        letterSpacing: 0.4,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  // subtle chevron for active
                                  AnimatedOpacity(
                                    duration: const Duration(milliseconds: 200),
                                    opacity: isActive ? 1 : 0,
                                    child: Icon(
                                      FontAwesomeIcons.angleRight,
                                      size: 14,
                                      color: AppColors.darkRed,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Logout
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => Get.find<AuthController>().logout(),
                        icon: const Icon(
                          FontAwesomeIcons.rightFromBracket,
                          size: 16,
                        ),
                        label: Text(
                          'Logout',
                          style: textTheme.bodyLarge?.copyWith(
                            color: AppColors.darkRed,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: AppColors.white,
                          side: BorderSide(
                            color: AppColors.darkRed.withAlpha(60),
                            width: 1.2,
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
