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
          // Header with Title and Year Filter
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
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
                ],
              ),
              // Year Selector
              Obx(
                () => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.lightGray,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.borderGray, width: 1.5),
                  ),
                  child: DropdownButton<int>(
                    value: dashboardController.selectedYear.value,
                    items: dashboardController.availableYears
                        .map(
                          (year) => DropdownMenuItem(
                            value: year,
                            child: Text(
                              '$year',
                              style: textTheme.bodyMedium?.copyWith(
                                color: AppColors.darkGray,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (year) {
                      if (year != null) {
                        dashboardController.setSelectedYear(year);
                      }
                    },
                    underline: const SizedBox(),
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Obx(() {
            final data = dashboardController.monthlyCounselllorPayout;

            return SizedBox(
              height: 250,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width > 1024
                      ? MediaQuery.of(context).size.width - 320
                      : 600,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(data.length, (index) {
                      final monthData = data[index];
                      final maxAmount = 50000.0;
                      final barHeight = (monthData.amount / maxAmount) * 200;

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: 28,
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
                          const SizedBox(height: 12),
                          Text(
                            monthData.month,
                            style: textTheme.bodySmall?.copyWith(
                              color: AppColors.darkGrayLight,
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
