class Plant {
  final String id;
  final String name;
  final String botanicalName;
  final String family;
  final String habitat;
  final String description;
  final String uses;
  final String image;
  final String category;
  final double? latitude;
  final double? longitude;

  Plant({
    required this.id,
    required this.name,
    required this.botanicalName,
    required this.family,
    required this.habitat,
    required this.description,
    required this.uses,
    required this.image,
    required this.category,
    this.latitude,
    this.longitude,
  });

  factory Plant.fromJson(Map<String, dynamic> json, String id) {
    return Plant(
      id: id,
      name: json['name'] ?? '',
      botanicalName: json['botanicalName'] ?? '',
      family: json['family'] ?? '',
      habitat: json['habitat'] ?? '',
      description: json['description'] ?? '',
      uses: json['uses'] ?? '',
      image: json['image'] ?? '',
      category: json['category'] ?? '',
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'botanicalName': botanicalName,
      'family': family,
      'habitat': habitat,
      'description': description,
      'uses': uses,
      'image': image,
      'category': category,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  Plant copyWith({
    String? id,
    String? name,
    String? botanicalName,
    String? family,
    String? habitat,
    String? description,
    String? uses,
    String? image,
    String? category,
    double? latitude,
    double? longitude,
  }) {
    return Plant(
      id: id ?? this.id,
      name: name ?? this.name,
      botanicalName: botanicalName ?? this.botanicalName,
      family: family ?? this.family,
      habitat: habitat ?? this.habitat,
      description: description ?? this.description,
      uses: uses ?? this.uses,
      image: image ?? this.image,
      category: category ?? this.category,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}
