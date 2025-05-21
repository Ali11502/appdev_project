import 'package:app_dev_project/services/auth/auth_service.dart';

import 'package:flutter/material.dart';

import '../components/my_button.dart';
import '../components/my_text_field.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Controllers to handle text input
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  void register() async {
    final _authService = AuthService();
    // check if passwords match -> create user
    if (passwordController.text == confirmPasswordController.text) {
      // try creating user
      try {
        await _authService.signUpWithEmailPassword(
          emailController.text,
          passwordController.text,
        );
      }
      // display any errors
      catch (e) {
        showDialog(
          context: context,
          builder:
              (context) =>
                  AlertDialog(title: Text(e.toString())), // AlertDialog
        );
      }
    }
    // if passwords don't match -> show error
    else {
      showDialog(
        context: context,
        builder:
            (context) =>
                const AlertDialog(title: Text("Passwords don't match")),
      );
    }
  }

  // Variable to track whether login text is being pressed
  bool isLoginPressed = false;

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
              "Let's create an account",
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

            // confirm Password input field
            MyTextField(
              controller: confirmPasswordController,
              hintText: "Confirm password",
              obscureText: true,
            ),
            const SizedBox(height: 10),

            // Sign up button
            MyButton(text: 'Sign up', onTap: register),

            const SizedBox(height: 25),

            // already have an account?
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account?',
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
                        isLoginPressed = true;
                      });
                    },
                    onTapUp: (_) {
                      setState(() {
                        isLoginPressed = false;
                      });
                    },
                    onTapCancel: () {
                      setState(() {
                        isLoginPressed = false;
                      });
                    },
                    child: Text(
                      'Login now',
                      style: TextStyle(
                        color:
                            isLoginPressed
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

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
