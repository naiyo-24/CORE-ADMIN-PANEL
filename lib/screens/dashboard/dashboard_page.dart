import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_theme.dart';
import '../../controllers/dashboard_controller.dart';
import '../../widgets/side_nav_bar.dart';
import '../../cards/dashboard/welcome_card.dart';
import '../../cards/dashboard/count_card.dart';
import '../../cards/dashboard/fees_graph_card.dart';
import '../../cards/dashboard/teacher_payout_graph_card.dart';
import '../../cards/dashboard/counsellor_payout_graph_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardController = Get.find<DashboardController>();
    final textTheme = AppTheme.textThemeFromContext(context);
    final padding = AppTheme.pagePadding(context);
    final isMobile = MediaQuery.of(context).size.width < AppBreakpoints.mobile;

    return Scaffold(
      backgroundColor: AppColors.lightGray,
      body: Row(
        children: [
          // Side Navigation Bar
          if (!isMobile) const SideNavBar(currentIndex: 0),

          // Main Content
          Expanded(
            child: SafeArea(
              child: RefreshIndicator(
                onRefresh: dashboardController.refreshData,
                color: AppColors.darkRed,
                child: SingleChildScrollView(
                  padding: padding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Text(
                        'Dashboard',
                        style: textTheme.displayLarge?.copyWith(
                          color: AppColors.darkGray,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Monitor your aviation operations in real-time ✈️',
                        style: textTheme.bodyLarge?.copyWith(
                          color: AppColors.darkGrayLight,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Welcome Card
                      const WelcomeCard(),

                      const SizedBox(height: 32),

                      // Count Cards Grid
                      const CountCardsGrid(),

                      const SizedBox(height: 32),

                      // Fees Graph Card
                      const FeesGraphCard(),

                      const SizedBox(height: 32),

                      // Teacher Payout Graph Card
                      const TeacherPayoutGraphCard(),

                      const SizedBox(height: 32),

                      // Counsellor Payout Graph Card
                      const CounselllorPayoutGraphCard(),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
