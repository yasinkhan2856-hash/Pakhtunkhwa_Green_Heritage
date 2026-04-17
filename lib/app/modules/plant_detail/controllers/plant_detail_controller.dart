import 'package:get/get.dart';
import '../../../data/models/plant_model.dart';

class PlantDetailController extends GetxController {
  late final Plant plant;
  final RxInt currentImageIndex = 0.obs;
  final RxBool isExpanded = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Handle both Map and direct Plant object
    final args = Get.arguments;
    if (args is Map<String, dynamic> && args.containsKey('plant')) {
      plant = args['plant'] as Plant;
    } else if (args is Plant) {
      plant = args;
    } else {
      throw Exception('Invalid arguments: expected Plant or Map with plant key');
    }
  }

  void toggleExpanded() {
    isExpanded.value = !isExpanded.value;
  }
}
