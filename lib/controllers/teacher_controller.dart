import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/teacher.dart';

class TeacherController extends GetxController {
  // Observable state
  final RxList<Teacher> teachers = <Teacher>[].obs;
  final RxList<Teacher> filteredTeachers = <Teacher>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isCreating = false.obs;

  // Search controllers
  final searchNameController = TextEditingController();
  final searchPhoneController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchTeachers();
    // Listen to search changes
    searchNameController.addListener(_filterTeachers);
    searchPhoneController.addListener(_filterTeachers);
  }

  @override
  void onClose() {
    searchNameController.dispose();
    searchPhoneController.dispose();
    super.onClose();
  }

  // Fetch all teachers
  Future<void> fetchTeachers() async {
    try {
      isLoading.value = true;

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Mock data
      teachers.value = [
        Teacher(
          id: 'TCH001',
          teacherName: 'Dr. Ramesh Sharma',
          phoneNumber: '9876543210',
          email: 'ramesh.sharma@vwings.com',
          alternativePhoneNumber: '9876543211',
          address: '45 Education Lane, Delhi',
          specialization: 'Aviation Theory',
          classroomsInCharge: ['Room A-101', 'Room A-102'],
          experienceYears: 15,
          profilePhotoUrl: null,
          password: 'password123',
          bio:
              'Experienced aviation instructor with 15 years of teaching excellence in theoretical aviation concepts.',
        ),
        Teacher(
          id: 'TCH002',
          teacherName: 'Capt. Meera Desai',
          phoneNumber: '9876543220',
          email: 'meera.desai@vwings.com',
          alternativePhoneNumber: '9876543221',
          address: '78 Sky Boulevard, Mumbai',
          specialization: 'Flight Simulation',
          classroomsInCharge: ['Simulator Bay 1', 'Simulator Bay 2'],
          experienceYears: 12,
          profilePhotoUrl: null,
          password: 'password123',
          bio:
              'Former commercial pilot turned instructor specializing in advanced flight simulation training.',
        ),
        Teacher(
          id: 'TCH003',
          teacherName: 'Prof. Anil Kumar',
          phoneNumber: '9876543230',
          email: 'anil.kumar@vwings.com',
          alternativePhoneNumber: '9876543231',
          address: '12 Aviation Street, Bangalore',
          specialization: 'Aircraft Maintenance',
          classroomsInCharge: ['Workshop A', 'Room B-201'],
          experienceYears: 20,
          profilePhotoUrl: null,
          password: 'password123',
          bio:
              'Aircraft maintenance engineer with two decades of industry and teaching experience.',
        ),
        Teacher(
          id: 'TCH004',
          teacherName: 'Ms. Priya Patel',
          phoneNumber: '9876543240',
          email: 'priya.patel@vwings.com',
          alternativePhoneNumber: '9876543241',
          address: '56 Training Center Road, Hyderabad',
          specialization: 'Cabin Crew Training',
          classroomsInCharge: ['Room C-101', 'Mock Cabin A'],
          experienceYears: 8,
          profilePhotoUrl: null,
          password: 'password123',
          bio:
              'Certified cabin crew trainer with extensive experience in hospitality and safety procedures.',
        ),
        Teacher(
          id: 'TCH005',
          teacherName: 'Wg Cdr. Vikram Singh',
          phoneNumber: '9876543250',
          email: 'vikram.singh@vwings.com',
          alternativePhoneNumber: '9876543251',
          address: '89 Defense Colony, Chennai',
          specialization: 'Navigation & Meteorology',
          classroomsInCharge: ['Room D-101', 'Lab A'],
          experienceYears: 18,
          profilePhotoUrl: null,
          password: 'password123',
          bio:
              'Retired Air Force officer with expertise in navigation systems and meteorological analysis.',
        ),
      ];

      filteredTeachers.value = List.from(teachers);
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching teachers: $e');
      }
    } finally {
      isLoading.value = false;
    }
  }

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
      final nameMatch = teacher.teacherName.toLowerCase().contains(query);
      final phoneMatch = teacher.phoneNumber.contains(query);

      // Return true if either name or phone matches
      return nameMatch || phoneMatch;
    }).toList();
  }

  // Filter teachers based on search
  void _filterTeachers() {
    final nameQuery = searchNameController.text.toLowerCase();
    final phoneQuery = searchPhoneController.text;

    if (nameQuery.isEmpty && phoneQuery.isEmpty) {
      filteredTeachers.value = List.from(teachers);
      return;
    }

    filteredTeachers.value = teachers.where((teacher) {
      final nameMatch = teacher.teacherName.toLowerCase().contains(nameQuery);
      final phoneMatch = teacher.phoneNumber.contains(phoneQuery);

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

  // Add new teacher
  Future<void> addTeacher(Teacher teacher) async {
    try {
      isCreating.value = true;
      await Future.delayed(const Duration(seconds: 1));

      teachers.add(teacher);
      filteredTeachers.value = List.from(teachers);

      Get.snackbar(
        'Success',
        'Teacher onboarded successfully!',
        backgroundColor: const Color(0xFF4CAF50),
        colorText: const Color(0xFFFEFEFE),
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar(
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
  Future<void> editTeacher(String id, Teacher updatedTeacher) async {
    try {
      isCreating.value = true;
      await Future.delayed(const Duration(seconds: 1));

      final index = teachers.indexWhere((t) => t.id == id);
      if (index != -1) {
        teachers[index] = updatedTeacher;
        filteredTeachers.value = List.from(teachers);

        Get.snackbar(
          'Success',
          'Teacher updated successfully!',
          backgroundColor: const Color(0xFF4CAF50),
          colorText: const Color(0xFFFEFEFE),
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar(
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

  // Delete teacher
  Future<void> deleteTeacher(String id) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      teachers.removeWhere((t) => t.id == id);
      filteredTeachers.value = List.from(teachers);

      Get.snackbar(
        'Success',
        'Teacher deleted successfully!',
        backgroundColor: const Color(0xFF4CAF50),
        colorText: const Color(0xFFFEFEFE),
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete teacher',
        backgroundColor: const Color(0xFFE53935),
        colorText: const Color(0xFFFEFEFE),
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  // Refresh teachers
  Future<void> refreshTeachers() async {
    await fetchTeachers();
  }
}
