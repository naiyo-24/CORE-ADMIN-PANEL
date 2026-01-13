import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/counsellor_controller.dart';

class CounsellorBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure AuthController is available
    if (!Get.isRegistered<AuthController>()) {
      Get.put<AuthController>(AuthController(), permanent: true);
    }

    // Register CounsellorController with permanent flag
    Get.put<CounsellorController>(CounsellorController(), permanent: true);
  }
}
