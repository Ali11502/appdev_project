// food item
class Food {
  final String name; // cheese burger
  final String description; // a burger
  final String imagePath;
  final double price;
  final FoodCategory category;
  List<Addon> availableAddons;

  Food({
    required this.name,
    required this.description,
    required this.imagePath,
    required this.price,
    required this.category,
    required this.availableAddons,
  });

  // Convert Food object to Map for Firestore
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'imagePath': imagePath,
      'price': price,
      'category': category.toString().split('.').last, // Convert enum to string
      'availableAddons':
          availableAddons.map((addon) => addon.toJson()).toList(),
    };
  }

  // Create Food object from Firestore Map
  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imagePath: json['imagePath'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      category: _categoryFromString(json['category'] ?? 'burgers'),
      availableAddons:
          (json['availableAddons'] as List<dynamic>? ?? [])
              .map(
                (addonJson) =>
                    Addon.fromJson(addonJson as Map<String, dynamic>),
              )
              .toList(),
    );
  }

  // Helper method to convert string back to enum
  static FoodCategory _categoryFromString(String categoryString) {
    switch (categoryString.toLowerCase()) {
      case 'burgers':
        return FoodCategory.burgers;
      case 'salads':
        return FoodCategory.salads;
      case 'sides':
        return FoodCategory.sides;
      case 'desserts':
        return FoodCategory.desserts;
      case 'drinks':
        return FoodCategory.drinks;
      default:
        return FoodCategory.burgers; // Default fallback
    }
  }
}

// food categories
enum FoodCategory { burgers, salads, sides, desserts, drinks }

// food addons
class Addon {
  String name;
  double price;

  Addon({required this.name, required this.price});

  // Convert Addon object to Map for Firestore
  Map<String, dynamic> toJson() {
    return {'name': name, 'price': price};
  }

  // Create Addon object from Firestore Map
  factory Addon.fromJson(Map<String, dynamic> json) {
    return Addon(
      name: json['name'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
    );
  }
}
