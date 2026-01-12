import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_theme.dart';
import '../../../controllers/teacher_controller.dart';
import 'onboard_edit_teacher_card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TeacherTableCard extends StatelessWidget {
  const TeacherTableCard({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTheme.textThemeFromContext(context);
    final teacherController = Get.find<TeacherController>();

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
            'Teachers Directory',
            style: textTheme.headlineMedium?.copyWith(
              color: AppColors.darkGray,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 24),
          Obx(() {
            if (teacherController.isLoading.value) {
              return Center(
                child: CircularProgressIndicator(color: AppColors.darkRed),
              );
            }

            final teachers = teacherController.filteredTeachers;

            if (teachers.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text(
                    'No teachers found',
                    style: textTheme.bodyLarge?.copyWith(
                      color: AppColors.darkGrayLight,
                    ),
                  ),
                ),
              );
            }

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 16,
                headingRowColor: MaterialStateColor.resolveWith(
                  (_) => AppColors.lightGray,
                ),
                columns: [
                  DataColumn(
                    label: Text(
                      'ID',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkGray,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Photo',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkGray,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Teacher Name',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkGray,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Phone',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkGray,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Email',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkGray,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Alt Phone',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkGray,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Address',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkGray,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Specialization',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkGray,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Classrooms',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkGray,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Experience',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkGray,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Actions',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkGray,
                      ),
                    ),
                  ),
                ],
                rows: List.generate(teachers.length, (index) {
                  final teacher = teachers[index];

                  return DataRow(
                    color: MaterialStateColor.resolveWith(
                      (_) =>
                          index.isEven ? AppColors.white : AppColors.lightGray,
                    ),
                    cells: [
                      DataCell(Text(teacher.id, style: textTheme.bodySmall)),
                      DataCell(
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.lightGray,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: teacher.profilePhotoUrl != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    teacher.profilePhotoUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.person,
                                        color: AppColors.darkGrayLight,
                                      );
                                    },
                                  ),
                                )
                              : const Icon(
                                  Icons.person,
                                  color: AppColors.darkGrayLight,
                                ),
                        ),
                      ),
                      DataCell(
                        Text(
                          teacher.teacherName,
                          style: textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(teacher.phoneNumber, style: textTheme.bodySmall),
                      ),
                      DataCell(Text(teacher.email, style: textTheme.bodySmall)),
                      DataCell(
                        Text(
                          teacher.alternativePhoneNumber,
                          style: textTheme.bodySmall,
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: 150,
                          child: Text(
                            teacher.address,
                            style: textTheme.bodySmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          teacher.specialization,
                          style: textTheme.bodySmall,
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: 150,
                          child: Wrap(
                            spacing: 4,
                            children: teacher.classroomsInCharge
                                .take(2)
                                .map(
                                  (classroom) => Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.darkRed.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      classroom,
                                      style: textTheme.bodySmall?.copyWith(
                                        color: AppColors.darkRed,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          '${teacher.experienceYears} years',
                          style: textTheme.bodySmall,
                        ),
                      ),
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                FontAwesomeIcons.penToSquare,
                                size: 16,
                                color: AppColors.accentBlue,
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) =>
                                      OnboardEditTeacherCard(teacher: teacher),
                                  barrierDismissible: false,
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(
                                FontAwesomeIcons.trash,
                                size: 16,
                                color: AppColors.errorRed,
                              ),
                              onPressed: () {
                                _showDeleteConfirmation(
                                  context,
                                  teacher.id,
                                  teacher.teacherName,
                                  teacherController,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
              ),
            );
          }),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    String teacherId,
    String teacherName,
    TeacherController controller,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Teacher'),
          content: Text('Are you sure you want to delete $teacherName?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                controller.deleteTeacher(teacherId);
                Navigator.pop(context);
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: AppColors.errorRed),
              ),
            ),
          ],
        );
      },
    );
  }
}
