import 'package:app_dev_project/models/restaurant.dart';
import 'package:app_dev_project/pages/home_page.dart';
import 'package:app_dev_project/services/database/firestore.dart';
import 'package:provider/provider.dart';

import '../components/my_receipt.dart';
// import '../models/restaurant.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

class DeliveryProgressPage extends StatefulWidget {
  const DeliveryProgressPage({super.key});

  @override
  State<DeliveryProgressPage> createState() => _DeliveryProgressPageState();
}

class _DeliveryProgressPageState extends State<DeliveryProgressPage> {
  FirestoreService db = FirestoreService();
  void clearCart() {
    final restaurant = Provider.of<Restaurant>(context, listen: false);
    restaurant.clearCart();
  }

  @override
  void initState() {
    super.initState();
    String receipt = context.read<Restaurant>().displayCartReceipt();
    db.saveOrderToDatabase(receipt);
    clearCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false, // Removes the default back button
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            // Navigate to your home page
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ), // Replace YourHomePage with your actual home page widget
              (route) => false,
            );
          },
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
      body: SingleChildScrollView(child: const Column(children: [MyReceipt()])),
    );
  }

  // Custom Bottom Nav Bar - Message / Call delivery driver
  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ), // BorderRadius.only
      ), // BoxDecoration
      padding: const EdgeInsets.all(25),
      child: Row(
        children: [
          // profile pic of driver
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              shape: BoxShape.circle,
            ), // BoxDecoration
            child: IconButton(onPressed: () {}, icon: const Icon(Icons.person)),
          ),
          const SizedBox(width: 10),

          // driver details
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Mitch Koko",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ), // TextStyle
              ), // Text
              Text(
                "Driver",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ), // TextStyle
              ), // Text
            ],
          ),

          const Spacer(),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  shape: BoxShape.circle,
                ), // BoxDecoration
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.message),
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  shape: BoxShape.circle,
                ), // BoxDecoration
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.call),
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
