import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../models/student.dart';
import 'api_url.dart';

class StudentServices {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiUrl.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  )..interceptors.add(PrettyDioLogger());

  // Create student (with profile photo)
  Future<Student> createStudent(
    Map<String, dynamic> data, {
    String? filePath,
    List<int>? fileBytes,
    String? fileName,
  }) async {
    final formData = FormData();
    // Only send fields required by FastAPI
    final requiredFields = [
      'full_name',
      'phone_no',
      'email',
      'address',
      'guardian_name',
      'guardian_mobile_no',
      'guardian_email',
      'course_availing',
      'interests',
      'password',
    ];
    for (final key in requiredFields) {
      final value = data[key];
      if (value != null) {
        if (key == 'interests' && value is List) {
          formData.fields.add(MapEntry('interests', jsonEncode(value)));
        } else {
          formData.fields.add(MapEntry(key, value.toString()));
        }
      }
    }
    // Only send profile_photo if a file is selected
    if (filePath != null || (fileBytes != null && fileName != null)) {
      MultipartFile? file;
      if (kIsWeb) {
        if (fileBytes != null && fileName != null) {
          file = MultipartFile.fromBytes(fileBytes, filename: fileName);
        }
      } else {
        if (filePath != null) {
          file = await MultipartFile.fromFile(
            filePath,
            filename: filePath.split('/').last,
          );
        } else if (fileBytes != null && fileName != null) {
          file = MultipartFile.fromBytes(fileBytes, filename: fileName);
        }
      }
      if (file != null) {
        formData.files.add(MapEntry('profile_photo', file));
      }
    }
    final response = await _dio.post(ApiUrl.createStudent, data: formData);
    return Student.fromJson(response.data);
  }

  // Get all students
  Future<List<Student>> getAllStudents() async {
    final response = await _dio.get(ApiUrl.getAllStudents);
    return (response.data as List).map((e) => Student.fromJson(e)).toList();
  }

  // Get student by ID
  Future<Student> getStudentById(String studentId) async {
    final response = await _dio.get(ApiUrl.getStudentById(studentId));
    return Student.fromJson(response.data);
  }

  // Update student (with profile photo)
  Future<Student> updateStudent(
    String studentId,
    Map<String, dynamic> data, {
    String? filePath,
    List<int>? fileBytes,
    String? fileName,
  }) async {
    final formData = FormData();
    // Only send fields required by FastAPI, and do not send profile_photo as string
    final allowedFields = [
      'full_name',
      'phone_no',
      'email',
      'address',
      'guardian_name',
      'guardian_mobile_no',
      'guardian_email',
      'course_availing',
      'interests',
      'password',
    ];
    for (final key in allowedFields) {
      final value = data[key];
      if (value != null) {
        if (key == 'interests' && value is List) {
          formData.fields.add(MapEntry('interests', jsonEncode(value)));
        } else {
          formData.fields.add(MapEntry(key, value.toString()));
        }
      }
    }
    // Only send profile_photo as file if a file is selected
    if (filePath != null || (fileBytes != null && fileName != null)) {
      MultipartFile? file;
      if (kIsWeb) {
        if (fileBytes != null && fileName != null) {
          file = MultipartFile.fromBytes(fileBytes, filename: fileName);
        }
      } else {
        if (filePath != null) {
          file = await MultipartFile.fromFile(
            filePath,
            filename: filePath.split('/').last,
          );
        } else if (fileBytes != null && fileName != null) {
          file = MultipartFile.fromBytes(fileBytes, filename: fileName);
        }
      }
      if (file != null) {
        formData.files.add(MapEntry('profile_photo', file));
      }
    }
    final response = await _dio.put(
      ApiUrl.updateStudent(studentId),
      data: formData,
    );
    return Student.fromJson(response.data);
  }

  // Delete student by ID
  Future<void> deleteStudent(String studentId) async {
    await _dio.delete(ApiUrl.deleteStudent(studentId));
  }

  // Bulk delete students
  Future<void> bulkDeleteStudents(List<String> studentIds) async {
    await _dio.delete(
      ApiUrl.bulkDeleteStudents,
      data: jsonEncode({'student_ids': studentIds}),
    );
  }
}
