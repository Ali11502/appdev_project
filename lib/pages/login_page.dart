import '../components/my_button.dart';
import '../components/my_google_signin_button.dart';
import 'package:flutter/material.dart';
import '../components/my_text_field.dart';
import '../providers/auth_provider.dart';
import 'package:provider/provider.dart';

import '../providers/button_press_provider.dart';

class LoginPage extends StatelessWidget {
  final void Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Controllers to handle text input
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          // Show error dialog if there's an error
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (authProvider.errorMessage != null) {
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text('Authentication Error'),
                      content: Text(authProvider.errorMessage!),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            authProvider.clearError();
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
              );
            }
          });

          return Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App logo - a lock icon
                  Icon(
                    Icons.lock_open_rounded,
                    size: 100,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  const SizedBox(height: 25),

                  // App title
                  Text(
                    'Food Delivery App',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Email input field
                  MyTextField(
                    controller: emailController,
                    hintText: "Email",
                    obscureText: false,
                  ),

                  const SizedBox(height: 10),

                  // Password input field
                  MyTextField(
                    controller: passwordController,
                    hintText: "Password",
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),

                  // Sign in button
                  MyButton(
                    text:
                        authProvider.isEmailLoginLoading
                            ? 'Signing in...'
                            : 'Sign in',
                    onTap:
                        authProvider.isEmailLoginLoading
                            ? null
                            : () => authProvider.signInWithEmail(
                              emailController.text,
                              passwordController.text,
                            ),
                  ),

                  const SizedBox(height: 20),

                  // Divider with "OR" text
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'OR',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Google Sign-In button
                  MyGoogleSignInButton(
                    onTap: () => authProvider.signInWithGoogle(),
                    isLoading: authProvider.isGoogleLoginLoading,
                  ),

                  const SizedBox(height: 25),

                  // Register now row with Provider for button press effect
                  ChangeNotifierProvider(
                    create: (context) => ButtonPressProvider(),
                    child: Consumer<ButtonPressProvider>(
                      builder: (context, buttonPressProvider, child) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Not a member?',
                              style: TextStyle(
                                color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.inversePrimary,
                              ),
                            ),
                            const SizedBox(width: 4),

                            // Using MouseRegion to change cursor on web platforms
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: onTap,
                                // Add feedback effects for tap interactions
                                onTapDown:
                                    (_) => buttonPressProvider.onTapDown(),
                                onTapUp: (_) => buttonPressProvider.onTapUp(),
                                onTapCancel:
                                    () => buttonPressProvider.onTapCancel(),
                                child: Text(
                                  'Register now',
                                  style: TextStyle(
                                    color:
                                        buttonPressProvider.isPressed
                                            ? Theme.of(
                                              context,
                                            ).colorScheme.primary
                                            : Theme.of(
                                              context,
                                            ).colorScheme.inversePrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
