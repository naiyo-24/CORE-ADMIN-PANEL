import 'package:get/get.dart';
import '../controllers/teacher_controller.dart';
import '../controllers/auth_controller.dart';

class TeacherBinding extends Bindings {
  @override
  void dependencies() {
    // Register TeacherController with permanent: true
    Get.put<TeacherController>(TeacherController(), permanent: true);

    // Ensure AuthController is registered (fallback if not already)
    if (!Get.isRegistered<AuthController>()) {
      Get.put<AuthController>(AuthController(), permanent: true);
    }
  }
}
