import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../models/course.dart';
import 'api_url.dart';

class CourseServices {
  static final Dio _dio =
      Dio(
          BaseOptions(
            baseUrl: ApiUrl.baseUrl,
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        )
        ..interceptors.add(
          PrettyDioLogger(
            requestHeader: true,
            requestBody: true,
            responseBody: true,
            responseHeader: false,
            error: true,
            compact: true,
            maxWidth: 90,
          ),
        );

  /// Get all courses (new backend: both categories in one row)
  static Future<List<Course>> getAllCourses({
    int skip = 0,
    int limit = 100,
    bool? activeOnly,
  }) async {
    try {
      final queryParams = <String, dynamic>{'skip': skip, 'limit': limit};
      if (activeOnly != null) queryParams['active_only'] = activeOnly;

      final response = await _dio.get(
        ApiUrl.getAllCourses,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final List<dynamic> coursesData = response.data;
        return coursesData.map((e) => Course.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load courses: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error fetching courses: $e');
    }
  }

  /// Get course by ID (new backend)
  static Future<Course?> getCourseById(String courseId) async {
    try {
      final response = await _dio.get(ApiUrl.getCourseById(courseId));
      if (response.statusCode == 200) {
        return Course.fromJson(response.data as Map<String, dynamic>);
      } else {
        return null;
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error fetching course: $e');
    }
  }

  /// Create a new course (new backend: both categories in one row)
  static Future<Course> createCourse(
    Course course, {
    File? photoFile,
    File? videoFile,
    Uint8List? photoBytes,
    String? photoName,
    Uint8List? videoBytes,
    String? videoName,
  }) async {
    try {
      final formData = FormData();
      formData.fields.add(MapEntry('course_data', jsonEncode(course.toJson())));
      if (photoFile != null) {
        formData.files.add(
          MapEntry(
            'course_photo',
            await MultipartFile.fromFile(
              photoFile.path,
              filename: photoFile.path.split('/').last,
            ),
          ),
        );
      } else if (photoBytes != null) {
        formData.files.add(
          MapEntry(
            'course_photo',
            MultipartFile.fromBytes(
              photoBytes,
              filename: (photoName ?? 'photo'),
            ),
          ),
        );
      }
      if (videoFile != null) {
        formData.files.add(
          MapEntry(
            'course_video',
            await MultipartFile.fromFile(
              videoFile.path,
              filename: videoFile.path.split('/').last,
            ),
          ),
        );
      } else if (videoBytes != null) {
        formData.files.add(
          MapEntry(
            'course_video',
            MultipartFile.fromBytes(
              videoBytes,
              filename: (videoName ?? 'video'),
            ),
          ),
        );
      }
      final response = await _dio.post(
        ApiUrl.createCourse,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      if (response.statusCode == 201) {
        return Course.fromJson(response.data);
      } else {
        throw Exception('Failed to create course: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error creating course: $e');
    }
  }

  /// Update an existing course (new backend: both categories in one row)
  static Future<Course> updateCourse(
    String courseId,
    Course course, {
    File? photoFile,
    File? videoFile,
    Uint8List? photoBytes,
    String? photoName,
    Uint8List? videoBytes,
    String? videoName,
  }) async {
    try {
      final formData = FormData();
      formData.fields.add(MapEntry('course_data', jsonEncode(course.toJson())));
      if (photoFile != null) {
        formData.files.add(
          MapEntry(
            'course_photo',
            await MultipartFile.fromFile(
              photoFile.path,
              filename: photoFile.path.split('/').last,
            ),
          ),
        );
      } else if (photoBytes != null) {
        formData.files.add(
          MapEntry(
            'course_photo',
            MultipartFile.fromBytes(
              photoBytes,
              filename: (photoName ?? 'photo'),
            ),
          ),
        );
      }
      if (videoFile != null) {
        formData.files.add(
          MapEntry(
            'course_video',
            await MultipartFile.fromFile(
              videoFile.path,
              filename: videoFile.path.split('/').last,
            ),
          ),
        );
      } else if (videoBytes != null) {
        formData.files.add(
          MapEntry(
            'course_video',
            MultipartFile.fromBytes(
              videoBytes,
              filename: (videoName ?? 'video'),
            ),
          ),
        );
      }
      final response = await _dio.put(
        ApiUrl.updateCourse(courseId),
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      if (response.statusCode == 200) {
        return Course.fromJson(response.data);
      } else {
        throw Exception('Failed to update course: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error updating course: $e');
    }
  }

  /// Delete a course by course ID (new backend)
  static Future<void> deleteCourse(String courseId) async {
    try {
      await _dio.delete(ApiUrl.deleteCourse(courseId));
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error deleting course: $e');
    }
  }

  /// Bulk delete courses by course IDs (new backend)
  static Future<Map<String, dynamic>> bulkDeleteCourses(
    List<String> courseIds,
  ) async {
    try {
      final response = await _dio.delete(
        ApiUrl.bulkDeleteCourses,
        data: {'course_ids': courseIds},
      );
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Failed to bulk delete: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error bulk deleting courses: $e');
    }
  }
}
