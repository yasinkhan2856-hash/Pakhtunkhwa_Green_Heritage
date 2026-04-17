import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../home/controllers/home_controller.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/guest_login_button.dart';

class CategoryView extends StatelessWidget {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();

    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppTheme.backgroundGreen,
          appBar: AppBar(
            backgroundColor: AppTheme.primaryGreen,
            elevation: 0,
            title: const Text(
              'Categories',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Get.back(),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: homeController.categories.length,
                itemBuilder: (context, index) {
                  final category = homeController.categories[index];
                  return _buildCategoryCard(category, index);
                },
              ),
            ),
          ),
        ),
        const GuestLoginButton(),
      ],
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category, int index) {
    return GestureDetector(
      onTap: () {
        if (category['route'] != null) {
          if (category['category'] != null) {
            Get.toNamed(
              category['route'],
              arguments: {'category': category['category']},
            );
          } else {
            Get.toNamed(category['route']);
          }
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: (category['color'] as Color).withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: (category['color'] as Color).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                category['icon'] as IconData,
                size: 40,
                color: category['color'] as Color,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              category['title'] as String,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B5E20),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              category['description'] as String,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
