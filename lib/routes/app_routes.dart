import 'package:get/get.dart';
import '../bindings/auth_binding.dart';
import '../bindings/dashboard_binding.dart';
import '../bindings/student_binding.dart';
import '../bindings/teacher_binding.dart';
import '../bindings/counsellor_binding.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/dashboard/dashboard_page.dart';
import '../screens/students/students_screen.dart';
import '../screens/teachers/teachers_screen.dart';
import '../screens/counsellors/counsellor_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String students = '/students';
  static const String teachers = '/teachers';
  static const String counsellors = '/counsellors';

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
      transition: Transition.leftToRight,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: students,
      page: () => const StudentsScreen(),
      binding: StudentBinding(),
      transition: Transition.leftToRight,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: teachers,
      page: () => const TeachersScreen(),
      binding: TeacherBinding(),
      transition: Transition.leftToRight,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: counsellors,
      page: () => const CounsellorScreen(),
      binding: CounsellorBinding(),
      transition: Transition.leftToRight,
      transitionDuration: const Duration(milliseconds: 300),
    ),
  ];
}
