import 'package:flutter/material.dart';
import '../models/food.dart';

// Provider for managing food page state
class FoodPageProvider extends ChangeNotifier {
  final Food food;
  final Map<Addon, bool> _selectedAddons = {};

  FoodPageProvider(this.food) {
    // Initialize all addons as unselected
    for (Addon addon in food.availableAddons) {
      _selectedAddons[addon] = false;
    }
  }

  Map<Addon, bool> get selectedAddons => _selectedAddons;

  void toggleAddon(Addon addon, bool value) {
    _selectedAddons[addon] = value;
    notifyListeners();
  }

  List<Addon> getCurrentlySelectedAddons() {
    return _selectedAddons.entries
        .where((entry) => entry.value == true)
        .map((entry) => entry.key)
        .toList();
  }
}
