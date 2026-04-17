import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../data/models/plant_model.dart';
import '../../../data/services/firebase_service.dart';

class PlantMapController extends GetxController {
  final RxSet<Marker> markers = <Marker>{}.obs;
  final RxBool isLoading = true.obs;
  final RxList<Plant> allPlants = RxList<Plant>([]);
  
  // Stream subscription for real-time updates
  StreamSubscription<List<Plant>>? _plantsSubscription;
  
  // Google Map Controller
  GoogleMapController? mapController;
  final Completer<GoogleMapController> _mapControllerCompleter = Completer<GoogleMapController>();

  // Pakhtunkhwa center coordinates - Peshawar area
  final LatLng kpkCenter = const LatLng(31.5, 71.5);
  final CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(31.5, 71.5),
    zoom: 7.5,
  );

  @override
  void onInit() {
    super.onInit();
    _subscribeToPlantsStream();
  }
  
  @override
  void onClose() {
    // Cancel stream subscription
    _plantsSubscription?.cancel();
    // Dispose of the map controller to prevent memory leaks
    _disposeMapController();
    super.onClose();
  }
  
  void _disposeMapController() async {
    if (!_mapControllerCompleter.isCompleted) {
      return;
    }
    final controller = await _mapControllerCompleter.future;
    controller.dispose();
    mapController = null;
  }
  
  void onMapCreated(GoogleMapController controller) {
    if (!_mapControllerCompleter.isCompleted) {
      _mapControllerCompleter.complete(controller);
      mapController = controller;
    }
  }

  void _subscribeToPlantsStream() {
    isLoading.value = true;
    
    _plantsSubscription = FirebaseService.streamAllPlants().listen(
      (plants) {
        if (plants.isEmpty) {
          // Use sample data if Firestore is empty
          allPlants.value = getSamplePlantsWithLocations();
        } else {
          allPlants.value = plants;
        }
        _createMarkers();
        isLoading.value = false;
      },
      onError: (error) {
        debugPrint('Error in plants stream: $error');
        allPlants.value = getSamplePlantsWithLocations();
        _createMarkers();
        isLoading.value = false;
      },
    );
  }

  List<Plant> getSamplePlantsWithLocations() {
    return [
      Plant(
        id: '1',
        name: 'Parthenium hysterophorus',
        botanicalName: 'Parthenium hysterophorus',
        family: 'Asteraceae',
        habitat: 'Wastelands, roadsides',
        description: 'Invasive weed found throughout Pakhtunkhwa.',
        uses: 'None - harmful',
        image: 'assets/images/plants/parthenium.jpg',
        category: 'weeds',
        latitude: 34.0151,
        longitude: 71.5249,
      ),
      Plant(
        id: '2',
        name: 'Pinus roxburghii',
        botanicalName: 'Pinus roxburghii',
        family: 'Pinaceae',
        habitat: 'Himalayan foothills',
        description: 'Chir pine, common in Pakhtunkhwa hills.',
        uses: 'Timber, resin',
        image: 'assets/images/plants/pinus.jpg',
        category: 'indigenous',
        latitude: 34.7692,
        longitude: 72.3615,
      ),
      Plant(
        id: '3',
        name: 'Taxus baccata',
        botanicalName: 'Taxus baccata',
        family: 'Taxaceae',
        habitat: 'Himalayan highlands',
        description: 'Himalayan yew, found in high altitude Pakhtunkhwa.',
        uses: 'Medicinal',
        image: 'assets/images/plants/taxus.jpg',
        category: 'flora_kpk',
        latitude: 35.3000,
        longitude: 73.5000,
      ),
      Plant(
        id: '4',
        name: 'Lantana camara',
        botanicalName: 'Lantana camara',
        family: 'Verbenaceae',
        habitat: 'Forests, wastelands',
        description: 'Invasive shrub in Pakhtunkhwa region.',
        uses: 'Ornamental',
        image: 'assets/images/plants/lantana.jpg',
        category: 'invasive',
        latitude: 33.9391,
        longitude: 71.6550,
      ),
      Plant(
        id: '5',
        name: 'Ziziphus jujuba',
        botanicalName: 'Ziziphus jujuba',
        family: 'Rhamnaceae',
        habitat: 'Dry forests',
        description: 'Ber tree, native to Pakhtunkhwa.',
        uses: 'Fruit edible',
        image: 'assets/images/plants/ziziphus.jpg',
        category: 'indigenous',
        latitude: 32.5833,
        longitude: 70.9167,
      ),
    ];
  }

  void _createMarkers() {
    final Set<Marker> newMarkers = {};
    
    for (var plant in allPlants) {
      if (plant.latitude != null && plant.longitude != null) {
        newMarkers.add(
          Marker(
            markerId: MarkerId(plant.id),
            position: LatLng(plant.latitude!, plant.longitude!),
            infoWindow: InfoWindow(
              title: plant.name,
              snippet: plant.habitat,
              onTap: () => _onMarkerTap(plant),
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              _getMarkerColor(plant.category),
            ),
          ),
        );
      }
    }
    
    markers.clear();
    markers.addAll(newMarkers);
  }

  double _getMarkerColor(String category) {
    switch (category) {
      case 'weeds':
        return BitmapDescriptor.hueYellow;
      case 'indigenous':
        return BitmapDescriptor.hueGreen;
      case 'invasive':
        return BitmapDescriptor.hueRed;
      case 'annual':
        return BitmapDescriptor.hueBlue;
      case 'flora_kpk':
        return BitmapDescriptor.hueViolet;
      default:
        return BitmapDescriptor.hueGreen;
    }
  }

  void _onMarkerTap(Plant plant) {
    // Navigate directly to plant detail without dialog
    // This is called from the view via InfoWindow tap
    Get.toNamed('/plant-detail', arguments: {'plant': plant});
  }
}
