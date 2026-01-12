import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/student.dart';

class StudentController extends GetxController {
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

  // Fetch all students
  Future<void> fetchStudents() async {
    try {
      isLoading.value = true;

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Mock data
      students.value = [
        Student(
          id: 'STU001',
          fullName: 'Rajesh Kumar',
          phoneNumber: '9876543210',
          email: 'rajesh.kumar@email.com',
          address: '123 Aviation Street, Delhi',
          course: 'Commercial Pilot License',
          guardianName: 'Amit Kumar',
          guardianPhoneNumber: '9876543211',
          guardianEmail: 'amit.kumar@email.com',
          interests: ['Aviation', 'Flying', 'Navigation'],
          profilePhotoUrl: null,
          enrollmentDate: DateTime(2024, 6, 15),
          password: 'password123',
        ),
        Student(
          id: 'STU002',
          fullName: 'Priya Sharma',
          phoneNumber: '9876543220',
          email: 'priya.sharma@email.com',
          address: '456 Sky Lane, Mumbai',
          course: 'Air Hostess Training',
          guardianName: 'Vikram Sharma',
          guardianPhoneNumber: '9876543221',
          guardianEmail: 'vikram.sharma@email.com',
          interests: ['Hospitality', 'Travel', 'Customer Service'],
          profilePhotoUrl: null,
          enrollmentDate: DateTime(2024, 7, 20),
          password: 'password123',
        ),
        Student(
          id: 'STU003',
          fullName: 'Arjun Patel',
          phoneNumber: '9876543230',
          email: 'arjun.patel@email.com',
          address: '789 Wing Avenue, Bangalore',
          course: 'Ground Staff Training',
          guardianName: 'Rohan Patel',
          guardianPhoneNumber: '9876543231',
          guardianEmail: 'rohan.patel@email.com',
          interests: ['Operations', 'Logistics', 'Technology'],
          profilePhotoUrl: null,
          enrollmentDate: DateTime(2024, 8, 10),
          password: 'password123',
        ),
        Student(
          id: 'STU004',
          fullName: 'Neha Singh',
          phoneNumber: '9876543240',
          email: 'neha.singh@email.com',
          address: '321 Runway Road, Hyderabad',
          course: 'Cabin Crew Diploma',
          guardianName: 'Rajiv Singh',
          guardianPhoneNumber: '9876543241',
          guardianEmail: 'rajiv.singh@email.com',
          interests: ['Aviation', 'Languages', 'Travel'],
          profilePhotoUrl: null,
          enrollmentDate: DateTime(2024, 9, 05),
          password: 'password123',
        ),
        Student(
          id: 'STU005',
          fullName: 'Vishal Gupta',
          phoneNumber: '9876543250',
          email: 'vishal.gupta@email.com',
          address: '654 Airfield Drive, Chennai',
          course: 'Pilot Training',
          guardianName: 'Suresh Gupta',
          guardianPhoneNumber: '9876543251',
          guardianEmail: 'suresh.gupta@email.com',
          interests: ['Aerospace', 'Engineering', 'Flying'],
          profilePhotoUrl: null,
          enrollmentDate: DateTime(2024, 10, 12),
          password: 'password123',
        ),
      ];

      filteredStudents.value = List.from(students);
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
      final phoneMatch = student.phoneNumber.contains(query);

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
      final phoneMatch = student.phoneNumber.contains(phoneQuery);

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

  // Add new student
  Future<void> addStudent(Student student) async {
    try {
      isCreating.value = true;
      await Future.delayed(const Duration(seconds: 1));

      students.add(student);
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
  Future<void> editStudent(String id, Student updatedStudent) async {
    try {
      isCreating.value = true;
      await Future.delayed(const Duration(seconds: 1));

      final index = students.indexWhere((s) => s.id == id);
      if (index != -1) {
        students[index] = updatedStudent;
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
  Future<void> deleteStudent(String id) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      students.removeWhere((s) => s.id == id);
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

  // Refresh students
  Future<void> refreshStudents() async {
    await fetchStudents();
  }
}
