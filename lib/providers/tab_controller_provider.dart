import 'package:flutter/material.dart';
import '../models/food.dart';

class TabControllerProvider extends ChangeNotifier {
  TabController? _tabController;

  TabController? get tabController => _tabController;

  void initializeTabController(TickerProvider vsync) {
    _tabController = TabController(
      length: FoodCategory.values.length,
      vsync: vsync,
    );
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }
}
