class Food {
  final String name;
  final String description;
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

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'imagePath': imagePath,
      'price': price,
      'category': category.toString().split('.').last,
      'availableAddons':
          availableAddons.map((addon) => addon.toJson()).toList(),
    };
  }

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
        return FoodCategory.burgers;
    }
  }
}

enum FoodCategory { burgers, salads, sides, desserts, drinks }

class Addon {
  String name;
  double price;

  Addon({required this.name, required this.price});

  // create addon object for the data to firestore
  Map<String, dynamic> toJson() {
    return {'name': name, 'price': price};
  }

  // create addon object from the data by firestore
  factory Addon.fromJson(Map<String, dynamic> json) {
    return Addon(
      name: json['name'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
    );
  }
}
