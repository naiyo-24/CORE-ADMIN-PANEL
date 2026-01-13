import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/course_controller.dart';

class CourseBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AuthController>()) {
      Get.put<AuthController>(AuthController(), permanent: true);
    }

    Get.put<CourseController>(CourseController(), permanent: true);
  }
}
