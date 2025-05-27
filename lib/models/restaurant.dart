import 'cart_item.dart';
import 'food.dart';
import 'package:date_format/date_format.dart';

// Pure data model - no ChangeNotifier
class Restaurant {
  final List<Food> menu;
  final List<CartItem> cart;
  final double deliveryCharges;
  final String deliveryAddress;
  final bool isMenuLoading;
  final String? menuError;

  const Restaurant({
    this.menu = const [],
    this.cart = const [],
    this.deliveryCharges = 9.99,
    this.deliveryAddress = 'none',
    this.isMenuLoading = false,
    this.menuError,
  });

  // Copy with method for immutable updates
  Restaurant copyWith({
    List<Food>? menu,
    List<CartItem>? cart,
    double? deliveryCharges,
    String? deliveryAddress,
    bool? isMenuLoading,
    String? menuError,
  }) {
    return Restaurant(
      menu: menu ?? this.menu,
      cart: cart ?? this.cart,
      deliveryCharges: deliveryCharges ?? this.deliveryCharges,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      isMenuLoading: isMenuLoading ?? this.isMenuLoading,
      menuError: menuError ?? this.menuError,
    );
  }

  // Pure calculation methods (no state changes)
  double getTotalPrice() {
    double total = 0.00;

    for (CartItem cartItem in cart) {
      double itemTotal = cartItem.food.price;

      for (Addon addon in cartItem.selectedAddons) {
        itemTotal += addon.price;
      }

      total += itemTotal * cartItem.quantity;
    }

    return total + deliveryCharges;
  }

  int getTotalItemCount() {
    int totalItemCount = 0;

    for (CartItem cartItem in cart) {
      totalItemCount += cartItem.quantity;
    }

    return totalItemCount;
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

    for (final cartItem in cart) {
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
    receipt.writeln("Delivery charges: $deliveryCharges");
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

  // Fallback hardcoded menu (static method) - EXACTLY as your original
  static List<Food> getHardcodedMenu() {
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
}
