import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import 'package:app_dev_project/components/my_button.dart';
import 'package:app_dev_project/components/my_text_field.dart';
import 'package:app_dev_project/components/my_food_tile.dart';
import 'package:app_dev_project/models/food.dart';

void main() {
  group('Simple Component Golden Tests', () {
    setUpAll(() async {
      await loadAppFonts();
    });

    testGoldens('MyButton states', (tester) async {
      await tester.pumpWidgetBuilder(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyButton(text: 'Normal Button', onTap: () {}),
                  const SizedBox(height: 20),
                  MyButton(text: 'Disabled Button', onTap: null),
                  const SizedBox(height: 20),
                  MyButton(text: 'Long Button Text Example', onTap: () {}),
                ],
              ),
            ),
          ),
        ),
      );

      await multiScreenGolden(
        tester,
        'my_button_states',
        devices: [Device.phone],
      );
    });

    testGoldens('MyTextField states', (tester) async {
      await tester.pumpWidgetBuilder(
        MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyTextField(
                    controller: TextEditingController(),
                    hintText: 'Empty Email Field',
                    obscureText: false,
                  ),
                  const SizedBox(height: 16),
                  MyTextField(
                    controller: TextEditingController(text: 'user@example.com'),
                    hintText: 'Email',
                    obscureText: false,
                  ),
                  const SizedBox(height: 16),
                  MyTextField(
                    controller: TextEditingController(text: 'password123'),
                    hintText: 'Password',
                    obscureText: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await multiScreenGolden(
        tester,
        'text_field_states',
        devices: [Device.phone],
      );
    });

    testGoldens('FoodTile variations', (tester) async {
      final foods = [
        Food(
          name: 'Classic Burger',
          description: 'A simple classic burger',
          imagePath: 'lib/images/burgers/burgers.jpg',
          price: 8.99,
          category: FoodCategory.burgers,
          availableAddons: [Addon(name: 'Cheese', price: 1.00)],
        ),
        Food(
          name: 'Premium Deluxe Extra Large Burger with Special Ingredients',
          description:
              'A very long description for a premium burger that includes many ingredients and special preparation methods that make it unique and delicious.',
          imagePath: 'lib/images/burgers/burgers.jpg',
          price: 15.99,
          category: FoodCategory.burgers,
          availableAddons: [
            Addon(name: 'Extra Premium Cheese', price: 2.00),
            Addon(name: 'Bacon', price: 2.50),
          ],
        ),
        Food(
          name: 'Salad',
          description: 'Fresh salad',
          imagePath: 'lib/images/salads/salads.jpg',
          price: 6.99,
          category: FoodCategory.salads,
          availableAddons: [],
        ),
      ];

      await tester.pumpWidgetBuilder(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              children:
                  foods
                      .map((food) => FoodTile(food: food, onTap: () {}))
                      .toList(),
            ),
          ),
        ),
      );

      await multiScreenGolden(
        tester,
        'food_tile_variations',
        devices: [Device.phone],
      );
    });

    testGoldens('All components overview', (tester) async {
      await tester.pumpWidgetBuilder(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('Components Overview')),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Buttons section
                  const Text(
                    'Buttons:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  MyButton(text: 'Regular Button', onTap: () {}),
                  const SizedBox(height: 8),
                  MyButton(text: 'Disabled Button', onTap: null),

                  const SizedBox(height: 24),

                  // Text fields section
                  const Text(
                    'Text Fields:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  MyTextField(
                    controller: TextEditingController(text: 'sample@email.com'),
                    hintText: 'Email',
                    obscureText: false,
                  ),
                  const SizedBox(height: 8),
                  MyTextField(
                    controller: TextEditingController(),
                    hintText: 'Password',
                    obscureText: true,
                  ),

                  const SizedBox(height: 24),
                  //food tile
                  const Text(
                    'Food Tile:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  FoodTile(
                    food: Food(
                      name: 'Sample Food Item',
                      description: 'A delicious sample food item for testing',
                      imagePath: 'lib/images/burgers/burgers.jpg',
                      price: 9.99,
                      category: FoodCategory.burgers,
                      availableAddons: [Addon(name: 'Extra', price: 1.00)],
                    ),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await multiScreenGolden(
        tester,
        'components_overview',
        devices: [Device.phone],
      );
    });

    testGoldens('Button responsive test', (tester) async {
      await tester.pumpWidgetBuilder(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('Button Responsive Test')),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyButton(text: 'Standard Button', onTap: () {}),
                  const SizedBox(height: 16),
                  MyButton(
                    text: 'Very Long Button Text That Should Fit Properly',
                    onTap: () {},
                  ),
                  const SizedBox(height: 16),
                  MyButton(text: 'Short', onTap: () {}),
                  const SizedBox(height: 16),
                  MyButton(text: 'Disabled State Example', onTap: null),
                ],
              ),
            ),
          ),
        ),
      );

      await multiScreenGolden(
        tester,
        'button_responsive',
        devices: [Device.phone],
      );
    });
  });
}
