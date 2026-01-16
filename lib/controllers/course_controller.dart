import 'dart:io';
import 'dart:typed_data';
import 'package:application_admin_panel/widgets/snackber_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/course.dart';
import '../services/course_services.dart';

class CourseController extends GetxController {
  final RxList<Course> courses = <Course>[].obs;
  final RxList<Course> filteredCourses = <Course>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isCreating = false.obs;

  final searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    getAllCourses();
    searchController.addListener(_filterCourses);
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> getAllCourses() async {
    try {
      isLoading.value = true;

      // Fetch courses from API
      final fetchedCourses = await CourseServices.getAllCourses();

      courses.value = fetchedCourses;
      filteredCourses.value = List.from(courses);
    } catch (e) {
      safeSnackbar(
        'Error',
        'Failed to load courses: ${e.toString()}',
        backgroundColor: const Color(0xFFE53935),
        colorText: const Color(0xFFFEFEFE),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addCourse(
    Course course, {
    File? photoFile,
    File? videoFile,
    Uint8List? photoBytes,
    String? photoName,
    Uint8List? videoBytes,
    String? videoName,
  }) async {
    try {
      isCreating.value = true;
      // Add course via API (new structure)
      await CourseServices.createCourse(
        course,
        photoFile: photoFile,
        videoFile: videoFile,
        photoBytes: photoBytes,
        photoName: photoName,
        videoBytes: videoBytes,
        videoName: videoName,
      );
      await getAllCourses();
    } catch (e) {
      safeSnackbar(
        'Error',
        'Failed to add course: ${e.toString()}',
        backgroundColor: const Color(0xFFE53935),
        colorText: const Color(0xFFFEFEFE),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isCreating.value = false;
    }
  }

  Future<void> editCourse(
    String courseId,
    Course updatedCourse, {
    File? photoFile,
    File? videoFile,
    Uint8List? photoBytes,
    String? photoName,
    Uint8List? videoBytes,
    String? videoName,
  }) async {
    try {
      isCreating.value = true;
      // Update course via API (new structure)
      await CourseServices.updateCourse(
        courseId,
        updatedCourse,
        photoFile: photoFile,
        videoFile: videoFile,
        photoBytes: photoBytes,
        photoName: photoName,
        videoBytes: videoBytes,
        videoName: videoName,
      );
      await getAllCourses();
    } catch (e) {
      safeSnackbar(
        'Error',
        'Failed to update course: ${e.toString()}',
        backgroundColor: const Color(0xFFE53935),
        colorText: const Color(0xFFFEFEFE),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isCreating.value = false;
    }
  }

  Future<void> deleteCourse(String courseCode) async {
    try {
      // Delete course via API (single row, both categories)
      await CourseServices.deleteCourse(courseCode);
      courses.removeWhere((c) => c.code == courseCode);
      filteredCourses.value = List.from(courses);
    } catch (e) {
      safeSnackbar(
        'Error',
        'Failed to delete course: ${e.toString()}',
        backgroundColor: const Color(0xFFE53935),
        colorText: const Color(0xFFFEFEFE),
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  void searchByCodeOrName(String query) {
    if (query.isEmpty) {
      filteredCourses.value = List.from(courses);
    } else {
      final lowerQuery = query.toLowerCase();
      filteredCourses.value = courses
          .where(
            (c) =>
                c.name.toLowerCase().contains(lowerQuery) ||
                c.code.toLowerCase().contains(lowerQuery),
          )
          .toList();
    }
  }

  void _filterCourses() {
    searchByCodeOrName(searchController.text);
  }

  Future<void> refreshCourses() async {
    await getAllCourses();
  }
}
