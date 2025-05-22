import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/food.dart';

class FirestoreService {
  // Get collection of orders
  final CollectionReference orders = FirebaseFirestore.instance.collection(
    "orders",
  );

  // Get collection of menu items
  final CollectionReference menu = FirebaseFirestore.instance.collection(
    "menu",
  );

  // Save order to database
  Future<void> saveOrderToDatabase(String receipt) async {
    await orders.add({'date': DateTime.now(), 'order': receipt});
  }

  // ===== MENU MANAGEMENT METHODS =====

  // Fetch all menu items from Firestore
  Future<List<Food>> getMenuItems() async {
    try {
      QuerySnapshot snapshot = await menu.get();
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Food.fromJson(data);
      }).toList();
    } catch (e) {
      print('Error fetching menu items: $e');
      return [];
    }
  }

  // Fetch menu items by category
  Future<List<Food>> getMenuItemsByCategory(FoodCategory category) async {
    try {
      String categoryString = category.toString().split('.').last;
      QuerySnapshot snapshot =
          await menu.where('category', isEqualTo: categoryString).get();

      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Food.fromJson(data);
      }).toList();
    } catch (e) {
      print('Error fetching menu items by category: $e');
      return [];
    }
  }

  // Add a new menu item to Firestore (for Firebase Console reference)
  Future<void> addMenuItem(Food food) async {
    try {
      await menu.add(food.toJson());
    } catch (e) {
      print('Error adding menu item: $e');
    }
  }

  // Update a menu item in Firestore (for Firebase Console reference)
  Future<void> updateMenuItem(String docId, Food food) async {
    try {
      await menu.doc(docId).update(food.toJson());
    } catch (e) {
      print('Error updating menu item: $e');
    }
  }

  // Delete a menu item from Firestore (for Firebase Console reference)
  Future<void> deleteMenuItem(String docId) async {
    try {
      await menu.doc(docId).delete();
    } catch (e) {
      print('Error deleting menu item: $e');
    }
  }

  // Helper method to populate initial menu data (run once to migrate existing data)
  Future<void> populateInitialMenuData(List<Food> initialMenu) async {
    try {
      WriteBatch batch = FirebaseFirestore.instance.batch();

      for (Food food in initialMenu) {
        DocumentReference docRef = menu.doc();
        batch.set(docRef, food.toJson());
      }

      await batch.commit();
      print('Initial menu data populated successfully');
    } catch (e) {
      print('Error populating initial menu data: $e');
    }
  }
}
