import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_theme.dart';
import '../../models/classroom.dart';
import '../../controllers/classroom_controller.dart';

class CreateEditClassroomCard extends StatefulWidget {
  final Classroom classroom;
  final bool isNew;

  const CreateEditClassroomCard({
    super.key,
    required this.classroom,
    this.isNew = false,
  });

  @override
  State<CreateEditClassroomCard> createState() =>
      _CreateEditClassroomCardState();
}

class _CreateEditClassroomCardState extends State<CreateEditClassroomCard> {
  late final TextEditingController _name;
  late final TextEditingController _desc;
  late final TextEditingController _image;
  late final TextEditingController _admins;
  late final TextEditingController _members;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.classroom.name);
    _desc = TextEditingController(text: widget.classroom.description);
    _image = TextEditingController(text: widget.classroom.imageUrl);
    _admins = TextEditingController(text: widget.classroom.admins.join(', '));
    _members = TextEditingController(text: widget.classroom.members.join(', '));
  }

  @override
  void dispose() {
    _name.dispose();
    _desc.dispose();
    _image.dispose();
    _admins.dispose();
    _members.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ClassroomController>();
    final textTheme = AppTheme.textThemeFromContext(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.isNew ? 'Create Classroom' : 'Edit Classroom',
              style: textTheme.displayLarge,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _desc,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _image,
              decoration: const InputDecoration(labelText: 'Image URL'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _admins,
              decoration: const InputDecoration(
                labelText: 'Admins (comma separated)',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _members,
              decoration: const InputDecoration(
                labelText: 'Members (comma separated)',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: AppTheme.primaryButtonStyle(context),
                    onPressed: () {
                      final updated = Classroom(
                        id: widget.classroom.id,
                        name: _name.text.trim(),
                        description: _desc.text.trim(),
                        imageUrl: _image.text.trim(),
                        creator: widget.classroom.creator,
                        admins: _admins.text
                            .split(',')
                            .map((s) => s.trim())
                            .where((s) => s.isNotEmpty)
                            .toList(),
                        members: _members.text
                            .split(',')
                            .map((s) => s.trim())
                            .where((s) => s.isNotEmpty)
                            .toList(),
                        contents: widget.classroom.contents,
                      );
                      controller.createOrUpdate(updated);
                      Get.back();
                    },
                    child: const Text('Save'),
                  ),
                ),
                const SizedBox(width: 8),
                if (!widget.isNew)
                  OutlinedButton(
                    onPressed: () {
                      controller.delete(widget.classroom.id);
                      Get.back();
                    },
                    child: const Text('Delete'),
                  ),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
