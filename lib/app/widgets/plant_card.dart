import 'package:flutter/material.dart';
import '../data/models/plant_model.dart';
import '../theme/app_theme.dart';

class PlantCard extends StatefulWidget {
  final Plant plant;
  final VoidCallback onTap;
  final int index;

  const PlantCard({
    super.key,
    required this.plant,
    required this.onTap,
    required this.index,
  });

  @override
  State<PlantCard> createState() => _PlantCardState();
}

class _PlantCardState extends State<PlantCard> with TickerProviderStateMixin {
  late AnimationController _pressController;
  late AnimationController _bounceController;
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
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeInOutCubic),
    );
    _bounceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _bounceController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutBack),
      ),
    );
    
    // Start entry animation with delay based on index
    Future.delayed(Duration(milliseconds: widget.index * 100), () {
      if (mounted) {
        _bounceController.forward();
      }
    });
  }

  @override
  void dispose() {
    _pressController.dispose();
    _bounceController.dispose();
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
    return AnimatedBuilder(
      animation: Listenable.merge([_scaleAnimation, _bounceAnimation]),
      builder: (context, child) {
        final entryScale = 0.85 + (0.15 * _bounceAnimation.value);
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
          onTap: widget.onTap,
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: _isPressed
                      ? AppTheme.primaryGreen.withOpacity(0.3)
                      : AppTheme.primaryGreen.withOpacity(0.15),
                  blurRadius: _isPressed ? 24 : 14,
                  offset: _isPressed ? const Offset(0, 10) : const Offset(0, 6),
                  spreadRadius: _isPressed ? 2 : 0,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Image with Hero animation and scale effect
                    Hero(
                      tag: 'plant_image_${widget.plant.id}',
                      child: AnimatedBuilder(
                        animation: _bounceAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: 0.9 + (0.1 * _bounceAnimation.value),
                            child: Opacity(
                              opacity: _bounceAnimation.value.clamp(0.0, 1.0),
                              child: child,
                            ),
                          );
                        },
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: AppTheme.cardGreen,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              widget.plant.image,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => const Icon(
                                Icons.local_florist,
                                color: AppTheme.primaryGreen,
                                size: 40,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    // Content
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.plant.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.darkGreen,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.plant.botanicalName,
                              style: TextStyle(
                                fontSize: 13,
                                fontStyle: FontStyle.italic,
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _getCategoryColor(widget.plant.category).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                widget.plant.family,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: _getCategoryColor(widget.plant.category),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 14,
                                  color: Colors.grey[500],
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    widget.plant.habitat,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Arrow with enhanced animation
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.all(16),
                      child: AnimatedRotation(
                        turns: _isPressed ? 0.25 : 0,
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOutBack,
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: _isPressed
                              ? AppTheme.primaryGreen
                              : AppTheme.primaryGreen.withOpacity(0.5),
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'weeds':
        return const Color(0xFFFFA726);
      case 'indigenous':
        return const Color(0xFF66BB6A);
      case 'invasive':
        return const Color(0xFFEF5350);
      case 'annual':
        return const Color(0xFF42A5F5);
      case 'flora_kpk':
        return const Color(0xFFAB47BC);
      default:
        return AppTheme.primaryGreen;
    }
  }
}
