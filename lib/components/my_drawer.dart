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
          //  profile section having image, name, email
          Container(
            padding: const EdgeInsets.only(top: 80.0, bottom: 20.0),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(
                      context,
                    ).colorScheme.inversePrimary.withValues(alpha: 0.1),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      width: 2,
                    ),
                  ),
                  child:
                      getCurrentUserPhotoURL() != null
                          ? ClipOval(
                            child: Image.network(
                              getCurrentUserPhotoURL()!,
                              width: 76,
                              height: 76,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.person,
                                  size: 40,
                                  color:
                                      Theme.of(
                                        context,
                                      ).colorScheme.inversePrimary,
                                );
                              },
                            ),
                          )
                          : Icon(
                            Icons.person,
                            size: 40,
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                ),
                const SizedBox(height: 16),
                Text(
                  getCurrentUserName(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  getCurrentUserEmail(),
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(
                      context,
                    ).colorScheme.inversePrimary.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Divider(color: Theme.of(context).colorScheme.secondary),
          ),

          MyDrawerTile(
            text: 'HOME',
            icon: Icons.home,
            onTap: () {
              Navigator.pop(context);
            },
          ),

          MyDrawerTile(
            text: 'SETTINGS',
            icon: Icons.settings,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),

          const Spacer(),

          MyDrawerTile(text: 'LOGOUT', icon: Icons.logout, onTap: logout),
        ],
      ),
    );
  }

  String getCurrentUserName() {
    final authService = AuthService();

    // if name exists then display name else return 'user'
    String? displayName = authService.getUserDisplayName();
    if (displayName != null && displayName.isNotEmpty) {
      return displayName;
    }

    return 'User';
  }

  String getCurrentUserEmail() {
    final authService = AuthService();
    final user = authService.getCurrentUser();
    return user?.email ?? 'No email';
  }

  String? getCurrentUserPhotoURL() {
    final authService = AuthService();
    return authService.getUserPhotoURL();
  }
}
