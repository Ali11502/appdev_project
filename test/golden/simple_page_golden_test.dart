import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:provider/provider.dart';
import 'package:network_image_mock/network_image_mock.dart';

import 'package:app_dev_project/pages/food_page.dart';
import 'package:app_dev_project/providers/restaurant_provider.dart';
import 'package:app_dev_project/models/food.dart';

void main() {
  group('Simple Page Golden Tests', () {
    setUpAll(() async {
      await loadAppFonts();
    });

    Widget createTestApp(Widget child) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider<RestaurantProvider>(
            create: (_) => RestaurantProvider(),
          ),
        ],
        child: MaterialApp(debugShowCheckedModeBanner: false, home: child),
      );
    }

    testGoldens('Food Page golden test', (tester) async {
      final mockFood = Food(
        name: 'Test Burger',
        description:
            'A delicious test burger with cheese, lettuce, and tomato. Perfect for golden testing!',
        imagePath: 'lib/images/burgers/burgers.jpg',
        price: 12.99,
        category: FoodCategory.burgers,
        availableAddons: [
          Addon(name: 'Extra Cheese', price: 1.00),
          Addon(name: 'Bacon', price: 2.00),
          Addon(name: 'Avocado', price: 1.50),
        ],
      );

      await mockNetworkImagesFor(() async {
        await tester.pumpWidgetBuilder(createTestApp(FoodPage(food: mockFood)));

        await multiScreenGolden(tester, 'food_page', devices: [Device.phone]);
      });
    });

    testGoldens('Food Page with no addons', (tester) async {
      final mockFoodNoAddons = Food(
        name: 'Simple Salad',
        description: 'A simple salad with no additional options.',
        imagePath: 'lib/images/salads/salads.jpg',
        price: 8.99,
        category: FoodCategory.salads,
        availableAddons: [],
      );

      await mockNetworkImagesFor(() async {
        await tester.pumpWidgetBuilder(
          createTestApp(FoodPage(food: mockFoodNoAddons)),
        );

        await multiScreenGolden(
          tester,
          'food_page_no_addons',
          devices: [Device.phone],
        );
      });
    });

    testGoldens('Food Page long content test', (tester) async {
      final longContentFood = Food(
        name:
            'Super Deluxe Extra Large Burger with Lots of Ingredients and a Very Long Name',
        description:
            'This is a very long description that tests how the food page handles extensive text content. It includes multiple sentences to see how the layout adapts to longer descriptions. The burger comes with premium ingredients, special sauce, fresh vegetables, and is served on a artisanal bun that is baked fresh daily in our kitchen.',
        imagePath: 'lib/images/burgers/burgers.jpg',
        price: 15.99,
        category: FoodCategory.burgers,
        availableAddons: [
          Addon(name: 'Extra Cheese with Premium Quality', price: 1.99),
          Addon(name: 'Bacon Premium Cut', price: 2.99),
          Addon(name: 'Avocado Fresh Organic', price: 2.50),
          Addon(name: 'Special House Sauce', price: 0.99),
          Addon(name: 'Grilled Mushrooms', price: 1.50),
        ],
      );

      await mockNetworkImagesFor(() async {
        await tester.pumpWidgetBuilder(
          createTestApp(FoodPage(food: longContentFood)),
        );

        await multiScreenGolden(
          tester,
          'food_page_long_content',
          devices: [Device.phone],
        );
      });
    });

    testGoldens('Food Page different categories', (tester) async {
      final foods = [
        Food(
          name: 'Classic Burger',
          description: 'A classic burger',
          imagePath: 'lib/images/burgers/burgers.jpg',
          price: 9.99,
          category: FoodCategory.burgers,
          availableAddons: [Addon(name: 'Cheese', price: 1.00)],
        ),
        Food(
          name: 'Caesar Salad',
          description: 'Fresh caesar salad',
          imagePath: 'lib/images/salads/salads.jpg',
          price: 7.99,
          category: FoodCategory.salads,
          availableAddons: [],
        ),
        Food(
          name: 'Cola Drink',
          description: 'Refreshing cola',
          imagePath: 'lib/images/drinks/drinks.jpg',
          price: 2.99,
          category: FoodCategory.drinks,
          availableAddons: [],
        ),
      ];

      for (int i = 0; i < foods.length; i++) {
        await mockNetworkImagesFor(() async {
          await tester.pumpWidgetBuilder(
            createTestApp(FoodPage(food: foods[i])),
          );

          await multiScreenGolden(
            tester,
            'food_page_${foods[i].category.toString().split('.').last}',
            devices: [Device.phone],
          );
        });
      }
    });
  });
}
