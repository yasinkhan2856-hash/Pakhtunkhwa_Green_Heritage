import 'package:get/get.dart';
import '../controllers/medicinal_plants_controller.dart';

class MedicinalPlantsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MedicinalPlantsController>(() => MedicinalPlantsController());
  }
}
