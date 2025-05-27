import '../components/my_description_box.dart';
import '../components/my_drawer.dart';
import '../components/my_food_tile.dart';
import '../components/my_tab_bar.dart';
import '../components/my_menu_loader.dart';
import '../pages/food_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/my_current_location.dart';
import '../components/my_sliver_app_bar.dart';
import '../models/food.dart';
import '../providers/tab_controller_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  // Sort out and return a list of food items that belong to a specific category
  List<Food> _filterMenuByCategory(FoodCategory category, List<Food> fullMenu) {
    return fullMenu.where((food) => food.category == category).toList();
  }

  // Return list of foods in given category
  List<Widget> getFoodInThisCategory(List<Food> fullMenu) {
    return FoodCategory.values.map((category) {
      List<Food> categoryMenu = _filterMenuByCategory(category, fullMenu);

      return ListView.builder(
        itemCount: categoryMenu.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final food = categoryMenu[index];
          return FoodTile(
            food: food,
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FoodPage(food: food)),
                ),
          );
        },
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final provider = TabControllerProvider();
        provider.initializeTabController(this); // Pass 'this' as TickerProvider
        return provider;
      },
      child: Consumer<TabControllerProvider>(
        builder: (context, tabControllerProvider, child) {
          // Return empty container if tabController is not ready
          if (tabControllerProvider.tabController == null) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          return Scaffold(
            drawer: MyDrawer(),
            body: NestedScrollView(
              headerSliverBuilder:
                  (context, innerBoxIsScrolled) => [
                    MySliverAppBar(
                      title: MyTabBar(
                        tabController: tabControllerProvider.tabController!,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Divider(
                            indent: 25,
                            endIndent: 25,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          MyCurrentLocation(),
                          // description box
                          const MyDescriptionBox(),
                        ],
                      ),
                    ),
                  ],
              body: MyMenuLoader(
                builder:
                    (menu) => TabBarView(
                      controller: tabControllerProvider.tabController!,
                      children: getFoodInThisCategory(menu),
                    ),
              ),
            ),
          );
        },
      ),
    );
  }
}
