import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/button_hover_provider.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String text;

  const MyButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ButtonHoverProvider(),
      child: Consumer<ButtonHoverProvider>(
        builder: (context, hoverProvider, child) {
          return MouseRegion(
            // Change cursor to pointer when hovering
            cursor: SystemMouseCursors.click,

            // Track when mouse enters
            onEnter: (_) => hoverProvider.onEnter(),

            // Track when mouse exits
            onExit: (_) => hoverProvider.onExit(),

            child: GestureDetector(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.all(25),
                margin: const EdgeInsets.symmetric(horizontal: 25),
                decoration: BoxDecoration(
                  // Change color based on hover state
                  color:
                      hoverProvider.isHovered
                          ? Colors.grey[400]
                          : Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
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
