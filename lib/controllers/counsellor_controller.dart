import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/counsellor.dart';

class CounsellorController extends GetxController {
  // Observable state
  final RxList<Counsellor> counsellors = <Counsellor>[].obs;
  final RxList<Counsellor> filteredCounsellors = <Counsellor>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isCreating = false.obs;

  // Search controllers
  final searchNameController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    getAllCounsellors();
    searchNameController.addListener(_filterCounsellors);
  }

  @override
  void onClose() {
    searchNameController.dispose();
    super.onClose();
  }

  // Get all counsellors
  Future<void> getAllCounsellors() async {
    try {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 1));

      counsellors.value = [
        Counsellor(
          id: 'CNS001',
          name: 'Dr. Priya Verma',
          phoneNumber: '9876543210',
          email: 'priya.verma@vwings.com',
          address: '78 Wellness Park, Mumbai',
          experienceYears: 12,
          qualification: 'M.Phil - Psychology, Ph.D - Counselling',
          commissionPercentage: 5.5,
          alternatePhoneNumber: '9876543211',
          password: 'SecurePass123',
          profilePhotoUrl: null,
          bio:
              'Senior counsellor with extensive experience in student mentoring and career guidance. Specialized in personality development and stress management.',
        ),
        Counsellor(
          id: 'CNS002',
          name: 'Ms. Anjali Malhotra',
          phoneNumber: '9876543220',
          email: 'anjali.malhotra@vwings.com',
          address: '42 Guidance Avenue, Delhi',
          experienceYears: 8,
          qualification: 'M.A - Counselling Psychology',
          commissionPercentage: 4.5,
          alternatePhoneNumber: '9876543221',
          password: 'SecurePass123',
          profilePhotoUrl: null,
          bio:
              'Career counsellor with focus on aviation industry guidance. Helps students identify their potential and career path in aviation sector.',
        ),
        Counsellor(
          id: 'CNS003',
          name: 'Mr. Rakesh Nair',
          phoneNumber: '9876543230',
          email: 'rakesh.nair@vwings.com',
          address: '56 Mentor Street, Bangalore',
          experienceYears: 10,
          qualification: 'M.Sc - Educational Psychology',
          commissionPercentage: 4.0,
          alternatePhoneNumber: '9876543231',
          password: 'SecurePass123',
          profilePhotoUrl: null,
          bio:
              'Educational counsellor specializing in academic performance improvement and study techniques for aviation programs.',
        ),
        Counsellor(
          id: 'CNS004',
          name: 'Ms. Neha Deshmukh',
          phoneNumber: '9876543240',
          email: 'neha.deshmukh@vwings.com',
          address: '89 Support Lane, Pune',
          experienceYears: 7,
          qualification: 'M.A - Clinical Psychology, B.Ed',
          commissionPercentage: 3.5,
          alternatePhoneNumber: '9876543241',
          password: 'SecurePass123',
          profilePhotoUrl: null,
          bio:
              'Mental health and wellness counsellor. Provides support for personal development and emotional well-being of students.',
        ),
        Counsellor(
          id: 'CNS005',
          name: 'Dr. Arun Saxena',
          phoneNumber: '9876543250',
          email: 'arun.saxena@vwings.com',
          address: '23 Advisory Drive, Hyderabad',
          experienceYears: 15,
          qualification: 'Ph.D - Guidance and Counselling',
          commissionPercentage: 6.0,
          alternatePhoneNumber: '9876543251',
          password: 'SecurePass123',
          profilePhotoUrl: null,
          bio:
              'Lead counsellor and department head. Expert in student integration and institution-wide counselling program development.',
        ),
      ];

      filteredCounsellors.value = List.from(counsellors);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load counsellors',
        backgroundColor: const Color(0xFFE53935),
        colorText: const Color(0xFFFEFEFE),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Search counsellors by name or phone
  void searchByNameAndPhone(String name, String phone) {
    if (name.isEmpty && phone.isEmpty) {
      filteredCounsellors.value = List.from(counsellors);
    } else {
      final query = (name.isNotEmpty ? name : phone).toLowerCase();
      filteredCounsellors.value = counsellors
          .where(
            (c) =>
                c.name.toLowerCase().contains(query) ||
                c.phoneNumber.toLowerCase().contains(query),
          )
          .toList();
    }
  }

  // Private filter method
  void _filterCounsellors() {
    searchByNameAndPhone(searchNameController.text, searchNameController.text);
  }

  // Add new counsellor
  Future<void> addCounsellor(Counsellor counsellor) async {
    try {
      isCreating.value = true;
      await Future.delayed(const Duration(seconds: 1));

      counsellors.add(counsellor);
      filteredCounsellors.value = List.from(counsellors);

      Get.snackbar(
        'Success',
        'Counsellor added successfully!',
        backgroundColor: const Color(0xFF4CAF50),
        colorText: const Color(0xFFFEFEFE),
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add counsellor',
        backgroundColor: const Color(0xFFE53935),
        colorText: const Color(0xFFFEFEFE),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isCreating.value = false;
    }
  }

  // Edit counsellor
  Future<void> editCounsellor(String id, Counsellor updatedCounsellor) async {
    try {
      isCreating.value = true;
      await Future.delayed(const Duration(seconds: 1));

      final index = counsellors.indexWhere((c) => c.id == id);
      if (index != -1) {
        counsellors[index] = updatedCounsellor;
        filteredCounsellors.value = List.from(counsellors);

        Get.snackbar(
          'Success',
          'Counsellor updated successfully!',
          backgroundColor: const Color(0xFF4CAF50),
          colorText: const Color(0xFFFEFEFE),
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update counsellor',
        backgroundColor: const Color(0xFFE53935),
        colorText: const Color(0xFFFEFEFE),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isCreating.value = false;
    }
  }

  // Delete counsellor
  Future<void> deleteCounsellor(String id) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      counsellors.removeWhere((c) => c.id == id);
      filteredCounsellors.value = List.from(counsellors);

      Get.snackbar(
        'Success',
        'Counsellor deleted successfully!',
        backgroundColor: const Color(0xFF4CAF50),
        colorText: const Color(0xFFFEFEFE),
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete counsellor',
        backgroundColor: const Color(0xFFE53935),
        colorText: const Color(0xFFFEFEFE),
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  // Refresh counsellors
  Future<void> refreshCounsellors() async {
    await getAllCounsellors();
  }
}
