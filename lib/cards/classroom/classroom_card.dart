import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/classroom.dart';

typedef ClassroomCallback = void Function(Classroom classroom);

class ClassroomCard extends StatelessWidget {
  final Classroom classroom;
  final ClassroomCallback onEdit;
  final ClassroomCallback onDelete;
  final ClassroomCallback onPushContent;
  const ClassroomCard({
    super.key,
    required this.classroom,
    required this.onEdit,
    required this.onDelete,
    required this.onPushContent,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTheme.textThemeFromContext(context);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              width: 96,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.borderGray,
                borderRadius: BorderRadius.circular(8),
                image: classroom.imageUrl.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(classroom.imageUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: classroom.imageUrl.isEmpty
                  ? Center(
                      child: Text(
                        classroom.name.isNotEmpty ? classroom.name[0] : '?',
                        style: textTheme.headlineMedium,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(classroom.name, style: textTheme.headlineLarge),
                  const SizedBox(height: 6),
                  Text(
                    classroom.description,
                    style: textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      OutlinedButton.icon(
                        onPressed: () => onDelete(classroom),
                        icon: const Icon(Icons.delete, size: 16),
                        label: const Text('Delete'),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        onPressed: () => onPushContent(classroom),
                        icon: const Icon(Icons.upload_file, size: 16),
                        label: const Text('Push Content'),
                      ),
                      // View Details removed
                    ],
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
