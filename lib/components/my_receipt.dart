import 'package:app_dev_project/providers/restaurant_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyReceipt extends StatelessWidget {
  const MyReceipt({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, bottom: 25, top: 50),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Thank you for your order!"),
            const SizedBox(height: 25),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(25),
              child: Consumer<RestaurantProvider>(
                builder:
                    (context, restaurant, child) =>
                        Text(restaurant.displayCartReceipt()),
              ),
            ),
            const SizedBox(height: 25),
            const Text("Thank you for your order"),
            const Text("Delivery is expected within 30 minutes for now"),
          ],
        ),
      ),
    );
  }
}
