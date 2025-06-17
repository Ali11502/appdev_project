import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/food.dart';

class FirestoreService {
  final CollectionReference orders = FirebaseFirestore.instance.collection(
    "orders",
  );

  final CollectionReference menu = FirebaseFirestore.instance.collection(
    "menu",
  );

  Future<void> saveOrderToDatabase(String receipt) async {
    await orders.add({'date': DateTime.now(), 'order': receipt});
  }

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
}
