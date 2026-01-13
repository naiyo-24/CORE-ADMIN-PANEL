class ApiUrl {
  // Base URL
  static const String baseUrl = 'http://localhost:8000';

  // Admin Auth endpoints
  static const String adminLogin = '/api/admin/login';

  // Course endpoints
  static const String coursesBase = '/api/courses';
  static const String createCourse = '/api/courses/create';
  static const String getAllCourses = '/api/courses/get-all';
  static String getCourseById(String courseId) =>
      '/api/courses/get-by/$courseId';
  static String updateCourse(String courseId) =>
      '/api/courses/put-by/$courseId';
  static String deleteCourse(String courseId) =>
      '/api/courses/delete-by/$courseId';
  static const String bulkDeleteCourses = '/api/courses/bulk/delete';
}
