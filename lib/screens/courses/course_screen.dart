import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_theme.dart';
import '../../widgets/side_nav_bar.dart';
import '../../controllers/course_controller.dart';
import '../../cards/course/course_card.dart';
import '../../cards/course/edit_create_course_card.dart';

class CourseScreen extends StatelessWidget {
  const CourseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTheme.textThemeFromContext(context);
    final isDesktop = AppTheme.isDesktop(context);
    final courseController = Get.find<CourseController>();

    return Scaffold(
      backgroundColor: AppColors.lightGray,
      body: Row(
        children: [
          if (isDesktop) const SideNavBar(currentIndex: 4),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await courseController.getAllCourses();
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
                                        'Course Management',
                                        style: textTheme.headlineLarge
                                            ?.copyWith(
                                              color: AppColors.white,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 32,
                                            ),
                                      ),
                                      const SizedBox(width: 12),
                                      const Text(
                                        '✈️',
                                        style: TextStyle(fontSize: 32),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Manage aviation courses and their details',
                                    style: textTheme.bodyLarge?.copyWith(
                                      color: AppColors.white.withAlpha(230),
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
                                    valueListenable:
                                        courseController.searchController,
                                    builder: (context, value, child) {
                                      return TextField(
                                        controller:
                                            courseController.searchController,
                                        decoration: InputDecoration(
                                          hintText:
                                              'Search by course name or code...',
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
                                                    courseController
                                                        .searchController
                                                        .clear();
                                                    courseController
                                                        .searchByCodeOrName('');
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
                                          courseController.searchByCodeOrName(
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
                                          const EditCreateCourseCard(),
                                      barrierDismissible: false,
                                    );
                                  },
                                  icon: const Icon(Icons.add),
                                  label: Text(
                                    isDesktop ? 'Create a new course' : 'Add',
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

                      // Courses List
                      Obx(() {
                        if (courseController.isLoading.value) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: AppColors.darkRed,
                            ),
                          );
                        }

                        final courses = courseController.filteredCourses;

                        if (courses.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32),
                              child: Text(
                                'No courses found',
                                style: textTheme.bodyLarge?.copyWith(
                                  color: AppColors.darkGrayLight,
                                ),
                              ),
                            ),
                          );
                        }

                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: courses.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final course = courses[index];
                            return CourseCard(course: course);
                          },
                        );
                      }),
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
          : const Drawer(child: SideNavBar(currentIndex: 4)),
    );
  }
}
