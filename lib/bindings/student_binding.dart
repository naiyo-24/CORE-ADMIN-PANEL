import 'package:get/get.dart';
import '../controllers/student_controller.dart';
import '../controllers/auth_controller.dart';

class StudentBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure AuthController is available
    if (!Get.isRegistered<AuthController>()) {
      Get.put<AuthController>(AuthController(), permanent: true);
    }
    Get.put<StudentController>(StudentController(), permanent: true);
  }
}
