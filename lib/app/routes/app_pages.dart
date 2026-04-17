import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Main Layout
import '../modules/main_layout_binding.dart';

// Splash Module
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

// Auth Module
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/auth_view.dart';

// Home Module

// Plant List Module
import '../modules/plant_list/bindings/plant_list_binding.dart';
import '../modules/plant_list/views/plant_list_view.dart';

// Plant Detail Module
import '../modules/plant_detail/bindings/plant_detail_binding.dart';
import '../modules/plant_detail/views/plant_detail_view.dart';

// Plant Map Module
import '../modules/plant_map/bindings/plant_map_binding.dart';
import '../modules/plant_map/views/plant_map_view.dart';

// Medicinal Plants Module
import '../modules/medicinal_plants/bindings/medicinal_plants_binding.dart';
import '../modules/medicinal_plants/views/medicinal_plants_view.dart';

// Search Module
import '../modules/search/bindings/search_binding.dart';
import '../modules/search/views/search_view.dart';

// Profile Module
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';

// Help & Support Module
import '../modules/help_support/bindings/help_support_binding.dart';
import '../modules/help_support/views/help_support_view.dart';

// Main Layout
import '../modules/main_layout.dart';

abstract class AppRoutes {
  static const String splash = '/';
  static const String auth = '/auth';
  static const String home = '/home';
  static const String category = '/category';
  static const String plantList = '/plant-list';
  static const String plantDetail = '/plant-detail';
  static const String plantMap = '/plant-map';
  static const String medicinalPlants = '/medicinal-plants';
  static const String search = '/search';
  static const String profile = '/profile';
  static const String helpSupport = '/help-support';
}

class AppPages {
  static const String initial = AppRoutes.splash;

  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    ),
    GetPage(
      name: AppRoutes.auth,
      page: () => const AuthView(),
      binding: AuthBinding(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const MainLayout(),
      binding: MainLayoutBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    ),
    GetPage(
      name: AppRoutes.plantList,
      page: () => const PlantListView(),
      binding: PlantListBinding(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
    ),
    GetPage(
      name: AppRoutes.plantDetail,
      page: () => const PlantDetailView(),
      binding: PlantDetailBinding(),
      transition: Transition.cupertinoDialog,
      transitionDuration: const Duration(milliseconds: 400),
      curve: Curves.easeOutQuart,
    ),
    GetPage(
      name: AppRoutes.plantMap,
      page: () => const PlantMapView(),
      binding: PlantMapBinding(),
      transition: Transition.zoom,
      transitionDuration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    ),
    GetPage(
      name: AppRoutes.medicinalPlants,
      page: () => const MedicinalPlantsView(),
      binding: MedicinalPlantsBinding(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
    ),
    GetPage(
      name: AppRoutes.search,
      page: () => const SearchView(),
      binding: SearchBinding(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
    ),
    GetPage(
      name: AppRoutes.helpSupport,
      page: () => const HelpSupportView(),
      binding: HelpSupportBinding(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
    ),
  ];
}
