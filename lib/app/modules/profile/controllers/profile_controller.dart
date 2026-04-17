import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../auth/controllers/auth_controller.dart';

class ProfileController extends GetxController {
  final AuthController authController = Get.find<AuthController>();

  final plantsExplored = 12.obs;
  final favoritesCount = 5.obs;

  String get userName => authController.userName.value.isNotEmpty 
      ? authController.userName.value 
      : 'New User';
  
  String get userEmail => authController.userEmail.value.isNotEmpty 
      ? authController.userEmail.value 
      : 'guest@example.com';
  
  bool get isGuest => authController.isGuest.value;

  final menuItems = [
    {
      'icon': Icons.help_outline,
      'title': 'Help & Support',
      'subtitle': 'Get help and contact us',
      'route': '/help-support',
    },
    {
      'icon': Icons.feedback_outlined,
      'title': 'Send Feedback',
      'subtitle': 'Share your suggestions',
      'route': '/help-support',
    },
    {
      'icon': Icons.settings_outlined,
      'title': 'Settings',
      'subtitle': 'App preferences',
      'route': null,
    },
    {
      'icon': Icons.info_outline,
      'title': 'About',
      'subtitle': 'App version and info',
      'route': null,
    },
  ].obs;

  void logout() {
    authController.logout();
  }
}
