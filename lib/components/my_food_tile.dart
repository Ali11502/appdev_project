import '../models/food.dart';
import 'package:flutter/material.dart';

class FoodTile extends StatelessWidget {
  final Food food;
  final void Function()? onTap;
  const FoodTile({super.key, required this.food, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  // text food details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(food.name),
                        Text(
                          '\$' + food.price.toString(),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ), // TextStyle
                        ), // Text
                        const SizedBox(height: 10),
                        Text(
                          food.description,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ), // TextStyle
                        ), // Text
                      ],
                    ), // Column
                  ),
                  const SizedBox(width: 15),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(food.imagePath, height: 120),
                  ),
                ],
              ),
            ), // Row
          ), // GestureDetector

          Divider(color: Theme.of(context).colorScheme.surface),
        ],
      ),
    );
  }
}
