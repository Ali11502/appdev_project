import '../components/my_cart_tile.dart';
import 'package:flutter/material.dart';
import '../models/restaurant.dart';
import 'package:provider/provider.dart';
import '../components/my_button.dart';
import 'payment_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  // Method to show location dialog
  void _showLocationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // User must set a location
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

  // Method to show location input dialog
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
                    // Update delivery address
                    context.read<Restaurant>().updateDeliveryAddress(
                      textController.text.trim(),
                    );
                    Navigator.pop(context);

                    // Now we can proceed to checkout
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PaymentPage(),
                      ),
                    );
                  } else {
                    // Show error if empty address
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

  // Method to handle checkout button press
  void _handleCheckout(BuildContext context) {
    final restaurant = Provider.of<Restaurant>(context, listen: false);

    // If location is 'none', show location dialog
    if (restaurant.deliveryAddress == 'none') {
      _showLocationDialog(context);
    } else {
      // If location is set, proceed to checkout
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PaymentPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Restaurant>(
      builder: (context, restaurant, child) {
        final userCart = restaurant.cart;

        return Scaffold(
          appBar: AppBar(
            title: const Text("Cart"),
            centerTitle: true,
            backgroundColor: Theme.of(context).colorScheme.surface,
            foregroundColor: Theme.of(context).colorScheme.inversePrimary,
            actions: [
              // clear cart button
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
                            // cancel button
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Cancel"),
                            ),
                            // yes button
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                restaurant.clearCart();
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
              // Display current delivery address
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
                              restaurant.deliveryAddress == 'none'
                                  ? "No address set"
                                  : restaurant.deliveryAddress,
                              style: TextStyle(
                                color:
                                    restaurant.deliveryAddress == 'none'
                                        ? Colors.red
                                        : Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => _showLocationInputDialog(context),
                            child: Text(
                              restaurant.deliveryAddress == 'none'
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
                              // get individual cart item
                              final cartItem = userCart[index];

                              // return cart tile UI
                              return MyCartTile(cartItem: cartItem);
                            },
                          ),
                        ),
                  ],
                ),
              ),
              // button to pay
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
