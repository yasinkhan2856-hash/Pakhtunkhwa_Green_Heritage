import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waleed/app/routes/app_routes.dart';
import 'package:waleed/app/modules/auth/controllers/auth_controller.dart';

class GuestLoginButton extends StatelessWidget {
  const GuestLoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Obx(() {
      if (!authController.isGuest.value) {
        return const SizedBox.shrink();
      }

      return Positioned(
        top: MediaQuery.of(context).padding.top + 8,
        right: 16,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          child: ElevatedButton.icon(
            onPressed: () => Get.toNamed(AppRoutes.auth),
            icon: const Icon(Icons.login, size: 16),
            label: const Text(
              'Login',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 4,
              shadowColor: Colors.black26,
            ),
          ),
        ),
      );
    });
  }
}
