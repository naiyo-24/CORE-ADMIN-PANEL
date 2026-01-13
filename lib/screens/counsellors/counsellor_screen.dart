import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_theme.dart';
import '../../widgets/side_nav_bar.dart';
import '../../controllers/counsellor_controller.dart';
import '../../cards/counsellor/counsellor_table_card.dart';
import '../../cards/counsellor/onboard_edit_counsellor_card.dart';

class CounsellorScreen extends StatelessWidget {
  const CounsellorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTheme.textThemeFromContext(context);
    final isDesktop = AppTheme.isDesktop(context);
    final counsellorController = Get.find<CounsellorController>();

    return Scaffold(
      backgroundColor: AppColors.lightGray,
      body: Row(
        children: [
          if (isDesktop) const SideNavBar(currentIndex: 3),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await counsellorController.getAllCounsellors();
              },
              color: AppColors.darkRed,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: AppTheme.pagePadding(context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Section
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppColors.darkRed, AppColors.mediumRed],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadowBlack,
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Counsellor Management',
                                        style: textTheme.headlineLarge
                                            ?.copyWith(
                                              color: AppColors.white,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 32,
                                            ),
                                      ),
                                      const SizedBox(width: 12),
                                      const Text(
                                        '🎓',
                                        style: TextStyle(fontSize: 32),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Manage your counselling team and their profiles',
                                    style: textTheme.bodyLarge?.copyWith(
                                      color: AppColors.white.withOpacity(0.9),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Search and Action Section
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.borderGray,
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadowBlack,
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: ValueListenableBuilder(
                                    valueListenable: counsellorController
                                        .searchNameController,
                                    builder: (context, value, child) {
                                      return TextField(
                                        controller: counsellorController
                                            .searchNameController,
                                        decoration: InputDecoration(
                                          hintText:
                                              'Search by counsellor name or phone number...',
                                          prefixIcon: Icon(
                                            Icons.search,
                                            color: AppColors.darkRed,
                                          ),
                                          suffixIcon: value.text.isNotEmpty
                                              ? IconButton(
                                                  icon: Icon(
                                                    Icons.clear,
                                                    color:
                                                        AppColors.darkGrayLight,
                                                  ),
                                                  onPressed: () {
                                                    counsellorController
                                                        .searchNameController
                                                        .clear();
                                                    counsellorController
                                                        .searchByNameAndPhone(
                                                          '',
                                                          '',
                                                        );
                                                  },
                                                )
                                              : null,
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            borderSide: BorderSide(
                                              color: AppColors.borderGray,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            borderSide: BorderSide(
                                              color: AppColors.darkRed,
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                        onChanged: (value) {
                                          counsellorController
                                              .searchByNameAndPhone(
                                                value,
                                                value,
                                              );
                                        },
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 16),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                          const OnboardEditCounsellorCard(),
                                      barrierDismissible: false,
                                    );
                                  },
                                  icon: const Icon(Icons.add),
                                  label: Text(
                                    isDesktop
                                        ? 'Onboard a new counsellor'
                                        : 'Add',
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.darkRed,
                                    foregroundColor: AppColors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Counsellors Table
                      const CounsellorTableCard(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: isDesktop
          ? null
          : const Drawer(child: SideNavBar(currentIndex: 3)),
    );
  }
}
