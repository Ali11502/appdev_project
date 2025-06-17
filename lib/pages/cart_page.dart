import 'package:app_dev_project/providers/restaurant_provider.dart';

import '../components/my_cart_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/my_button.dart';
import 'payment_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  //dialog shown if user tried to proceed without giving location
  void _showLocationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: const Text("Delivery Address Required"),
            content: const Text(
              "Please set your delivery location before proceeding to checkout.",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showLocationInputDialog(context);
                },
                child: const Text("Set Location"),
              ),
            ],
          ),
    );
  }

  void _showLocationInputDialog(BuildContext context) {
    final textController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: const Text("Enter Your Delivery Address"),
            content: TextField(
              controller: textController,
              decoration: const InputDecoration(
                hintText: "Enter full delivery address...",
                helperText: "Please enter a complete address ",
              ),
              maxLines: 3,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // If user cancels, keep them on cart page
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  if (textController.text.trim().isNotEmpty) {
                    context.read<RestaurantProvider>().updateDeliveryAddress(
                      textController.text.trim(),
                    );
                    Navigator.pop(context);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PaymentPage(),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please enter a valid address"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: const Text("Save & Continue"),
              ),
            ],
          ),
    );
  }

  void _handleCheckout(BuildContext context) {
    final restaurant = Provider.of<RestaurantProvider>(context, listen: false);

    if (restaurant.deliveryAddress == 'none') {
      _showLocationDialog(context);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PaymentPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RestaurantProvider>(
      builder: (context, restaurantProvider, child) {
        final userCart = restaurantProvider.cart;

        return Scaffold(
          appBar: AppBar(
            title: const Text("Cart"),
            centerTitle: true,
            backgroundColor: Theme.of(context).colorScheme.surface,
            foregroundColor: Theme.of(context).colorScheme.inversePrimary,
            actions: [
              if (userCart.isNotEmpty)
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: const Text(
                              "Are you sure you want to clear the cart?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  restaurantProvider.clearCart();
                                },
                                child: const Text("Yes"),
                              ),
                            ],
                          ),
                    );
                  },
                  icon: const Icon(Icons.delete),
                ),
            ],
          ),

          body: Column(
            children: [
              if (userCart.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Delivery to:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              restaurantProvider.deliveryAddress == 'none'
                                  ? "No address set"
                                  : restaurantProvider.deliveryAddress,
                              style: TextStyle(
                                color:
                                    restaurantProvider.deliveryAddress == 'none'
                                        ? Colors.red
                                        : Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => _showLocationInputDialog(context),
                            child: Text(
                              restaurantProvider.deliveryAddress == 'none'
                                  ? "Set Location"
                                  : "Change",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: Column(
                  children: [
                    userCart.isEmpty
                        ? const Expanded(
                          child: Center(child: Text("Cart is empty")),
                        )
                        : Expanded(
                          child: ListView.builder(
                            itemCount: userCart.length,
                            itemBuilder: (context, index) {
                              final cartItem = userCart[index];

                              return MyCartTile(cartItem: cartItem);
                            },
                          ),
                        ),
                  ],
                ),
              ),
              if (userCart.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: MyButton(
                    onTap: () => _handleCheckout(context),
                    text: "Go to checkout",
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
