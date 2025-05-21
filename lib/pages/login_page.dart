import '../components/my_button.dart';
import 'package:flutter/material.dart';
import '../components/my_text_field.dart';
import '../services/auth/auth_service.dart';

// Changed to StatefulWidget since we need to manage state with controllers
class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  // Constructor with required onTap parameter
  const LoginPage({super.key, required this.onTap});

  // Create state method to connect with _LoginPageState
  @override
  State<LoginPage> createState() => _LoginPageState();
}

// State class for the LoginPage
class _LoginPageState extends State<LoginPage> {
  // Controllers to handle text input
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  // login method
  // login method
  void login() async {
    // get instance of auth service
    final _authService = AuthService();

    // try sign in
    try {
      await _authService.signInWithEmailPassword(
        emailController.text,
        passwordController.text,
      );
    }
    // display any errors
    catch (e) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(title: Text(e.toString())), // AlertDialog
      );
    }
  } // forgot password

  void forgotPw() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.background,
            title: const Text("User tapped forgot password."),
          ), // AlertDialog
    );
  }

  // Variable to track whether register text is being pressed
  bool isRegisterPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
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
              text: 'Sign in',
              onTap: () {
                login();
              },
            ),

            const SizedBox(height: 25),

            // Register now row
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

                // Using MouseRegion to change cursor on web platforms
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: widget.onTap,
                    // Add feedback effects for tap interactions
                    onTapDown: (_) {
                      setState(() {
                        isRegisterPressed = true;
                      });
                    },
                    onTapUp: (_) {
                      setState(() {
                        isRegisterPressed = false;
                      });
                    },
                    onTapCancel: () {
                      setState(() {
                        isRegisterPressed = false;
                      });
                    },
                    child: Text(
                      'Register now',
                      style: TextStyle(
                        color:
                            isRegisterPressed
                                ? Theme.of(context)
                                    .colorScheme
                                    .primary // Color when pressed
                                : Theme.of(context).colorScheme.inversePrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Clean up controllers when the widget is disposed
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
