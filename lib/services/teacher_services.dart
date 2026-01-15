import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../models/course.dart';
import '../models/teacher.dart';
import 'api_url.dart';

class TeacherServices {
  // Get all courses (for course selection in teacher form)
  static Future<List<Course>> getAllCourses() async {
    final response = await _dio.get(ApiUrl.getAllCourses);
    final List data = response.data;
    return data.map((e) => Course.fromJson(e)).toList();
  }

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiUrl.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  )..interceptors.add(PrettyDioLogger());

  // Create teacher (with profile photo)
  static Future<Teacher> createTeacher(
    Map<String, dynamic> data, {
    String? profilePhotoPath,
  }) async {
    final formData = FormData.fromMap(data);
    if (profilePhotoPath != null && profilePhotoPath.isNotEmpty) {
      formData.files.add(
        MapEntry(
          'profile_photo',
          await MultipartFile.fromFile(
            profilePhotoPath,
            filename: 'profile.jpg',
          ),
        ),
      );
    }
    final response = await _dio.post(ApiUrl.createTeacher, data: formData);
    // Optionally fetch the created teacher by id
    final teacherId = response.data['teacher_id'] ?? '';
    if (teacherId.isNotEmpty) {
      return getTeacherById(teacherId);
    }
    throw Exception('Failed to create teacher');
  }

  // Get all teachers
  static Future<List<Teacher>> getAllTeachers() async {
    final response = await _dio.get(ApiUrl.getAllTeachers);
    final List data = response.data;
    return data.map((e) => Teacher.fromJson(e)).toList();
  }

  // Get teacher by id
  static Future<Teacher> getTeacherById(String teacherId) async {
    final response = await _dio.get(ApiUrl.getTeacherById(teacherId));
    return Teacher.fromJson(response.data);
  }

  // Update teacher (with profile photo)
  static Future<Teacher> updateTeacher(
    String teacherId,
    Map<String, dynamic> data, {
    String? profilePhotoPath,
  }) async {
    final formData = FormData.fromMap(data);
    if (profilePhotoPath != null && profilePhotoPath.isNotEmpty) {
      formData.files.add(
        MapEntry(
          'profile_photo',
          await MultipartFile.fromFile(
            profilePhotoPath,
            filename: 'profile.jpg',
          ),
        ),
      );
    }
    final response = await _dio.put(
      ApiUrl.updateTeacher(teacherId),
      data: formData,
    );
    return Teacher.fromJson(response.data);
  }

  // Delete teacher by id
  static Future<void> deleteTeacher(String teacherId) async {
    await _dio.delete(ApiUrl.deleteTeacher(teacherId));
  }

  // Bulk delete teachers
  static Future<void> bulkDeleteTeachers(List<String> ids) async {
    final query = ids
        .map((e) => 'ids=${Uri.encodeQueryComponent(e)}')
        .join('&');
    final url = '${ApiUrl.bulkDeleteTeachers}?$query';
    await _dio.delete(url);
  }
}
