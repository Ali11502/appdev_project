import 'my_quantity_selector.dart';
import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/restaurant.dart';
import 'package:provider/provider.dart';

class MyCartTile extends StatelessWidget {
  final CartItem cartItem;

  const MyCartTile({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    return Consumer<Restaurant>(
      builder:
          (context, restaurant, child) => Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(
                12,
              ), // Increased radius for better look
            ),
            margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(
                    10.0,
                  ), // Slightly increased padding
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Updated image container with better handling
                      Container(
                        width:
                            80, // Slightly reduced width to ensure no overflow
                        height: 80, // Increased height for better aspect ratio
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          // Add a slight background color to handle transparent images better
                          color: Colors.grey.withValues(alpha: 0.1),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Image.asset(
                            cartItem.food.imagePath,
                            fit:
                                BoxFit
                                    .cover, // This ensures the image covers the area properly
                          ),
                        ),
                      ),
                      const SizedBox(width: 15), // Increased spacing
                      // Text content with improved spacing and styling
                      Expanded(
                        // Use Expanded instead of just Column to handle text overflow
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cartItem.food.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              overflow:
                                  TextOverflow.ellipsis, // Handle long names
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '\$${cartItem.food.price.toString()}',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Quantity selector
                      QuantitySelector(
                        quantity: cartItem.quantity,
                        food: cartItem.food,
                        onDecrement: () {
                          restaurant.removeFromCart(cartItem);
                        },
                        onIncrement: () {
                          restaurant.addToCart(
                            cartItem.food,
                            cartItem.selectedAddons,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                // Addons section with improved layout
                if (cartItem.selectedAddons.isNotEmpty)
                  Container(
                    height: 50, // Fixed height
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      children:
                          cartItem.selectedAddons
                              .map(
                                (addon) => Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: FilterChip(
                                    label: Text(addon.name),
                                    shape: StadiumBorder(
                                      side: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withValues(alpha: 0.5),
                                      ),
                                    ),
                                    onSelected: (value) {},
                                    backgroundColor:
                                        Theme.of(context).colorScheme.secondary,
                                    labelStyle: TextStyle(
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.inversePrimary,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ),
              ],
            ),
          ),
    );
  }
}
