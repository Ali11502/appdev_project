import 'cart_item.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'food.dart';
import 'package:date_format/date_format.dart';
import '../services/database/firestore.dart'; // Import the FirestoreService

class Restaurant extends ChangeNotifier {
  // Firebase service instance
  final FirestoreService _firestoreService = FirestoreService();

  // Private menu list - will be populated from Firebase
  List<Food> _menu = [];

  // Loading state for menu
  bool _isMenuLoading = false;

  // Error state for menu loading
  String? _menuError;

  // Getters
  List<Food> get menu => _menu;
  List<CartItem> get cart => _cart;
  bool get isMenuLoading => _isMenuLoading;
  String? get menuError => _menuError;

  final List<CartItem> _cart = [];
  final double _deliveryCharges = 9.99;
  String _deliveryAddress = 'none';
  String get deliveryAddress => _deliveryAddress;

  // Constructor - automatically load menu when Restaurant is created
  Restaurant() {
    loadMenuFromFirebase();
  }

  // Load menu from Firebase
  Future<void> loadMenuFromFirebase() async {
    _isMenuLoading = true;
    _menuError = null;
    notifyListeners();

    try {
      _menu = await _firestoreService.getMenuItems();
      _menuError = null;
    } catch (e) {
      _menuError = 'Failed to load menu: $e';
      _menu = _getHardcodedMenuAsFallback(); // Fallback to hardcoded menu
    } finally {
      _isMenuLoading = false;
      notifyListeners();
    }
  }

  // Refresh menu from Firebase
  Future<void> refreshMenu() async {
    await loadMenuFromFirebase();
  }

  // Get menu items by category
  Future<List<Food>> getMenuByCategory(FoodCategory category) async {
    try {
      return await _firestoreService.getMenuItemsByCategory(category);
    } catch (e) {
      // Fallback to filtering local menu
      return _menu.where((food) => food.category == category).toList();
    }
  }

  // One-time method to migrate hardcoded data to Firebase
  // Call this once to populate your Firestore database
  Future<void> migrateHardcodedMenuToFirebase() async {
    List<Food> hardcodedMenu = _getHardcodedMenuAsFallback();
    try {
      await _firestoreService.populateInitialMenuData(hardcodedMenu);
      print('Successfully migrated menu to Firebase!');
    } catch (e) {
      print('Error migrating menu: $e');
    }
  }

  // Fallback hardcoded menu (keep as backup)
  List<Food> _getHardcodedMenuAsFallback() {
    return [
      // burgers
      Food(
        name: "Classic Cheeseburger",
        description:
            "A juicy beef patty with melted cheddar, lettuce, tomato, and a hint of onion and pickle.",
        imagePath: "lib/images/burgers.jpg",
        price: 8.99,
        category: FoodCategory.burgers,
        availableAddons: [
          Addon(name: "Extra Cheese", price: 0.99),
          Addon(name: "Bacon", price: 1.49),
          Addon(name: "Avocado", price: 1.99),
        ],
      ),
      Food(
        name: "Classic ChickenBurger",
        description:
            "A juicy beef patty with melted cheddar, lettuce, tomato, and a hint of onion and pickle.",
        imagePath: "lib/images/burgers.jpg",
        price: 8.99,
        category: FoodCategory.burgers,
        availableAddons: [Addon(name: "Avocado", price: 1.99)],
      ),
      // desserts
      Food(
        name: "Plain cake",
        description: "simple sweet cake.",
        imagePath: "lib/images/desserts.jpg",
        price: 8.99,
        category: FoodCategory.desserts,
        availableAddons: [Addon(name: "Chocolate syrup topping", price: 0.5)],
      ),
      Food(
        name: "Chocolate Cake",
        description: "Chocolate cake with topping of melted dairymilk.",
        imagePath: "lib/images/desserts.jpg",
        price: 10.0,
        category: FoodCategory.desserts,
        availableAddons: [Addon(name: "Bunties", price: 0.25)],
      ),
      //drinks
      Food(
        name: "Cola Next",
        description: "Local clone of Pepsi.",
        imagePath: "lib/images/drinks.jpg",
        price: 2.99,
        category: FoodCategory.drinks,
        availableAddons: [Addon(name: "some extra ice", price: 0.1)],
      ),
      Food(
        name: "Fizz up ",
        description: "Local clone of 7up.",
        imagePath: "lib/images/drinks.jpg",
        price: 2.99,
        category: FoodCategory.drinks,
        availableAddons: [],
      ),
      //sides
      Food(
        name: "Smashed Potato",
        description: "smashed potato",
        imagePath: "lib/images/sides.jpg",
        price: 2.99,
        category: FoodCategory.sides,
        availableAddons: [],
      ),
      Food(
        name: "Boiled rice",
        description: "Boiled rice.",
        imagePath: "lib/images/sides.jpg",
        price: 2.99,
        category: FoodCategory.sides,
        availableAddons: [],
      ),
      // salad
      Food(
        name: "Ceaser salas",
        description: "ceaser sauce",
        imagePath: "lib/images/salads.jpg",
        price: 1.0,
        category: FoodCategory.salads,
        availableAddons: [Addon(name: "some Ceaser sauce", price: 0.1)],
      ),
      Food(
        name: "Russian salad",
        description: "Russian sauce",
        imagePath: "lib/images/salads.jpg",
        price: 1.0,
        category: FoodCategory.salads,
        availableAddons: [Addon(name: "some Russian sauce", price: 0.1)],
      ),
    ];
  }

  // === EXISTING CART METHODS (unchanged) ===
  void addToCart(Food food, List<Addon> selectedAddons) {
    CartItem? cartItem = _cart.firstWhereOrNull((item) {
      bool isSameFood = item.food == food;
      bool isSameAddons = ListEquality().equals(
        item.selectedAddons,
        selectedAddons,
      );
      return isSameFood && isSameAddons;
    });

    if (cartItem != null) {
      cartItem.quantity++;
    } else {
      _cart.add(CartItem(food: food, selectedAddons: selectedAddons));
    }
    notifyListeners();
  }

  void removeFromCart(CartItem cartItem) {
    int cartIndex = _cart.indexOf(cartItem);

    if (cartIndex != -1) {
      if (_cart[cartIndex].quantity > 1) {
        _cart[cartIndex].quantity--;
      } else {
        _cart.removeAt(cartIndex);
      }
    }
    notifyListeners();
  }

  double getTotalPrice() {
    double total = 0.00;

    for (CartItem cartItem in _cart) {
      double itemTotal = cartItem.food.price;

      for (Addon addon in cartItem.selectedAddons) {
        itemTotal += addon.price;
      }

      total += itemTotal * cartItem.quantity;
    }

    return total + _deliveryCharges;
  }

  int getTotalItemCount() {
    int totalItemCount = 0;

    for (CartItem cartItem in _cart) {
      totalItemCount += cartItem.quantity;
    }

    return totalItemCount;
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  void updateDeliveryAddress(String newAddress) {
    _deliveryAddress = newAddress;
    notifyListeners();
  }

  String displayCartReceipt() {
    final receipt = StringBuffer();
    receipt.writeln("Here's your receipt");
    receipt.writeln();

    String formattedDate = formatDate(DateTime.now(), [
      yyyy,
      '-',
      mm,
      '-',
      dd,
      ' ',
      HH,
      ':',
      nn,
      ':',
      ss,
    ]);
    receipt.writeln(formattedDate);
    receipt.writeln();
    receipt.writeln("------------");

    for (final cartItem in _cart) {
      receipt.writeln(
        "${cartItem.quantity} x ${cartItem.food.name} - ${_formatPrice(cartItem.food.price)}",
      );
      if (cartItem.selectedAddons.isNotEmpty) {
        receipt.writeln(
          "    Add-ons: ${_formatAddons(cartItem.selectedAddons)}",
        );
      }
      receipt.writeln();
    }
    receipt.writeln("------------");
    receipt.writeln();
    receipt.writeln("Total Items: ${getTotalItemCount()}");
    receipt.writeln("Delivery charges: $_deliveryCharges");
    receipt.writeln();
    receipt.writeln("Total Price: ${_formatPrice(getTotalPrice())}");
    receipt.writeln('Delivering to: $deliveryAddress ');
    return receipt.toString();
  }

  String _formatPrice(double price) {
    return "\$${price.toStringAsFixed(2)}";
  }

  String _formatAddons(List<Addon> addons) {
    return addons
        .map((addon) => "${addon.name} (${_formatPrice(addon.price)})")
        .join(", ");
  }
}
