import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_theme.dart';
import '../../controllers/course_controller.dart';
import '../../models/course.dart';
import 'edit_create_course_card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CourseCard extends StatefulWidget {
  final Course course;

  const CourseCard({super.key, required this.course});

  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  late String _selectedCategory; // 'General' or 'Executive'

  @override
  void initState() {
    super.initState();
    _selectedCategory = 'General';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTheme.textThemeFromContext(context);
    final isDesktop = AppTheme.isDesktop(context);
    final category = _selectedCategory == 'General'
        ? widget.course.generalCategory
        : widget.course.executiveCategory;

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
          // Header with title and category toggle
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.course.name,
                      style: textTheme.headlineSmall?.copyWith(
                        color: AppColors.darkGray,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Code: ${widget.course.code}',
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.darkGrayLight,
                      ),
                    ),
                  ],
                ),
              ),
              // Category Toggle Button
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.borderGray, width: 1.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    _buildCategoryToggleButton(
                      'General',
                      _selectedCategory == 'General',
                      () => setState(() => _selectedCategory = 'General'),
                      AppColors.successGreen,
                    ),
                    _buildCategoryToggleButton(
                      'Executive',
                      _selectedCategory == 'Executive',
                      () => setState(() => _selectedCategory = 'Executive'),
                      AppColors.accentBlue,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Description
          Text(
            widget.course.description,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.darkGrayLight,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 20),

          // Divider
          Divider(color: AppColors.borderGray, height: 1),
          const SizedBox(height: 20),

          // Category-specific details grid
          isDesktop
              ? Row(
                  children: [
                    Expanded(
                      child: _buildDetailItem(
                        'Job Roles',
                        category.jobRolesOffered,
                        textTheme,
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: _buildDetailItem(
                        'Placement Type',
                        category.placementType,
                        textTheme,
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: _buildDetailItem(
                        'Placement Rate',
                        '${category.placementRate}%',
                        textTheme,
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    _buildDetailItem(
                      'Job Roles',
                      category.jobRolesOffered,
                      textTheme,
                    ),
                    const SizedBox(height: 16),
                    _buildDetailItem(
                      'Placement Type',
                      category.placementType,
                      textTheme,
                    ),
                    const SizedBox(height: 16),
                    _buildDetailItem(
                      'Placement Rate',
                      '${category.placementRate}%',
                      textTheme,
                    ),
                  ],
                ),
          const SizedBox(height: 20),

          // Fees and Placement Assistance
          Row(
            children: [
              Expanded(
                child: _buildDetailItem(
                  'Course Fees',
                  '₹${category.courseFees.toStringAsFixed(0)}',
                  textTheme,
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _buildDetailItem(
                  'Placement Assistance',
                  category.placementAssistance ? 'Yes' : 'No',
                  textTheme,
                  isHighlight: category.placementAssistance,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Advantages section
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.lightGray,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.borderGray, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Advantages & Highlights',
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.darkGray,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  category.advantagesHighlights,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.darkGrayLight,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) =>
                        EditCreateCourseCard(course: widget.course),
                    barrierDismissible: false,
                  );
                },
                icon: const Icon(FontAwesomeIcons.penToSquare, size: 14),
                label: const Text('Edit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentBlue,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () {
                  _showDeleteConfirmation(
                    context,
                    widget.course.code,
                    widget.course.name,
                  );
                },
                icon: const Icon(FontAwesomeIcons.trash, size: 14),
                label: const Text('Delete'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.errorRed,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(
    String label,
    String value,
    TextTheme textTheme, {
    bool isHighlight = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: AppColors.darkGrayLight,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: textTheme.bodyMedium?.copyWith(
            color: isHighlight ? AppColors.successGreen : AppColors.darkGray,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildCategoryToggleButton(
    String label,
    bool isSelected,
    VoidCallback onPressed,
    Color color,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? color.withAlpha(25) : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? color : AppColors.darkGrayLight,
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    String courseCode,
    String courseName,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        final controller = Get.find<CourseController>();
        return AlertDialog(
          title: const Text('Delete Course'),
          content: Text('Are you sure you want to delete $courseName?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                controller.deleteCourse(courseCode);
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
