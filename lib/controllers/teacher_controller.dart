import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/snackber_helper.dart';
import '../models/teacher.dart';
import '../models/course.dart';
import '../services/teacher_services.dart';

class TeacherController extends GetxController {
  // Delete teacher
  Future<void> deleteTeacher(String id) async {
    try {
      await TeacherServices.deleteTeacher(id);
      await fetchTeachers();
    } catch (e) {
      safeSnackbar(
        'Error',
        'Failed to delete teacher',
        backgroundColor: const Color(0xFFE53935),
        colorText: const Color(0xFFFEFEFE),
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  // Courses for assigning to teachers
  final RxList<Course> courses = <Course>[].obs;
  final RxList<String> selectedCourseIds = <String>[].obs;

  // Fetch all courses for selection
  Future<void> fetchCourses() async {
    try {
      final result = await TeacherServices.getAllCourses();
      courses.value = result;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching courses: $e');
      }
      safeSnackbar(
        'Error',
        'Failed to fetch courses',
        backgroundColor: const Color(0xFFE53935),
        colorText: const Color(0xFFFEFEFE),
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  // Observable state
  final RxList<Teacher> teachers = <Teacher>[].obs;
  final RxList<Teacher> filteredTeachers = <Teacher>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isCreating = false.obs;

  // ...existing code...
  // Search controllers
  final searchNameController = TextEditingController();
  final searchPhoneController = TextEditingController();

  // Fetch all teachers (alias for fetchTeachers)
  Future<void> getAllTeachers() async {
    await fetchTeachers();
  }

  // Search by name and phone
  void searchByNameAndPhone(String name, String phone) {
    final query = name.toLowerCase();
    if (query.isEmpty) {
      filteredTeachers.value = List.from(teachers);
      return;
    }
    filteredTeachers.value = teachers.where((teacher) {
      final nameMatch = (teacher.fullName ?? '').toLowerCase().contains(query);
      final phoneMatch = (teacher.phoneNo ?? '').contains(query);
      return nameMatch || phoneMatch;
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    // Load courses and teachers when controller is initialized
    fetchCourses();
    fetchTeachers();
  }

  // Filter teachers based on search

  // Add new teacher
  Future<void> addTeacher(
    Teacher teacher, {
    String? profilePhotoPath,
    Uint8List? profilePhotoBytes,
    String? profilePhotoFilename,
  }) async {
    try {
      isCreating.value = true;
      final data = teacher.toJson();
      // Remove teacher_id for creation if present
      data.remove('teacher_id');
      // Convert courses_assigned to JSON string if needed
      if (data['courses_assigned'] is! String) {
        data['courses_assigned'] = jsonEncode(teacher.coursesAssigned);
      }
      await TeacherServices.createTeacher(
        data,
        profilePhotoPath: profilePhotoPath,
        profilePhotoBytes: profilePhotoBytes,
        profilePhotoFilename: profilePhotoFilename,
      );
      await fetchTeachers();
    } catch (e) {
      safeSnackbar(
        'Error',
        'Failed to onboard teacher',
        backgroundColor: const Color(0xFFE53935),
        colorText: const Color(0xFFFEFEFE),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isCreating.value = false;
    }
  }

  // Edit teacher
  Future<void> editTeacher(
    String id,
    Teacher updatedTeacher, {
    String? profilePhotoPath,
    Uint8List? profilePhotoBytes,
    String? profilePhotoFilename,
  }) async {
    try {
      isCreating.value = true;
      final data = updatedTeacher.toJson();
      // Convert courses_assigned to JSON string if needed
      if (data['courses_assigned'] is! String) {
        data['courses_assigned'] = jsonEncode(updatedTeacher.coursesAssigned);
      }
      await TeacherServices.updateTeacher(
        id,
        data,
        profilePhotoPath: profilePhotoPath,
        profilePhotoBytes: profilePhotoBytes,
        profilePhotoFilename: profilePhotoFilename,
      );
      await fetchTeachers();
    } catch (e) {
      safeSnackbar(
        'Error',
        'Failed to update teacher',
        backgroundColor: const Color(0xFFE53935),
        colorText: const Color(0xFFFEFEFE),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isCreating.value = false;
    }
  }

  // Fetch all teachers
  Future<void> fetchTeachers() async {
    try {
      isLoading.value = true;
      final result = await TeacherServices.getAllTeachers();
      teachers.value = result;
      filteredTeachers.value = List.from(result);
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching teachers: $e');
      }
      safeSnackbar(
        'Error',
        'Failed to fetch teachers',
        backgroundColor: const Color(0xFFE53935),
        colorText: const Color(0xFFFEFEFE),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
