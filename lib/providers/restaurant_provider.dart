import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import '../models/restaurant.dart';
import '../models/cart_item.dart';
import '../models/food.dart';
import '../services/database/firestore.dart';

class RestaurantProvider extends ChangeNotifier {
  // Firebase service instance
  final FirestoreService _firestoreService = FirestoreService();

  // Private state - using the pure model
  Restaurant _restaurant = const Restaurant();

  // Getters - expose the model's data (EXACTLY as your original)
  Restaurant get restaurant => _restaurant;
  List<Food> get menu => _restaurant.menu;
  List<CartItem> get cart => _restaurant.cart;
  bool get isMenuLoading => _restaurant.isMenuLoading;
  String? get menuError => _restaurant.menuError;
  String get deliveryAddress => _restaurant.deliveryAddress;

  // Constructor - automatically load menu when provider is created (SAME AS ORIGINAL)
  RestaurantProvider() {
    loadMenuFromFirebase();
  }

  // Load menu from Firebase (EXACTLY as your original)
  Future<void> loadMenuFromFirebase() async {
    _restaurant = _restaurant.copyWith(isMenuLoading: true, menuError: null);
    notifyListeners();

    try {
      final loadedMenu = await _firestoreService.getMenuItems();
      _restaurant = _restaurant.copyWith(
        menu: loadedMenu,
        isMenuLoading: false,
        menuError: null,
      );
    } catch (e) {
      _restaurant = _restaurant.copyWith(
        menu: Restaurant.getHardcodedMenu(), // Fallback to hardcoded menu
        isMenuLoading: false,
        menuError: 'Failed to load menu: $e',
      );
    }
    notifyListeners();
  }

  // Refresh menu from Firebase (SAME AS ORIGINAL)
  Future<void> refreshMenu() async {
    await loadMenuFromFirebase();
  }

  // Get menu items by category (EXACTLY as your original)
  Future<List<Food>> getMenuByCategory(FoodCategory category) async {
    try {
      return await _firestoreService.getMenuItemsByCategory(category);
    } catch (e) {
      // Fallback to filtering local menu
      return _restaurant.menu
          .where((food) => food.category == category)
          .toList();
    }
  }

  // One-time method to migrate hardcoded data to Firebase (EXACTLY as your original)
  Future<void> migrateHardcodedMenuToFirebase() async {
    List<Food> hardcodedMenu = Restaurant.getHardcodedMenu();
    try {
      await _firestoreService.populateInitialMenuData(hardcodedMenu);
      print('Successfully migrated menu to Firebase!');
    } catch (e) {
      print('Error migrating menu: $e');
    }
  }

  // === CART METHODS (EXACTLY as your original logic) ===
  void addToCart(Food food, List<Addon> selectedAddons) {
    final currentCart = List<CartItem>.from(_restaurant.cart);

    // Find existing cart item with same food and addons (SAME LOGIC)
    CartItem? existingCartItem = currentCart.firstWhereOrNull((item) {
      bool isSameFood = item.food == food;
      bool isSameAddons = ListEquality().equals(
        item.selectedAddons,
        selectedAddons,
      );
      return isSameFood && isSameAddons;
    });

    if (existingCartItem != null) {
      // Increase quantity of existing item (SAME AS ORIGINAL)
      final index = currentCart.indexOf(existingCartItem);
      currentCart[index] = CartItem(
        food: existingCartItem.food,
        selectedAddons: existingCartItem.selectedAddons,
        quantity: existingCartItem.quantity + 1,
      );
    } else {
      // Add new item to cart (SAME AS ORIGINAL)
      currentCart.add(CartItem(food: food, selectedAddons: selectedAddons));
    }

    _restaurant = _restaurant.copyWith(cart: currentCart);
    notifyListeners();
  }

  void removeFromCart(CartItem cartItem) {
    final currentCart = List<CartItem>.from(_restaurant.cart);
    final cartIndex = currentCart.indexOf(cartItem);

    if (cartIndex != -1) {
      if (currentCart[cartIndex].quantity > 1) {
        // Decrease quantity (SAME AS ORIGINAL)
        currentCart[cartIndex] = CartItem(
          food: currentCart[cartIndex].food,
          selectedAddons: currentCart[cartIndex].selectedAddons,
          quantity: currentCart[cartIndex].quantity - 1,
        );
      } else {
        // Remove item completely (SAME AS ORIGINAL)
        currentCart.removeAt(cartIndex);
      }
    }

    _restaurant = _restaurant.copyWith(cart: currentCart);
    notifyListeners();
  }

  void clearCart() {
    _restaurant = _restaurant.copyWith(cart: []);
    notifyListeners();
  }

  void updateDeliveryAddress(String newAddress) {
    _restaurant = _restaurant.copyWith(deliveryAddress: newAddress);
    notifyListeners();
  }

  // Delegate methods to the model (SAME AS ORIGINAL)
  double getTotalPrice() => _restaurant.getTotalPrice();
  int getTotalItemCount() => _restaurant.getTotalItemCount();
  String displayCartReceipt() => _restaurant.displayCartReceipt();
}
