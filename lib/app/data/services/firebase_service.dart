import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/plant_model.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  // Collection references
  static CollectionReference get plantsCollection => _firestore.collection('plants');
  static CollectionReference get searchHistoryCollection => _firestore.collection('search_history');

  // Pakhtunkhwa Region Bounds
  static const double kpkMinLat = 30.0;
  static const double kpkMaxLat = 36.0;
  static const double kpkMinLng = 69.0;
  static const double kpkMaxLng = 74.0;

  // Check if plant is in Pakhtunkhwa region
  static bool isInPakhtunkhwaRegion(double lat, double lng) {
    return lat >= kpkMinLat && lat <= kpkMaxLat && lng >= kpkMinLng && lng <= kpkMaxLng;
  }

  // Get plants by category filtered by Pakhtunkhwa region
  static Future<List<Plant>> getPlantsByCategory(String category) async {
    try {
      final QuerySnapshot snapshot = await plantsCollection
          .doc(category)
          .collection('items')
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data == null) return null;
        return Plant.fromJson(data, doc.id);
      }).where((plant) => plant != null).cast<Plant>().where((plant) {
        if (plant.latitude == null || plant.longitude == null) return false;
        return isInPakhtunkhwaRegion(plant.latitude!, plant.longitude!);
      }).toList();
    } catch (e) {
      print('Error getting plants: $e');
      return [];
    }
  }

  // Get all plants across all categories filtered by Pakhtunkhwa region
  static Future<List<Plant>> getAllPlants() async {
    try {
      final List<String> categories = ['weeds', 'indigenous', 'invasive', 'annual', 'flora_kpk'];
      final List<Plant> allPlants = [];

      for (String category in categories) {
        final plants = await getPlantsByCategory(category);
        allPlants.addAll(plants);
      }

      return allPlants;
    } catch (e) {
      print('Error getting all plants: $e');
      return [];
    }
  }

  // Search plants by name (Firestore first, then fallback)
  static Future<List<Plant>> searchPlants(String query) async {
    try {
      // First search in Firestore
      final List<Plant> results = [];
      final categories = ['weeds', 'indigenous', 'invasive', 'annual', 'flora_kpk'];
      
      for (String category in categories) {
        final snapshot = await plantsCollection
            .doc(category)
            .collection('items')
            .orderBy('name')
            .startAt([query])
            .endAt(['$query\uf8ff'])
            .get();
        
        results.addAll(snapshot.docs.map((doc) => 
          Plant.fromJson(doc.data(), doc.id)
        ));
      }
      
      return results;
    } catch (e) {
      print('Error searching plants: $e');
      return [];
    }
  }

  // Save search query to history
  static Future<bool> saveSearchHistory(String userId, String query) async {
    try {
      await searchHistoryCollection.add({
        'userId': userId,
        'query': query,
        'searchedAt': Timestamp.now(),
      });
      return true;
    } catch (e) {
      print('Error saving search history: $e');
      return false;
    }
  }

  // Get recent searches for a user
  static Future<List<Map<String, dynamic>>> getRecentSearches(String userId, {int limit = 10}) async {
    try {
      final snapshot = await searchHistoryCollection
          .where('userId', isEqualTo: userId)
          .orderBy('searchedAt', descending: true)
          .limit(limit)
          .get();
      
      return snapshot.docs.map<Map<String, dynamic>>((doc) => {
        'id': doc.id,
        ...(doc.data() as Map<String, dynamic>? ?? {})
      }).toList();
    } catch (e) {
      print('Error getting recent searches: $e');
      return [];
    }
  }

  // Stream all plants from all categories for real-time updates
  static Stream<List<Plant>> streamAllPlants() {
    final categories = ['weeds', 'indigenous', 'invasive', 'annual', 'flora_kpk'];
    
    // Create a stream controller to merge all category streams
    final controller = StreamController<List<Plant>>.broadcast();
    final allPlants = <Plant>[];
    int activeStreams = categories.length;
    
    for (String category in categories) {
      plantsCollection
          .doc(category)
          .collection('items')
          .snapshots()
          .listen((snapshot) {
        // Remove old plants from this category
        allPlants.removeWhere((p) => p.category == category);
        
        // Add new plants from this category that are in Pakhtunkhwa region
        for (var doc in snapshot.docs) {
          final plant = Plant.fromJson(doc.data(), doc.id);
          if (plant.latitude != null && plant.longitude != null &&
              isInPakhtunkhwaRegion(plant.latitude!, plant.longitude!)) {
            allPlants.add(plant);
          }
        }
        
        controller.add(List<Plant>.from(allPlants));
      }, onError: (error) {
        activeStreams--;
        if (activeStreams == 0) {
          controller.addError(error);
        }
      });
    }
    
    return controller.stream;
  }

  // Check if plant exists by name
  static Future<bool> plantExists(String name) async {
    try {
      final categories = ['weeds', 'indigenous', 'invasive', 'annual', 'flora_kpk'];
      
      for (String category in categories) {
        final snapshot = await plantsCollection
            .doc(category)
            .collection('items')
            .where('name', isEqualTo: name)
            .limit(1)
            .get();
        
        if (snapshot.docs.isNotEmpty) return true;
      }
      return false;
    } catch (e) {
      print('Error checking plant exists: $e');
      return false;
    }
  }

  // Add plant only if it doesn't exist
  static Future<bool> addPlantIfNotExists(String category, Plant plant) async {
    try {
      final exists = await plantExists(plant.name);
      if (!exists) {
        return await addPlant(category, plant);
      }
      return false;
    } catch (e) {
      print('Error adding plant if not exists: $e');
      return false;
    }
  }

  // Get single plant by ID and category
  static Future<Plant?> getPlantById(String category, String id) async {
    try {
      final DocumentSnapshot doc = await plantsCollection
          .doc(category)
          .collection('items')
          .doc(id)
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data == null) return null;
        return Plant.fromJson(data, doc.id);
      }
      return null;
    } catch (e) {
      print('Error getting plant: $e');
      return null;
    }
  }

  // Upload image to Firebase Storage
  static Future<String?> uploadImage(File imageFile, String fileName) async {
    try {
      final Reference ref = _storage.ref().child('plant_images/$fileName');
      final UploadTask uploadTask = ref.putFile(imageFile);
      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  // Add new plant to Firestore
  static Future<bool> addPlant(String category, Plant plant) async {
    try {
      await plantsCollection
          .doc(category)
          .collection('items')
          .add(plant.toJson());
      return true;
    } catch (e) {
      print('Error adding plant: $e');
      return false;
    }
  }

  // Update existing plant
  static Future<bool> updatePlant(String category, String id, Plant plant) async {
    try {
      await plantsCollection
          .doc(category)
          .collection('items')
          .doc(id)
          .update(plant.toJson());
      return true;
    } catch (e) {
      print('Error updating plant: $e');
      return false;
    }
  }

  // Delete plant
  static Future<bool> deletePlant(String category, String id) async {
    try {
      await plantsCollection
          .doc(category)
          .collection('items')
          .doc(id)
          .delete();
      return true;
    } catch (e) {
      print('Error deleting plant: $e');
      return false;
    }
  }

  // Stream plants for real-time updates
  static Stream<List<Plant>> streamPlantsByCategory(String category) {
    return plantsCollection
        .doc(category)
        .collection('items')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Plant.fromJson(doc.data(), doc.id);
      }).toList();
    });
  }
}
