import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_theme.dart';
import '../../models/classroom.dart';
import '../../controllers/classroom_controller.dart';

class PushContentCard extends StatefulWidget {
  final Classroom classroom;

  const PushContentCard({super.key, required this.classroom});

  @override
  State<PushContentCard> createState() => _PushContentCardState();
}

class _PushContentCardState extends State<PushContentCard> {
  final _heading = TextEditingController();
  final _desc = TextEditingController();
  final _link = TextEditingController();
  DateTime? _date;

  @override
  void dispose() {
    _heading.dispose();
    _desc.dispose();
    _link.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ClassroomController>();
    final textTheme = AppTheme.textThemeFromContext(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Push Content', style: textTheme.displayLarge),
          const SizedBox(height: 12),
          TextField(
            controller: _heading,
            decoration: const InputDecoration(labelText: 'Heading'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _desc,
            decoration: const InputDecoration(labelText: 'Description'),
            maxLines: 3,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _link,
            decoration: const InputDecoration(labelText: 'YouTube Link'),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  _date == null
                      ? 'Select date'
                      : _date!.toLocal().toString().split(' ').first,
                ),
              ),
              TextButton(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) setState(() => _date = picked);
                },
                child: const Text('Pick Date'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: AppTheme.primaryButtonStyle(context),
                  onPressed: () {
                    final content = ClassroomContent(
                      heading: _heading.text.trim(),
                      description: _desc.text.trim(),
                      youtubeLink: _link.text.trim(),
                      date: _date ?? DateTime.now(),
                    );
                    controller.pushContent(widget.classroom.id, content);
                    Get.back();
                  },
                  child: const Text('Push'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
