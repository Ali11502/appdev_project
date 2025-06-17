import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_dev_project/providers/restaurant_provider.dart';

class MyCurrentLocation extends StatelessWidget {
  MyCurrentLocation({super.key});
  final textController = TextEditingController();

  void openLocationSearchBox(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Your Location"),
            content: TextField(
              controller: textController,
              decoration: const InputDecoration(hintText: "Enter address..."),
            ),
            actions: [
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                  textController.clear();
                },
                child: const Text('Cancel'),
              ),
              MaterialButton(
                onPressed: () {
                  String newAddress = textController.text;
                  context.read<RestaurantProvider>().updateDeliveryAddress(
                    newAddress,
                  );
                  Navigator.pop(context);
                  textController.clear();
                },
                child: const Text("Save"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Deliver now",
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          GestureDetector(
            onTap: () => openLocationSearchBox(context),
            child: Row(
              children: [
                Consumer<RestaurantProvider>(
                  builder:
                      (context, restaurant, child) => Text(
                        restaurant.deliveryAddress,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                ),
                const Icon(Icons.keyboard_arrow_down_rounded),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
