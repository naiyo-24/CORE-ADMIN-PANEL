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

  // Teacher endpoints
  static const String teachersBase = '/api/teachers';
  static const String createTeacher = '/api/teachers/create';
  static const String getAllTeachers = '/api/teachers/get-all';
  static String getTeacherById(String teacherId) =>
      '/api/teachers/get-by/$teacherId';
  static String updateTeacher(String teacherId) =>
      '/api/teachers/put-by/$teacherId';
  static String deleteTeacher(String teacherId) =>
      '/api/teachers/delete-by/$teacherId';
  static const String bulkDeleteTeachers = '/api/teachers/bulk-delete';

  // Student endpoints
  static const String studentsBase = '/api/students';
  static const String createStudent = '/api/students/create';
  static const String getAllStudents = '/api/students/get-all';
  static String getStudentById(String studentId) =>
      '/api/students/get-by/$studentId';
  static String updateStudent(String studentId) =>
      '/api/students/put-by/$studentId';
  static String deleteStudent(String studentId) =>
      '/api/students/delete-by/$studentId';
  static const String bulkDeleteStudents = '/api/students/bulk/delete';

  // Counsellor endpoints
  static const String counsellorsBase = '/api/counsellors';
  static const String createCounsellor = '/api/counsellors/create';
  static const String getAllCounsellors = '/api/counsellors/get-all';
  static String getCounsellorById(String counsellorId) =>
      '/api/counsellors/get-by/$counsellorId';
  static String updateCounsellor(String counsellorId) =>
      '/api/counsellors/put-by/$counsellorId';
  static String deleteCounsellor(String counsellorId) =>
      '/api/counsellors/delete-by/$counsellorId';
  static const String bulkDeleteCounsellors = '/api/counsellors/bulk-delete';
}
