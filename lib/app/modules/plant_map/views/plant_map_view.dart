import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../theme/app_theme.dart';
import '../controllers/plant_map_controller.dart';

class PlantMapView extends StatefulWidget {
  const PlantMapView({super.key});

  @override
  State<PlantMapView> createState() => _PlantMapViewState();
}

class _PlantMapViewState extends State<PlantMapView> {
  PlantMapController get controller => Get.find<PlantMapController>();
  static final GlobalKey _mapKey = GlobalKey();
  bool _isMapReady = false;

  @override
  void initState() {
    super.initState();
    // Longer delay to ensure proper cleanup of previous map instances
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isMapReady = true;
        });
      }
    });
  }
  
  @override
  void dispose() {
    // Ensure map resources are cleaned up
    _isMapReady = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Google Map - only builds once with GlobalKey and error handling
          if (_isMapReady)
            SizedBox.expand(
              child: RepaintBoundary(
                child: Builder(
                  builder: (context) {
                    try {
                      return GoogleMap(
                        key: _mapKey,
                        mapType: MapType.normal,
                        initialCameraPosition: controller.initialCameraPosition,
                        markers: controller.markers,
                        myLocationEnabled: false,
                        myLocationButtonEnabled: false,
                        mapToolbarEnabled: true,
                        zoomControlsEnabled: true,
                        onMapCreated: controller.onMapCreated,
                      );
                    } catch (e) {
                      return Container(
                        color: Colors.grey[200],
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.map_outlined,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Map failed to load',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Please check your internet connection',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            )
          else
            const Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryGreen,
              ),
            ),
          
          // UI Overlay - doesn't rebuild with map
          const _MapOverlay(),
        ],
      ),
    );
  }
}

// Separate widget for overlay UI to prevent rebuilding with map
class _MapOverlay extends StatelessWidget {
  const _MapOverlay();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Custom App Bar
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.backgroundGreen,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: AppTheme.primaryGreen,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Plant Map of Pakhtunkhwa',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.darkGreen,
                          ),
                        ),
                        Text(
                          'Tap markers to see plant details',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.map,
                      color: AppTheme.primaryGreen,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        
        // Legend
        Positioned(
          bottom: 100,
          left: 16,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Categories',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                _buildLegendItem('Weeds', Colors.yellow),
                _buildLegendItem('Indigenous', Colors.green),
                _buildLegendItem('Invasive', Colors.red),
                _buildLegendItem('Annual', Colors.blue),
                _buildLegendItem('Flora Pakhtunkhwa', Colors.purple),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }
}
