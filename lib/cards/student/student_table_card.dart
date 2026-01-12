import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_theme.dart';
import '../../../controllers/student_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StudentTableCard extends StatelessWidget {
  const StudentTableCard({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTheme.textThemeFromContext(context);
    final studentController = Get.find<StudentController>();

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
            'Students Directory',
            style: textTheme.headlineMedium?.copyWith(
              color: AppColors.darkGray,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 24),
          Obx(() {
            if (studentController.isLoading.value) {
              return Center(
                child: CircularProgressIndicator(color: AppColors.darkRed),
              );
            }

            final students = studentController.filteredStudents;

            if (students.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text(
                    'No students found',
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
                      'Full Name',
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
                      'Address',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkGray,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Course',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkGray,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Guardian Name',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkGray,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Guardian Phone',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkGray,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Guardian Email',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkGray,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Interests',
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
                rows: List.generate(students.length, (index) {
                  final student = students[index];

                  return DataRow(
                    color: MaterialStateColor.resolveWith(
                      (_) =>
                          index.isEven ? AppColors.white : AppColors.lightGray,
                    ),
                    cells: [
                      DataCell(Text(student.id, style: textTheme.bodySmall)),
                      DataCell(
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.lightGray,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: student.profilePhotoUrl != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    student.profilePhotoUrl!,
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
                          student.fullName,
                          style: textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(student.phoneNumber, style: textTheme.bodySmall),
                      ),
                      DataCell(Text(student.email, style: textTheme.bodySmall)),
                      DataCell(
                        SizedBox(
                          width: 150,
                          child: Text(
                            student.address,
                            style: textTheme.bodySmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(student.course, style: textTheme.bodySmall),
                      ),
                      DataCell(
                        Text(student.guardianName, style: textTheme.bodySmall),
                      ),
                      DataCell(
                        Text(
                          student.guardianPhoneNumber,
                          style: textTheme.bodySmall,
                        ),
                      ),
                      DataCell(
                        Text(student.guardianEmail, style: textTheme.bodySmall),
                      ),
                      DataCell(
                        SizedBox(
                          width: 150,
                          child: Wrap(
                            spacing: 4,
                            children: student.interests
                                .take(2)
                                .map(
                                  (interest) => Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.darkRed.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      interest,
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
                                // TODO: Open edit dialog
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
                                  student.id,
                                  student.fullName,
                                  studentController,
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
    String studentId,
    String studentName,
    StudentController controller,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Student'),
          content: Text('Are you sure you want to delete $studentName?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                controller.deleteStudent(studentId);
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
