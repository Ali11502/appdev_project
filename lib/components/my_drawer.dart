import 'package:app_dev_project/services/auth/auth_service.dart';

import 'my_drawer_tile.dart';
import 'package:flutter/material.dart';

import '../pages/settings_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});
  void logout() {
    final _authService = AuthService();
    _authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          // app logo
          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Icon(
              Icons.lock_open_rounded,
              size: 80,
              color: Theme.of(context).colorScheme.inversePrimary,
            ), // Icon
          ), // Padding

          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Divider(
              color: Theme.of(context).colorScheme.secondary,
            ), // Divider
          ), // Padding
          // home list tile
          MyDrawerTile(
            text: 'HOME',
            icon: Icons.home,
            onTap: () {
              Navigator.pop(context);
            },
          ),

          // settings list tile
          MyDrawerTile(
            text: 'SETTINGS',
            icon: Icons.settings,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ), // MaterialPageRoute
              );
            },
          ),
          const Spacer(),
          MyDrawerTile(text: 'LOGOUT', icon: Icons.logout, onTap: logout),
        ],
      ),
    );
  }
}
