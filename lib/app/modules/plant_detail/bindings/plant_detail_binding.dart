import 'package:get/get.dart';
import '../controllers/plant_detail_controller.dart';

class PlantDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlantDetailController>(() => PlantDetailController());
  }
}
