import 'cart_item.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'food.dart';
import 'package:date_format/date_format.dart'; // Make sure to import this package

class Restaurant extends ChangeNotifier {
  // list of food menu
  final List<Food> _menu = [
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

    // burgers
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

  List<Food> get menu => _menu;
  List<CartItem> get cart => _cart;
  final List<CartItem> _cart = [];
  String _deliveryAddress = 'none';
  String get deliveryAddress => _deliveryAddress;
  //add,remove,get total price, total items in cart
  void addToCart(Food food, List<Addon> selectedAddons) {
    // see if there is a cart item already with the same food and selected addons
    CartItem? cartItem = _cart.firstWhereOrNull((item) {
      // check if the food items are the same
      bool isSameFood = item.food == food;

      // check if the list of selected addons are the same
      bool isSameAddons = ListEquality().equals(
        item.selectedAddons,
        selectedAddons,
      );

      return isSameFood && isSameAddons;
    });

    // if item already exists, increase it's quantity
    if (cartItem != null) {
      cartItem.quantity++;
    }
    // otherwise, add a new cart item to the cart
    else {
      _cart.add(CartItem(food: food, selectedAddons: selectedAddons));
    }
    notifyListeners();
  }

  // remove from cart
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

  // get total price of cart
  double getTotalPrice() {
    double total = 0.0;

    for (CartItem cartItem in _cart) {
      double itemTotal = cartItem.food.price;

      for (Addon addon in cartItem.selectedAddons) {
        itemTotal += addon.price;
      }

      total += itemTotal * cartItem.quantity;
    }

    return total;
  }

  // get total number of items in cart
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

  //generate a receipt, double value to money,
  // generate a receipt
  String displayCartReceipt() {
    final receipt = StringBuffer();
    receipt.writeln("Here's your receipt");
    receipt.writeln();

    // format the date to include up to seconds only
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
    receipt.writeln("Total Price: ${_formatPrice(getTotalPrice())}");
    receipt.writeln();
    receipt.writeln('Delivering to: $deliveryAddress ');
    return receipt.toString();
  }

  // format double value into money
  String _formatPrice(double price) {
    return "\$${price.toStringAsFixed(2)}";
  }

  // format list of addons into a string summary
  String _formatAddons(List<Addon> addons) {
    return addons
        .map((addon) => "${addon.name} (${_formatPrice(addon.price)})")
        .join(", ");
  }
}
