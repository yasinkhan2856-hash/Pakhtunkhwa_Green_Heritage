import 'package:get/get.dart';
import '../controllers/plant_map_controller.dart';

class PlantMapBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlantMapController>(() => PlantMapController());
  }
}
