import 'cart_item.dart';
import 'food.dart';
import 'package:date_format/date_format.dart';

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

  // copies prvious object and creates new object with updated values
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
}
