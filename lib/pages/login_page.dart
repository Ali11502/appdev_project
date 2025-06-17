import '../components/my_button.dart';
import '../components/my_google_signin_button.dart';
import 'package:flutter/material.dart';
import '../components/my_text_field.dart';
import '../providers/auth_provider.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  final void Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
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
                  Icon(
                    Icons.lock_open_rounded,
                    size: 100,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  const SizedBox(height: 25),

                  Text(
                    "A's Kitchen ",
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                  const SizedBox(height: 25),

                  MyTextField(
                    controller: emailController,
                    hintText: "Email",
                    obscureText: false,
                  ),

                  const SizedBox(height: 10),

                  MyTextField(
                    controller: passwordController,
                    hintText: "Password",
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),

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

                  MyGoogleSignInButton(
                    onTap: () => authProvider.signInWithGoogle(),
                    isLoading: authProvider.isGoogleLoginLoading,
                  ),

                  const SizedBox(height: 25),

                  // Register now n
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Not a member?',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: onTap,
                        child: Text(
                          'Register now',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
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
