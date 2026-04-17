import 'package:get/get.dart';

class SearchController extends GetxController {
  final searchQuery = ''.obs;
  final isSearching = false.obs;
  final selectedFilters = <String>[].obs;

  // Suggested plants for beginners
  final suggestedPlants = [
    {
      'name': 'Caper Bush',
      'category': 'Medicinal',
      'image': 'assets/images/plants/caper.jpg',
      'difficulty': 'Easy',
    },
    {
      'name': 'Acacia',
      'category': 'Desert Plants',
      'image': 'assets/images/plants/acacia.jpg',
      'difficulty': 'Medium',
    },
    {
      'name': 'Mesquite',
      'category': 'Desert Plants',
      'image': 'assets/images/plants/mesquite.jpg',
      'difficulty': 'Easy',
    },
    {
      'name': 'Harmal',
      'category': 'Medicinal',
      'image': 'assets/images/plants/harmal.jpg',
      'difficulty': 'Easy',
    },
    {
      'name': 'Desert Sage',
      'category': 'Medicinal',
      'image': 'assets/images/plants/sage.jpg',
      'difficulty': 'Medium',
    },
    {
      'name': 'Mallow',
      'category': 'Wildflowers',
      'image': 'assets/images/plants/mallow.jpg',
      'difficulty': 'Easy',
    },
  ].obs;

  final recentSearches = <String>[].obs;

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    isSearching.value = query.isNotEmpty;
  }

  void clearSearch() {
    searchQuery.value = '';
    isSearching.value = false;
  }

  void addToRecentSearches(String query) {
    if (query.isNotEmpty && !recentSearches.contains(query)) {
      recentSearches.insert(0, query);
      if (recentSearches.length > 10) {
        recentSearches.removeLast();
      }
    }
  }

  void removeFromRecentSearches(String query) {
    recentSearches.remove(query);
  }

  void clearRecentSearches() {
    recentSearches.clear();
  }
}
