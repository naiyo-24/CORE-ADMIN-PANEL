import 'package:get/get.dart';
import '../bindings/auth_binding.dart';
import '../bindings/dashboard_binding.dart';
import '../bindings/student_binding.dart';
import '../bindings/teacher_binding.dart';
import '../bindings/counsellor_binding.dart';
import '../bindings/course_binding.dart';
import '../bindings/classroom_binding.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/dashboard/dashboard_page.dart';
import '../screens/students/students_screen.dart';
import '../screens/teachers/teachers_screen.dart';
import '../screens/counsellors/counsellor_screen.dart';
import '../screens/courses/course_screen.dart';
import '../screens/classrooms/classroom_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String students = '/students';
  static const String teachers = '/teachers';
  static const String counsellors = '/counsellors';
  static const String courses = '/courses';
  static const String classrooms = '/classrooms';

  static List<GetPage> routes = [
    GetPage(
      name: splash,
      page: () => const SplashScreen(),
      binding: AuthBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: login,
      page: () => const LoginScreen(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: dashboard,
      page: () => const DashboardPage(),
      binding: DashboardBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: students,
      page: () => const StudentsScreen(),
      binding: StudentBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: teachers,
      page: () => const TeachersScreen(),
      binding: TeacherBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: counsellors,
      page: () => const CounsellorScreen(),
      binding: CounsellorBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: courses,
      page: () => const CourseScreen(),
      binding: CourseBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: classrooms,
      page: () => const ClassroomScreen(),
      binding: ClassroomBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
  ];
}
