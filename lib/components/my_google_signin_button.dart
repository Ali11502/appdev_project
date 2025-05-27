import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/button_hover_provider.dart';

class MyGoogleSignInButton extends StatelessWidget {
  final Function()? onTap;
  final bool isLoading;

  const MyGoogleSignInButton({
    super.key,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ButtonHoverProvider(),
      child: Consumer<ButtonHoverProvider>(
        builder: (context, hoverProvider, child) {
          return MouseRegion(
            // Change cursor to pointer when hovering
            cursor:
                isLoading ? SystemMouseCursors.basic : SystemMouseCursors.click,

            // Track when mouse enters
            onEnter: (_) => hoverProvider.onEnter(),

            // Track when mouse exits
            onExit: (_) => hoverProvider.onExit(),

            child: GestureDetector(
              onTap: isLoading ? null : onTap,
              child: Container(
                // Outer container for gradient border
                margin: const EdgeInsets.symmetric(horizontal: 25),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF4285F4), // Blue
                      Color(0xFF34A853), // Green
                      Color(0xFFFBBC05), // Yellow
                      Color(0xFFEA4335), // Red
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(25),
                  margin: const EdgeInsets.all(2), // Space for gradient border
                  decoration: BoxDecoration(
                    // Same color logic as MyButton, but for Google button background
                    color:
                        isLoading
                            ? Theme.of(context)
                                .colorScheme
                                .secondary // Loading state
                            : hoverProvider.isHovered
                            ? Colors.grey[400] // Same hover color as MyButton
                            : Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(
                      6,
                    ), // Slightly smaller to account for border
                  ),
                  child: Center(
                    child:
                        isLoading
                            ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Signing in...',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            )
                            : const Text(
                              'Sign in with Google',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
