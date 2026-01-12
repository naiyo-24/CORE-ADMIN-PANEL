import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import '../controllers/auth_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure AuthController is available
    if (!Get.isRegistered<AuthController>()) {
      Get.put<AuthController>(AuthController(), permanent: true);
    }
    Get.put<DashboardController>(DashboardController(), permanent: true);
  }
}
