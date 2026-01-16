import 'package:get/get.dart';
import '../models/classroom.dart';

class ClassroomController extends GetxController {
  final _classrooms = <Classroom>[].obs;
  final _filtered = <Classroom>[].obs;
  final selected = Rxn<Classroom>();

  List<Classroom> get classrooms => _classrooms;
  List<Classroom> get filtered => _filtered;

  @override
  void onInit() {
    super.onInit();
    _loadSampleData();
  }

  void _loadSampleData() {
    final samples = List.generate(5, (i) {
      return Classroom(
        id: '${DateTime.now().millisecondsSinceEpoch}_$i',
        name: 'Classroom ${i + 1}',
        description: 'Description for classroom ${i + 1}',
        imageUrl: '',
        creator: 'Teacher ${i + 1}',
        admins: ['Admin A', 'Admin B'],
        members: ['Student 1', 'Student 2', 'Student 3'],
        contents: [],
      );
    });
    _classrooms.assignAll(samples);
    _filtered.assignAll(samples);
  }

  void search(String q) {
    if (q.trim().isEmpty) {
      _filtered.assignAll(_classrooms);
      return;
    }
    final low = q.toLowerCase();
    _filtered.assignAll(
      _classrooms
          .where(
            (c) =>
                c.name.toLowerCase().contains(low) ||
                c.description.toLowerCase().contains(low),
          )
          .toList(),
    );
  }

  void createOrUpdate(Classroom classroom) {
    final idx = _classrooms.indexWhere((c) => c.id == classroom.id);
    if (idx >= 0) {
      _classrooms[idx] = classroom;
    } else {
      _classrooms.insert(0, classroom);
    }
    search('');
  }

  void delete(String id) {
    _classrooms.removeWhere((c) => c.id == id);
    search('');
  }

  void pushContent(String classroomId, ClassroomContent content) {
    final idx = _classrooms.indexWhere((c) => c.id == classroomId);
    if (idx >= 0) {
      _classrooms[idx].contents.insert(0, content);
      _classrooms.refresh();
    }
  }

  void select(Classroom c) {
    selected.value = c;
  }

  void removeMember(String classroomId, String member) {
    final idx = _classrooms.indexWhere((c) => c.id == classroomId);
    if (idx >= 0) {
      _classrooms[idx].members.remove(member);
      _classrooms.refresh();
    }
  }

  void removeAdmin(String classroomId, String admin) {
    final idx = _classrooms.indexWhere((c) => c.id == classroomId);
    if (idx >= 0) {
      _classrooms[idx].admins.remove(admin);
      _classrooms.refresh();
    }
  }
}
