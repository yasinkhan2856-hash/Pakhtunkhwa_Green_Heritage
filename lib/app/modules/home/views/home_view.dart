import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../../widgets/guest_login_button.dart';


class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: CustomScrollView(
            slivers: [
              // Header Section
              SliverToBoxAdapter(
                child: _buildHeader(),
              ),
              
              // Category Grid - Responsive based on screen width
              SliverToBoxAdapter(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final screenWidth = constraints.maxWidth;
                    // Use horizontal scroll for small screens, grid for larger
                    if (screenWidth < 360) {
                      // Very small screens - horizontal scrolling cards
                      return SizedBox(
                        height: 180,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          itemCount: controller.categories.length,
                          itemBuilder: (context, index) {
                            return SizedBox(
                              width: 140,
                              child: _buildCategoryCard(
                                controller.categories[index],
                                index,
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      // Larger screens - responsive grid
                      final crossAxisCount = screenWidth > 600 ? 3 : 2;
                      final childAspectRatio = screenWidth > 480 ? 1.0 : 0.85;
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(12),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: childAspectRatio,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: controller.categories.length,
                        itemBuilder: (context, index) {
                          return _buildCategoryCard(
                            controller.categories[index],
                            index,
                          );
                        },
                      );
                    }
                  },
                ),
              ),
          
          // Bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: 24),
          ),
        ],
      ),
    ),
    const GuestLoginButton(),
      ],
    );
  }

  Widget _buildHeader() {
    final authController = Get.find<AuthController>();
    
    return Container(
      height: 220,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2E7D32),
            Color(0xFF1B5E20),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Stack(
        children: [
          // Background pattern
          Positioned(
            right: -30,
            top: -30,
            child: Icon(
              Icons.eco,
              size: 180,
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          Positioned(
            left: -40,
            bottom: 40,
            child: Icon(
              Icons.local_florist,
              size: 120,
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          
          // Conte still nt
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // User Info Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Welcome Text
                      Expanded(
                        child: Obx(() => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome,',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withAlpha(204),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              authController.userName.value.isEmpty 
                                  ? 'Guest' 
                                  : authController.userName.value,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        )),
                      ),
                      
                      // Logout Button
                      Obx(() => authController.isGuest.value 
                          ? const SizedBox.shrink()
                          : IconButton(
                              onPressed: () => _showLogoutDialog(authController),
                              icon: const Icon(
                                Icons.logout,
                                color: Colors.white,
                              ),
                            )),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Simple description
                  Text(
                    'Explore Pakhtunkhwa Flora',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withAlpha(217),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(AuthController authController) {
    Get.dialog(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              authController.logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category, int index) {
    return AnimatedBuilder(
      animation: controller.animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: Tween<double>(begin: 0, end: 1).animate(
            CurvedAnimation(
              parent: controller.animationController,
              curve: Interval(
                index * 0.1,
                1.0,
                curve: Curves.easeOut,
              ),
            ),
          ),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.3),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: controller.animationController,
                curve: Interval(
                  index * 0.1,
                  1.0,
                  curve: Curves.easeOut,
                ),
              ),
            ),
            child: _CategoryCard(
              category: category,
              onTap: () => controller.navigateToCategory(category),
              index: index,
            ),
          ),
        );
      },
    );
  }
}

class _CategoryCard extends StatefulWidget {
  final Map<String, dynamic> category;
  final VoidCallback onTap;
  final int index;

  const _CategoryCard({
    required this.category,
    required this.onTap,
    required this.index,
  });

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard> with TickerProviderStateMixin {
  late AnimationController _pressController;
  late AnimationController _entryController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _bounceAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.94).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeInOutCubic),
    );
    _bounceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutBack),
      ),
    );
    
    // Start entry animation with delay
    Future.delayed(Duration(milliseconds: widget.index * 120), () {
      if (mounted) {
        _entryController.forward();
      }
    });
  }

  @override
  void dispose() {
    _pressController.dispose();
    _entryController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _pressController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _pressController.reverse();
    widget.onTap();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _pressController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardHeight = constraints.maxHeight;
        final cardWidth = constraints.maxWidth;
        final isSmallCard = cardHeight < 160 || cardWidth < 140;
        
        return AnimatedBuilder(
          animation: Listenable.merge([_scaleAnimation, _bounceAnimation]),
          builder: (context, child) {
            final entryScale = 0.8 + (0.2 * _bounceAnimation.value);
            final pressScale = _scaleAnimation.value;
            return Transform.scale(
              scale: entryScale * pressScale,
              child: Opacity(
                opacity: _bounceAnimation.value.clamp(0.0, 1.0),
                child: child,
              ),
            );
          },
          child: Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTapDown: _onTapDown,
              onTapUp: _onTapUp,
              onTapCancel: _onTapCancel,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: (widget.category['color'] as Color).withValues(
                        alpha: _isPressed ? 0.5 : 0.25,
                      ),
                      blurRadius: _isPressed ? 28 : 16,
                      offset: _isPressed ? const Offset(0, 12) : const Offset(0, 8),
                      spreadRadius: _isPressed ? 3 : 0,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image Section - Adaptive flex based on card size
                      Expanded(
                        flex: isSmallCard ? 2 : 3,
                        child: Container(
                          margin: EdgeInsets.all(isSmallCard ? 6 : 8),
                          decoration: BoxDecoration(
                            color: (widget.category['color'] as Color).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: AnimatedBuilder(
                              animation: _bounceAnimation,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: 0.85 + (0.15 * _bounceAnimation.value),
                                  child: Opacity(
                                    opacity: _bounceAnimation.value.clamp(0.0, 1.0),
                                    child: child,
                                  ),
                                );
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                transform: _isPressed
                                    ? (Matrix4.identity()..scale(0.96))
                                    : Matrix4.identity(),
                                child: widget.category['imageUrl'] != null
                                    ? Image.asset(
                                        widget.category['imageUrl'] as String,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Center(
                                            child: Icon(
                                              widget.category['icon'] as IconData,
                                              size: isSmallCard ? 40 : 56,
                                              color: widget.category['color'] as Color,
                                            ),
                                          );
                                        },
                                      )
                                    : Center(
                                        child: Icon(
                                          widget.category['icon'] as IconData,
                                          size: isSmallCard ? 40 : 56,
                                          color: widget.category['color'] as Color,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Text Section - Adaptive padding and text size
                      Expanded(
                        flex: isSmallCard ? 1 : 2,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isSmallCard ? 8 : 12, 
                            vertical: isSmallCard ? 4 : 8,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.category['title'] as String,
                                style: TextStyle(
                                  fontSize: isSmallCard ? 12 : 14,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF1B5E20),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: isSmallCard ? 2 : 4),
                              Text(
                                widget.category['description'] as String,
                                style: TextStyle(
                                  fontSize: isSmallCard ? 9 : 11,
                                  color: Colors.grey[600],
                                  height: 1.2,
                                ),
                                maxLines: isSmallCard ? 1 : 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
