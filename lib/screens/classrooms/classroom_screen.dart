import 'package:application_admin_panel/widgets/side_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_theme.dart';
import '../../controllers/classroom_controller.dart';
import '../../models/classroom.dart';
import '../../cards/classroom/classroom_card.dart';
import '../../cards/classroom/create_edit_classroom_card.dart';
import '../../cards/classroom/push_content_card.dart';
import '../../cards/classroom/classroom_details_card.dart';

class ClassroomScreen extends StatelessWidget {
  const ClassroomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ClassroomController>();
    final textTheme = AppTheme.textThemeFromContext(context);

    final isDesktop = AppTheme.isDesktop(context);

    return Scaffold(
      backgroundColor: AppColors.lightGray,
      body: Row(
        children: [
          if (isDesktop) const SideNavBar(currentIndex: 5),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                // placeholder: no remote fetch implemented yet
                await Future<void>.delayed(const Duration(milliseconds: 200));
              },
              color: AppColors.darkRed,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: AppTheme.pagePadding(context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
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
                                        'Classroom Management',
                                        style: textTheme.headlineLarge
                                            ?.copyWith(
                                              color: AppColors.white,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 32,
                                            ),
                                      ),
                                      const SizedBox(width: 12),
                                      const Text(
                                        '🏫',
                                        style: TextStyle(fontSize: 32),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Manage your classrooms and their contents',
                                    style: textTheme.bodyLarge?.copyWith(
                                      color: AppColors.white.withAlpha(230),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton.icon(
                              style: AppTheme.primaryButtonStyle(context),
                              onPressed: () {
                                final newClass = Classroom(
                                  id: DateTime.now().millisecondsSinceEpoch
                                      .toString(),
                                  name: '',
                                  description: '',
                                  imageUrl: '',
                                  creator: 'You',
                                );
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (_) => Padding(
                                    padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(
                                        context,
                                      ).viewInsets.bottom,
                                    ),
                                    child: CreateEditClassroomCard(
                                      classroom: newClass,
                                      isNew: true,
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.add),
                              label: const Text('Create Classroom'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Search and list card
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
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: 'Search classrooms by name',
                                      prefixIcon: const Icon(Icons.search),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          color: AppColors.borderGray,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          color: AppColors.darkRed,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    onChanged: controller.search,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // list area
                            Obx(() {
                              final items = controller.filtered;
                              if (items.isEmpty) {
                                return Center(
                                  child: Text(
                                    'No classrooms found',
                                    style: textTheme.bodyMedium,
                                  ),
                                );
                              }
                              return ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: items.length,
                                separatorBuilder: (_, _) =>
                                    const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  final c = items[index];
                                  return ClassroomCard(
                                    classroom: c,
                                    onEdit: (cl) {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        builder: (_) => Padding(
                                          padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(
                                              context,
                                            ).viewInsets.bottom,
                                          ),
                                          child: CreateEditClassroomCard(
                                            classroom: cl,
                                            isNew: false,
                                          ),
                                        ),
                                      );
                                    },
                                    onDelete: (cl) {
                                      Get.defaultDialog(
                                        title: 'Delete',
                                        middleText: 'Delete ${cl.name}?',
                                        onConfirm: () {
                                          controller.delete(cl.id);
                                          Get.back();
                                        },
                                        onCancel: () {},
                                      );
                                    },
                                    onPushContent: (cl) {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        builder: (_) => Padding(
                                          padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(
                                              context,
                                            ).viewInsets.bottom,
                                          ),
                                          child: PushContentCard(classroom: cl),
                                        ),
                                      );
                                    },
                                    onViewDetails: (cl) {
                                      controller.select(cl);
                                      showDialog(
                                        context: context,
                                        builder: (_) => Dialog(
                                          child: ClassroomDetailsCard(
                                            classroom: cl,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            }),
                          ],
                        ),
                      ),
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
          : const Drawer(child: SideNavBar(currentIndex: 5)),
    );
  }
}
