import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/course.dart';

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
      await Future.delayed(const Duration(seconds: 1));

      courses.value = [
        Course(
          id: 'CRS001',
          name: 'Commercial Pilot License (CPL)',
          description:
              'Comprehensive program for aspiring commercial pilots with advanced flight training and navigation skills.',
          code: 'CPL-001',
          weightRequirements: 'No specific requirements',
          heightRequirements: 'Minimum 5 feet (152 cm)',
          visionStandards: '6/6 in both eyes',
          medicalRequirements: 'Class 1 Medical Certificate',
          minEducationalQualification: '12th Pass',
          ageCriteria: '18-32 years',
          internshipIncluded: true,
          installmentAvailable: true,
          installmentPolicy:
              'EMI available for 12-24 months with zero interest',
          photoUrl: null,
          videoUrl: null,
          generalCategory: CourseCategory(
            jobRolesOffered:
                'Commercial Pilot, Flight Instructor, Charter Pilot',
            placementAssistance: true,
            placementType: 'Assisted',
            placementRate: 95.0,
            advantagesHighlights:
                'International recognition, Career growth, Global opportunities',
            courseFees: 2500000,
          ),
          executiveCategory: CourseCategory(
            jobRolesOffered: 'Airline Pilot, Senior Pilot',
            placementAssistance: true,
            placementType: 'Guaranteed',
            placementRate: 98.0,
            advantagesHighlights:
                'Premium training, Direct airline placements, Leadership roles',
            courseFees: 3500000,
          ),
        ),
        Course(
          id: 'CRS002',
          name: 'Aircraft Maintenance Engineering (AME)',
          description:
              'Complete aircraft maintenance and engineering certification program.',
          code: 'AME-001',
          weightRequirements: 'No specific requirements',
          heightRequirements: 'Minimum 5 feet 2 inches',
          visionStandards: '6/9 in both eyes',
          medicalRequirements: 'Class 3 Medical Certificate',
          minEducationalQualification: '12th Pass (PCM)',
          ageCriteria: '17-28 years',
          internshipIncluded: true,
          installmentAvailable: true,
          installmentPolicy: 'Flexible payment plans available',
          photoUrl: null,
          videoUrl: null,
          generalCategory: CourseCategory(
            jobRolesOffered:
                'Aircraft Maintenance Technician, Line Technician, Hangar Technician',
            placementAssistance: true,
            placementType: 'Assisted',
            placementRate: 92.0,
            advantagesHighlights:
                'Industry certifications, Hands-on training, Job ready skills',
            courseFees: 1800000,
          ),
          executiveCategory: CourseCategory(
            jobRolesOffered: 'Senior Maintenance Engineer, Quality Assurance',
            placementAssistance: true,
            placementType: 'Guaranteed',
            placementRate: 96.0,
            advantagesHighlights:
                'Advanced certifications, Management training, High salary',
            courseFees: 2500000,
          ),
        ),
        Course(
          id: 'CRS003',
          name: 'Cabin Crew Training',
          description:
              'Professional cabin crew training for airlines and travel.',
          code: 'CC-001',
          weightRequirements: 'Proportionate to height',
          heightRequirements:
              'Minimum 5 feet 1 inch (Female), 5 feet 4 inch (Male)',
          visionStandards: '6/9 in better eye, 6/12 in other',
          medicalRequirements: 'Class 3 Medical Certificate',
          minEducationalQualification: '12th Pass',
          ageCriteria: '18-27 years',
          internshipIncluded: true,
          installmentAvailable: true,
          installmentPolicy: 'Monthly installments available',
          photoUrl: null,
          videoUrl: null,
          generalCategory: CourseCategory(
            jobRolesOffered: 'Flight Attendant, Cabin Crew, Customer Service',
            placementAssistance: true,
            placementType: 'Assisted',
            placementRate: 88.0,
            advantagesHighlights:
                'International travel, Professional development, Good salary',
            courseFees: 800000,
          ),
          executiveCategory: CourseCategory(
            jobRolesOffered: 'Senior Cabin Crew, In-flight Supervisor',
            placementAssistance: true,
            placementType: 'Guaranteed',
            placementRate: 94.0,
            advantagesHighlights:
                'Leadership roles, Premium airlines, Higher compensation',
            courseFees: 1200000,
          ),
        ),
      ];

      filteredCourses.value = List.from(courses);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load courses',
        backgroundColor: const Color(0xFFE53935),
        colorText: const Color(0xFFFEFEFE),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
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

  Future<void> addCourse(Course course) async {
    try {
      isCreating.value = true;
      await Future.delayed(const Duration(seconds: 1));

      courses.add(course);
      filteredCourses.value = List.from(courses);

      Get.snackbar(
        'Success',
        'Course added successfully!',
        backgroundColor: const Color(0xFF4CAF50),
        colorText: const Color(0xFFFEFEFE),
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add course',
        backgroundColor: const Color(0xFFE53935),
        colorText: const Color(0xFFFEFEFE),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isCreating.value = false;
    }
  }

  Future<void> editCourse(String id, Course updatedCourse) async {
    try {
      isCreating.value = true;
      await Future.delayed(const Duration(seconds: 1));

      final index = courses.indexWhere((c) => c.id == id);
      if (index != -1) {
        courses[index] = updatedCourse;
        filteredCourses.value = List.from(courses);

        Get.snackbar(
          'Success',
          'Course updated successfully!',
          backgroundColor: const Color(0xFF4CAF50),
          colorText: const Color(0xFFFEFEFE),
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update course',
        backgroundColor: const Color(0xFFE53935),
        colorText: const Color(0xFFFEFEFE),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isCreating.value = false;
    }
  }

  Future<void> deleteCourse(String id) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      courses.removeWhere((c) => c.id == id);
      filteredCourses.value = List.from(courses);

      Get.snackbar(
        'Success',
        'Course deleted successfully!',
        backgroundColor: const Color(0xFF4CAF50),
        colorText: const Color(0xFFFEFEFE),
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete course',
        backgroundColor: const Color(0xFFE53935),
        colorText: const Color(0xFFFEFEFE),
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<void> refreshCourses() async {
    await getAllCourses();
  }
}
