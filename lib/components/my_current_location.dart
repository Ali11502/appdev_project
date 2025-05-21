import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/restaurant.dart';

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
                  // update delivery address
                  String newAddress = textController.text;
                  context.read<Restaurant>().updateDeliveryAddress(newAddress);
                  Navigator.pop(context);
                  textController.clear();
                },
                child: const Text("Save"),
              ), // MaterialButton
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
          ), // Text
          GestureDetector(
            onTap: () => openLocationSearchBox(context),
            child: Row(
              children: [
                // address
                Consumer<Restaurant>(
                  builder:
                      (context, restaurant, child) => Text(
                        restaurant.deliveryAddress,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontWeight: FontWeight.bold,
                        ), // TextStyle
                      ), // Text
                ), // Consumer
                // drop down menu
                Icon(Icons.keyboard_arrow_down_rounded),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
