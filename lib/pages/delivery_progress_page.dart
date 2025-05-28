import 'package:app_dev_project/pages/home_page.dart';
import 'package:app_dev_project/services/database/firestore.dart';
import 'package:provider/provider.dart';
import 'package:app_dev_project/providers/restaurant_provider.dart';

import '../components/my_receipt.dart';
import 'package:flutter/material.dart';

class DeliveryProgressPage extends StatelessWidget {
  const DeliveryProgressPage({super.key});

  void clearCart(BuildContext context) {
    final restaurantProvider = Provider.of<RestaurantProvider>(
      context,
      listen: false,
    );
    restaurantProvider.clearCart();
  }

  void saveOrderToDatabase(BuildContext context) {
    final FirestoreService db = FirestoreService();
    String receipt = context.read<RestaurantProvider>().displayCartReceipt();
    db.saveOrderToDatabase(receipt);
  }

  @override
  Widget build(BuildContext context) {
    // Save order when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      saveOrderToDatabase(context);
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false, // Removes the default back button
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            clearCart(context);

            // Navigate to your home page
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const HomePage()),
              (route) => false,
            );
          },
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Your existing receipt
            const MyReceipt(),
          ],
        ),
      ),
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
        ),
      ),
      padding: const EdgeInsets.all(25),
      child: Row(
        children: [
          // profile pic of driver
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              shape: BoxShape.circle,
            ),
            child: IconButton(onPressed: () {}, icon: const Icon(Icons.person)),
          ),
          const SizedBox(width: 10),

          // driver details
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Ali Iqbal",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
              Text(
                "Driver",
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ],
          ),

          const Spacer(),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  shape: BoxShape.circle,
                ),
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
                ),
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
