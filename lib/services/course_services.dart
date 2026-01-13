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

  /// Get all courses
  /// Backend stores general and executive as separate records with same course_code
  /// This method aggregates them into single Course objects
  static Future<List<Course>> getAllCourses({
    int skip = 0,
    int limit = 100,
    String? category,
    bool? activeOnly,
  }) async {
    try {
      final queryParams = <String, dynamic>{'skip': skip, 'limit': limit};
      if (category != null) queryParams['category'] = category;
      if (activeOnly != null) queryParams['active_only'] = activeOnly;

      final response = await _dio.get(
        ApiUrl.getAllCourses,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final List<dynamic> coursesData = response.data;

        // Group courses by course_code
        final Map<String, Map<String, dynamic>> courseMap = {};

        for (var courseData in coursesData) {
          final courseCode = courseData['course_code'] as String;
          final category = courseData['course_category'] as String;

          if (!courseMap.containsKey(courseCode)) {
            courseMap[courseCode] = {
              'base': courseData,
              'general': null,
              'executive': null,
            };
          }

          if (category == 'general') {
            courseMap[courseCode]!['general'] = courseData;
          } else if (category == 'executive') {
            courseMap[courseCode]!['executive'] = courseData;
          }
        }

        // Convert to Course objects
        final courses = <Course>[];
        for (var entry in courseMap.values) {
          final generalData = entry['general'] as Map<String, dynamic>?;
          final executiveData = entry['executive'] as Map<String, dynamic>?;

          // Skip if both categories are missing
          if (generalData == null && executiveData == null) continue;

          // Create CourseCategory objects
          final generalCategory = generalData != null
              ? CourseCategory.fromJson(generalData['category_data'])
              : _createDefaultCategory();

          final executiveCategory = executiveData != null
              ? CourseCategory.fromJson(executiveData['category_data'])
              : _createDefaultCategory();

          // Use the first available data for base fields
          final primaryData = generalData ?? executiveData!;

          courses.add(
            Course(
              id: primaryData['course_id'],
              name: primaryData['course_name'],
              description: primaryData['course_description'] ?? '',
              code: primaryData['course_code'],
              weightRequirements: primaryData['weight_requirements'] ?? '',
              heightRequirements: primaryData['height_requirements'] ?? '',
              visionStandards: primaryData['vision_standards'] ?? '',
              medicalRequirements: primaryData['medical_requirements'] ?? '',
              minEducationalQualification:
                  primaryData['min_educational_qualification'] ?? '',
              ageCriteria: primaryData['age_criteria'] ?? '',
              internshipIncluded: primaryData['internship_included'] ?? false,
              installmentAvailable:
                  primaryData['installment_available'] ?? false,
              installmentPolicy: primaryData['installment_policy'] ?? '',
              photoUrl: primaryData['course_photo'],
              videoUrl: primaryData['course_video'],
              generalCategory: generalCategory,
              executiveCategory: executiveCategory,
            ),
          );
        }

        return courses;
      } else {
        throw Exception('Failed to load courses: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error fetching courses: $e');
    }
  }

  /// Get course by ID
  static Future<Course?> getCourseById(String courseId) async {
    try {
      final response = await _dio.get(ApiUrl.getCourseById(courseId));

      if (response.statusCode == 200) {
        final courseData = response.data as Map<String, dynamic>;

        // Need to fetch the other category to build complete Course object
        final courseCode = courseData['course_code'] as String;

        // Fetch all courses with this code
        final allCourses = await getAllCourses();
        return allCourses.firstWhere(
          (c) => c.code == courseCode,
          orElse: () => throw Exception('Course not found'),
        );
      } else {
        return null;
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error fetching course: $e');
    }
  }

  /// Create a new course
  /// Backend requires separate records for general and executive categories
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
      // Create general category record
      await _createCourseRecord(
        course,
        'general',
        course.generalCategory,
        photoFile,
        videoFile,
        photoBytes,
        photoName,
        videoBytes,
        videoName,
      );

      // Create executive category record
      await _createCourseRecord(
        course,
        'executive',
        course.executiveCategory,
        photoFile,
        videoFile,
        photoBytes,
        photoName,
        videoBytes,
        videoName,
      );

      return course;
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error creating course: $e');
    }
  }

  /// Helper method to create a single course record for one category
  static Future<void> _createCourseRecord(
    Course course,
    String category,
    CourseCategory categoryData,
    File? photoFile,
    File? videoFile,
    Uint8List? photoBytes,
    String? photoName,
    Uint8List? videoBytes,
    String? videoName,
  ) async {
    final formData = FormData();

    // Prepare course data JSON
    final courseDataJson = {
      'course_name': course.name,
      'course_description': course.description,
      'course_code': course.code,
      'weight_requirements': course.weightRequirements,
      'height_requirements': course.heightRequirements,
      'vision_standards': course.visionStandards,
      'medical_requirements': course.medicalRequirements,
      'min_educational_qualification': course.minEducationalQualification,
      'age_criteria': course.ageCriteria,
      'internship_included': course.internshipIncluded,
      'installment_available': course.installmentAvailable,
      'installment_policy': course.installmentPolicy,
      'course_category': category,
      'category_data': categoryData.toJson(),
    };

    formData.fields.add(MapEntry('course_data', jsonEncode(courseDataJson)));

    // Add files if provided
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
          MultipartFile.fromBytes(photoBytes, filename: (photoName ?? 'photo')),
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
          MultipartFile.fromBytes(videoBytes, filename: (videoName ?? 'video')),
        ),
      );
    }

    final response = await _dio.post(
      ApiUrl.createCourse,
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create course: ${response.statusCode}');
    }
  }

  /// Update an existing course
  /// Updates both general and executive records
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
      // Get all course records for this code
      final allCoursesResp = await _dio.get(ApiUrl.getAllCourses);
      final coursesData = allCoursesResp.data as List<dynamic>;

      // Find both general and executive records for this course code
      Map<String, dynamic>? generalData;
      Map<String, dynamic>? executiveData;
      for (var courseData in coursesData) {
        if (courseData['course_code'] == course.code) {
          if (courseData['course_category'] == 'general') {
            generalData = courseData as Map<String, dynamic>;
          } else if (courseData['course_category'] == 'executive') {
            executiveData = courseData as Map<String, dynamic>;
          }
        }
      }

      // Update general record if exists
      if (generalData != null) {
        await _updateCourseRecord(
          generalData['course_id'],
          course,
          'general',
          course.generalCategory,
          photoFile,
          videoFile,
          photoBytes,
          photoName,
          videoBytes,
          videoName,
        );
      }

      // Update executive record if exists
      if (executiveData != null) {
        await _updateCourseRecord(
          executiveData['course_id'],
          course,
          'executive',
          course.executiveCategory,
          photoFile,
          videoFile,
          photoBytes,
          photoName,
          videoBytes,
          videoName,
        );
      }

      // If a record is missing, create it
      if (generalData == null) {
        await _createCourseRecord(
          course,
          'general',
          course.generalCategory,
          photoFile,
          videoFile,
          photoBytes,
          photoName,
          videoBytes,
          videoName,
        );
      }
      if (executiveData == null) {
        await _createCourseRecord(
          course,
          'executive',
          course.executiveCategory,
          photoFile,
          videoFile,
          photoBytes,
          photoName,
          videoBytes,
          videoName,
        );
      }

      return course;
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error updating course: $e');
    }
  }

  /// Helper method to update a single course record
  static Future<void> _updateCourseRecord(
    String courseId,
    Course course,
    String category,
    CourseCategory categoryData,
    File? photoFile,
    File? videoFile,
    Uint8List? photoBytes,
    String? photoName,
    Uint8List? videoBytes,
    String? videoName,
  ) async {
    final formData = FormData();

    // Prepare update data JSON
    final updateDataJson = {
      'course_name': course.name,
      'course_description': course.description,
      'course_code': course.code,
      'weight_requirements': course.weightRequirements,
      'height_requirements': course.heightRequirements,
      'vision_standards': course.visionStandards,
      'medical_requirements': course.medicalRequirements,
      'min_educational_qualification': course.minEducationalQualification,
      'age_criteria': course.ageCriteria,
      'internship_included': course.internshipIncluded,
      'installment_available': course.installmentAvailable,
      'installment_policy': course.installmentPolicy,
      'course_category': category,
      'category_data': categoryData.toJson(),
    };

    formData.fields.add(MapEntry('course_data', jsonEncode(updateDataJson)));

    // Add files if provided
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
          MultipartFile.fromBytes(photoBytes, filename: (photoName ?? 'photo')),
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
          MultipartFile.fromBytes(videoBytes, filename: (videoName ?? 'video')),
        ),
      );
    }

    final response = await _dio.put(
      ApiUrl.updateCourse(courseId),
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update course: ${response.statusCode}');
    }
  }

  /// Delete a course by course code
  /// Deletes both general and executive records
  static Future<void> deleteCourse(String courseCode) async {
    try {
      // Get all course records with this code
      final allCourses = await _dio.get(ApiUrl.getAllCourses);
      final coursesData = allCourses.data as List<dynamic>;

      final courseIdsToDelete = <String>[];

      for (var courseData in coursesData) {
        if (courseData['course_code'] == courseCode) {
          courseIdsToDelete.add(courseData['course_id']);
        }
      }

      // Delete all matching records
      for (var id in courseIdsToDelete) {
        await _dio.delete(ApiUrl.deleteCourse(id));
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error deleting course: $e');
    }
  }

  /// Bulk delete courses by course codes
  static Future<Map<String, dynamic>> bulkDeleteCourses(
    List<String> courseCodes,
  ) async {
    try {
      // Get all course records
      final allCourses = await _dio.get(ApiUrl.getAllCourses);
      final coursesData = allCourses.data as List<dynamic>;

      final courseIdsToDelete = <String>[];

      // Find all course IDs matching the codes
      for (var courseData in coursesData) {
        if (courseCodes.contains(courseData['course_code'])) {
          courseIdsToDelete.add(courseData['course_id']);
        }
      }

      if (courseIdsToDelete.isEmpty) {
        return {
          'message': 'No courses found to delete',
          'deleted_count': 0,
          'not_found': courseCodes,
        };
      }

      // Use bulk delete endpoint
      final response = await _dio.delete(
        ApiUrl.bulkDeleteCourses,
        data: {'course_ids': courseIdsToDelete},
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

  /// Create a default category when one is missing
  static CourseCategory _createDefaultCategory() {
    return CourseCategory(
      jobRolesOffered: 'Not specified',
      placementAssistance: false,
      placementType: 'Not specified',
      placementRate: 0.0,
      advantagesHighlights: 'Not specified',
      courseFees: 0.0,
    );
  }
}
