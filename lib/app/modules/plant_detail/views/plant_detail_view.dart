import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_theme.dart';
import '../controllers/plant_detail_controller.dart';

class PlantDetailView extends StatefulWidget {
  const PlantDetailView({super.key});

  @override
  State<PlantDetailView> createState() => _PlantDetailViewState();
}

class _PlantDetailViewState extends State<PlantDetailView>
    with SingleTickerProviderStateMixin {
  late final PlantDetailController controller;
  late AnimationController _imageAnimationController;
  late Animation<double> _imageScaleAnimation;
  late Animation<double> _imageFadeAnimation;

  @override
  void initState() {
    super.initState();
    controller = Get.find<PlantDetailController>();
    _imageAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _imageScaleAnimation = Tween<double>(begin: 1.1, end: 1.0).animate(
      CurvedAnimation(
        parent: _imageAnimationController,
        curve: Curves.easeOutCubic,
      ),
    );
    _imageFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _imageAnimationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    _imageAnimationController.forward();
  }

  @override
  void dispose() {
    _imageAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundGreen,
      body: CustomScrollView(
        slivers: [
          // Hero Image App Bar
          SliverAppBar(
            expandedHeight: 300,
            floating: false,
            pinned: true,
            backgroundColor: AppTheme.primaryGreen,
            flexibleSpace: FlexibleSpaceBar(
              background: AnimatedBuilder(
                animation: _imageAnimationController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _imageFadeAnimation.value,
                    child: Transform.scale(
                      scale: _imageScaleAnimation.value,
                      child: child,
                    ),
                  );
                },
                child: Hero(
                  tag: 'plant_image_${controller.plant.id}',
                  child: Image.asset(
                    controller.plant.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppTheme.cardGreen,
                      child: const Center(
                        child: Icon(
                          Icons.local_florist,
                          size: 80,
                          color: AppTheme.primaryGreen,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
              onPressed: () => Get.back(),
            ),
          ),
          
          // Content with staggered animations
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Common Name with animation
                    _buildAnimatedSection(
                      delay: 0,
                      child: Text(
                        controller.plant.name,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkGreen,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Botanical Name with animation
                    _buildAnimatedSection(
                      delay: 1,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.backgroundGreen,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          controller.plant.botanicalName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: AppTheme.primaryGreen,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Info Cards Grid with animation
                    _buildAnimatedSection(
                      delay: 2,
                      child: _buildInfoGrid(),
                    ),
                    const SizedBox(height: 24),
                    
                    // Description Section with animation
                    _buildAnimatedSection(
                      delay: 3,
                      child: _buildSection(
                        'Description',
                        Icons.description,
                        controller.plant.description,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Habitat Section with animation
                    _buildAnimatedSection(
                      delay: 4,
                      child: _buildSection(
                        'Habitat',
                        Icons.location_on,
                        controller.plant.habitat,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Uses Section with animation
                    _buildAnimatedSection(
                      delay: 5,
                      child: _buildSection(
                        'Uses & Environmental Impact',
                        Icons.eco,
                        controller.plant.uses,
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedSection({required int delay, required Widget child}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + (delay * 100)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  Widget _buildInfoGrid() {
    return Row(
      children: [
        Expanded(
          child: _buildInfoCard(
            'Family',
            controller.plant.family,
            Icons.account_tree,
            const Color(0xFF81C784),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildInfoCard(
            'Category',
            controller.plant.category,
            Icons.category,
            const Color(0xFF64B5F6),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.2),
            color.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, String content) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.backgroundGreen,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: AppTheme.primaryGreen,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkGreen,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[700],
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
