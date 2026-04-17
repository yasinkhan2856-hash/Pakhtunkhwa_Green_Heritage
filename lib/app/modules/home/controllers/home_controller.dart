import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class HomeController extends GetxController with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  final RxInt selectedIndex = 0.obs;

  final List<Map<String, dynamic>> categories = [
    {
      'title': 'Native Flora',
      'description': 'Native plants of Pakhtunkhwa region',
      'icon': Icons.local_florist,
      'imageUrl': 'assets/images/categories/flora.jpg',
      'color': const Color(0xFF2E7D32),
      'route': AppRoutes.plantList,
      'category': 'flora_kpk',
    },
    {
      'title': 'Indigenous Trees',
      'description': 'Native trees of Pakhtunkhwa region',
      'icon': Icons.nature,
      'imageUrl': 'assets/images/categories/indigenous.jpg',
      'color': const Color(0xFF66BB6A),
      'route': AppRoutes.plantList,
      'category': 'indigenous',
    },
    {
      'title': 'Medicinal Plants',
      'description': 'Healing plants found in Pakhtunkhwa',
      'icon': Icons.healing,
      'imageUrl': 'assets/images/categories/medicinal.jpg',
      'color': const Color(0xFF8B6914),
      'route': AppRoutes.medicinalPlants,
      'category': null,
    },
    {
      'title': 'Agricultural Crops',
      'description': 'Annual crops grown in Pakhtunkhwa',
      'icon': Icons.spa,
      'imageUrl': 'assets/images/categories/annual.jpg',
      'color': const Color(0xFF43A047),
      'route': AppRoutes.plantList,
      'category': 'annual',
    },
    {
      'title': 'Common Weeds',
      'description': 'Weed species found in Pakhtunkhwa',
      'icon': Icons.grass,
      'imageUrl': 'assets/images/categories/weeds.jpg',
      'color': const Color(0xFF81C784),
      'route': AppRoutes.plantList,
      'category': 'weeds',
    },
    {
      'title': 'Invasive Species',
      'description': 'Invasive plants affecting Pakhtunkhwa',
      'icon': Icons.warning_amber,
      'imageUrl': 'assets/images/categories/invasive.jpg',
      'color': const Color(0xFFE53935),
      'route': AppRoutes.plantList,
      'category': 'invasive',
    },
    {
      'title': 'Plant Map',
      'description': 'Interactive map of Pakhtunkhwa flora',
      'icon': Icons.map,
      'imageUrl': 'assets/images/categories/map.jpg',
      'color': const Color(0xFF1B5E20),
      'route': AppRoutes.plantMap,
      'category': null,
    },
  ];

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    animationController.forward();
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }

  void navigateToCategory(Map<String, dynamic> category) {
    if (category['category'] != null) {
      Get.toNamed(
        category['route'],
        arguments: {
          'title': category['title'],
          'category': category['category'],
        },
      );
    } else {
      Get.toNamed(category['route']);
    }
  }
}
