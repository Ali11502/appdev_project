import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import '../models/restaurant.dart';
import '../models/cart_item.dart';
import '../models/food.dart';
import '../services/database/firestore.dart';

class RestaurantProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  Restaurant _restaurant = const Restaurant();

  Restaurant get restaurant => _restaurant;
  List<Food> get menu => _restaurant.menu;
  List<CartItem> get cart => _restaurant.cart;
  bool get isMenuLoading => _restaurant.isMenuLoading;
  String? get menuError => _restaurant.menuError;
  String get deliveryAddress => _restaurant.deliveryAddress;

  RestaurantProvider() {
    loadMenuFromFirebase();
  }

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
        isMenuLoading: false,
        menuError: 'Failed to load menu: $e',
      );
    }
    notifyListeners();
  }

  // Refresh menu from Firebase
  Future<void> refreshMenu() async {
    await loadMenuFromFirebase();
  }

  void addToCart(Food food, List<Addon> selectedAddons) {
    final currentCart = List<CartItem>.from(_restaurant.cart);

    // Find existing cart item with same food and addons
    CartItem? existingCartItem = currentCart.firstWhereOrNull((item) {
      bool isSameFood = item.food == food;
      bool isSameAddons = ListEquality().equals(
        item.selectedAddons,
        selectedAddons,
      );
      return isSameFood && isSameAddons;
    });

    if (existingCartItem != null) {
      final index = currentCart.indexOf(existingCartItem);
      currentCart[index] = CartItem(
        food: existingCartItem.food,
        selectedAddons: existingCartItem.selectedAddons,
        quantity: existingCartItem.quantity + 1,
      );
    } else {
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
        currentCart[cartIndex] = CartItem(
          food: currentCart[cartIndex].food,
          selectedAddons: currentCart[cartIndex].selectedAddons,
          quantity: currentCart[cartIndex].quantity - 1,
        );
      } else {
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

  // Delegate methods to the model
  double getTotalPrice() => _restaurant.getTotalPrice();
  int getTotalItemCount() => _restaurant.getTotalItemCount();
  String displayCartReceipt() => _restaurant.displayCartReceipt();
}
