import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/student.dart';
import '../services/student_services.dart';

class StudentController extends GetxController {
  final StudentServices _studentServices = StudentServices();
  // Observable state
  final RxList<Student> students = <Student>[].obs;
  final RxList<Student> filteredStudents = <Student>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isCreating = false.obs;

  // Search controllers
  final searchNameController = TextEditingController();
  final searchPhoneController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchStudents();
    // Listen to search changes
    searchNameController.addListener(_filterStudents);
    searchPhoneController.addListener(_filterStudents);
  }

  @override
  void onClose() {
    searchNameController.dispose();
    searchPhoneController.dispose();
    super.onClose();
  }

  // Add new student
  Future<void> addStudent(
    Student student, {
    String? filePath,
    List<int>? fileBytes,
    String? fileName,
  }) async {
    try {
      isCreating.value = true;
      final created = await _studentServices.createStudent(
        student.toJson(),
        filePath: filePath,
        fileBytes: fileBytes,
        fileName: fileName,
      );
      students.add(created);
      filteredStudents.value = List.from(students);
      Get.snackbar(
        'Success',
        'Student onboarded successfully!',
        backgroundColor: const Color(0xFF4CAF50),
        colorText: const Color(0xFFFEFEFE),
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to onboard student',
        backgroundColor: const Color(0xFFE53935),
        colorText: const Color(0xFFFEFEFE),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isCreating.value = false;
    }
  }

  // Edit student
  Future<void> editStudent(
    String studentId,
    Student updatedStudent, {
    String? filePath,
    List<int>? fileBytes,
    String? fileName,
  }) async {
    try {
      isCreating.value = true;
      final edited = await _studentServices.updateStudent(
        studentId,
        updatedStudent.toJson(),
        filePath: filePath,
        fileBytes: fileBytes,
        fileName: fileName,
      );
      final index = students.indexWhere((s) => s.studentId == studentId);
      if (index != -1) {
        students[index] = edited;
        filteredStudents.value = List.from(students);
        Get.snackbar(
          'Success',
          'Student updated successfully!',
          backgroundColor: const Color(0xFF4CAF50),
          colorText: const Color(0xFFFEFEFE),
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update student',
        backgroundColor: const Color(0xFFE53935),
        colorText: const Color(0xFFFEFEFE),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isCreating.value = false;
    }
  }

  // Delete student
  Future<void> deleteStudent(String studentId) async {
    try {
      await _studentServices.deleteStudent(studentId);
      students.removeWhere((s) => s.studentId == studentId);
      filteredStudents.value = List.from(students);
      Get.snackbar(
        'Success',
        'Student deleted successfully!',
        backgroundColor: const Color(0xFF4CAF50),
        colorText: const Color(0xFFFEFEFE),
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete student',
        backgroundColor: const Color(0xFFE53935),
        colorText: const Color(0xFFFEFEFE),
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  // Fetch all students
  Future<void> fetchStudents() async {
    try {
      isLoading.value = true;
      final result = await _studentServices.getAllStudents();
      students.value = result;
      filteredStudents.value = List.from(result);
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching students: $e');
      }
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch all students (alias for fetchStudents)
  Future<void> getAllStudents() async {
    await fetchStudents();
  }

  // Search by name and phone
  void searchByNameAndPhone(String name, String phone) {
    final query = name.toLowerCase();

    if (query.isEmpty) {
      filteredStudents.value = List.from(students);
      return;
    }

    filteredStudents.value = students.where((student) {
      final nameMatch = student.fullName.toLowerCase().contains(query);
      final phoneMatch = student.phoneNo.contains(query);

      // Return true if either name or phone matches
      return nameMatch || phoneMatch;
    }).toList();
  }

  // Filter students based on search
  void _filterStudents() {
    final nameQuery = searchNameController.text.toLowerCase();
    final phoneQuery = searchPhoneController.text;

    if (nameQuery.isEmpty && phoneQuery.isEmpty) {
      filteredStudents.value = List.from(students);
      return;
    }

    filteredStudents.value = students.where((student) {
      final nameMatch = student.fullName.toLowerCase().contains(nameQuery);
      final phoneMatch = student.phoneNo.contains(phoneQuery);

      if (nameQuery.isNotEmpty && phoneQuery.isNotEmpty) {
        return nameMatch && phoneMatch;
      }
      if (nameQuery.isNotEmpty) {
        return nameMatch;
      }
      if (phoneQuery.isNotEmpty) {
        return phoneMatch;
      }
      return true;
    }).toList();
  }

  // Refresh students
  Future<void> refreshStudents() async {
    await fetchStudents();
  }
}
