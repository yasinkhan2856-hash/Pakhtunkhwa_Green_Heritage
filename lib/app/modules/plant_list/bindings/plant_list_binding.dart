import 'package:get/get.dart';
import '../controllers/plant_list_controller.dart';

class PlantListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlantListController>(() => PlantListController());
  }
}
