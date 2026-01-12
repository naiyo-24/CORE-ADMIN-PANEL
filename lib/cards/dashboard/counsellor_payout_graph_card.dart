import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../controllers/dashboard_controller.dart';
import 'package:get/get.dart';

class CounselllorPayoutGraphCard extends StatelessWidget {
  const CounselllorPayoutGraphCard({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTheme.textThemeFromContext(context);
    final dashboardController = Get.find<DashboardController>();

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
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Counsellor Commission',
            style: textTheme.headlineMedium?.copyWith(
              color: AppColors.darkGray,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Monthly commission paid to counsellors for admissions',
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.darkGrayLight,
            ),
          ),
          const SizedBox(height: 24),
          Obx(() {
            final data = dashboardController.monthlyCounselllorPayout;

            return SizedBox(
              height: 250,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(data.length, (index) {
                    final monthData = data[index];
                    final maxAmount = 50000.0;
                    final barHeight = (monthData.amount / maxAmount) * 200;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: 24,
                            height: barHeight,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  AppColors.accentBlue,
                                  AppColors.accentBlue.withAlpha(179),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            monthData.month,
                            style: textTheme.bodySmall?.copyWith(
                              color: AppColors.darkGrayLight,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
