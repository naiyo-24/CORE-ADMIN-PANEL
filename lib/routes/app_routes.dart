import 'package:get/get.dart';
import '../bindings/auth_binding.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/auth/login_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  // Add more routes as needed
  // static const String dashboard = '/dashboard';

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
  ];
}
