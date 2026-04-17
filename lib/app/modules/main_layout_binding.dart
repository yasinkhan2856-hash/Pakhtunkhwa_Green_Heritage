import 'package:get/get.dart';
import 'home/controllers/home_controller.dart';
import 'search/controllers/search_controller.dart';
import 'profile/controllers/profile_controller.dart';
import 'auth/controllers/auth_controller.dart';

class MainLayoutBinding extends Bindings {
  @override
  void dependencies() {
    // AuthController must be registered first as other controllers depend on it
    Get.put<AuthController>(AuthController(), permanent: true);
    Get.put<HomeController>(HomeController(), permanent: true);
    Get.put<SearchController>(SearchController(), permanent: true);
    Get.put<ProfileController>(ProfileController(), permanent: true);
  }
}
