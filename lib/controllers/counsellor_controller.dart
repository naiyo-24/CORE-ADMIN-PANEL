import 'dart:typed_data';
import 'package:application_admin_panel/widgets/snackber_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/counsellor.dart';
import '../services/counsellor_services.dart';

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
      final service = CounsellorService();
      final fetched = await service.getAllCounsellors();
      counsellors.value = fetched;
      filteredCounsellors.value = List.from(counsellors);
    } catch (e) {
      safeSnackbar('Error', 'Failed to load counsellors', backgroundColor: const Color(0xFFE53935), colorText: const Color(0xFFFEFEFE), snackPosition: SnackPosition.TOP);
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
  Future<void> addCounsellor(
    Counsellor counsellor, {
    Uint8List? profilePhotoBytes,
    String? profilePhotoFilename,
  }) async {
    try {
      isCreating.value = true;
      final service = CounsellorService();
      final created = await service.createCounsellor(
        counsellor: counsellor,
        profilePhotoBytes: profilePhotoBytes,
        profilePhotoFilename: profilePhotoFilename,
      );
      if (created != null) {
        counsellors.add(created);
        filteredCounsellors.value = List.from(counsellors);
      }
    } catch (e) {
      safeSnackbar('Error', 'Failed to add counsellor', backgroundColor: const Color(0xFFE53935), colorText: const Color(0xFFFEFEFE), snackPosition: SnackPosition.TOP);
    } finally {
      isCreating.value = false;
    }
  }

  // Edit counsellor
  Future<void> editCounsellor(
    String id,
    Counsellor updatedCounsellor, {
    Uint8List? profilePhotoBytes,
    String? profilePhotoFilename,
  }) async {
    try {
      isCreating.value = true;
      final service = CounsellorService();
      final updated = await service.updateCounsellor(
        id: id,
        fields: updatedCounsellor.toJson(),
        profilePhotoBytes: profilePhotoBytes,
        profilePhotoFilename: profilePhotoFilename,
      );
      final index = counsellors.indexWhere((c) => c.id == id);
      if (index != -1) {
        counsellors[index] = updated;
        filteredCounsellors.value = List.from(counsellors);
      }
    } catch (e) {
      safeSnackbar('Error', 'Failed to update counsellor', backgroundColor: const Color(0xFFE53935), colorText: const Color(0xFFFEFEFE), snackPosition: SnackPosition.TOP);
    } finally {
      isCreating.value = false;
    }
  }

  // Delete counsellor
  Future<void> deleteCounsellor(String id) async {
    try {
      final service = CounsellorService();
      await service.deleteCounsellor(id);
      counsellors.removeWhere((c) => c.id == id);
      filteredCounsellors.value = List.from(counsellors);
    } catch (e) {
      safeSnackbar('Error', 'Failed to delete counsellor', backgroundColor: const Color(0xFFE53935), colorText: const Color(0xFFFEFEFE), snackPosition: SnackPosition.TOP);
    }
  }

  // Refresh counsellors
  Future<void> refreshCounsellors() async {
    await getAllCounsellors();
  }
}
