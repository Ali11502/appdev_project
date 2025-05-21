import 'package:flutter/material.dart';

class MyButton extends StatefulWidget {
  final Function()? onTap;
  final String text;

  const MyButton({super.key, required this.text, required this.onTap});

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  // Track hover state
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      // Change cursor to pointer when hovering
      cursor: SystemMouseCursors.click,

      // Track when mouse enters
      onEnter: (_) {
        setState(() {
          isHovered = true;
        });
      },

      // Track when mouse exits
      onExit: (_) {
        setState(() {
          isHovered = false;
        });
      },

      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.all(25),
          margin: const EdgeInsets.symmetric(horizontal: 25),
          decoration: BoxDecoration(
            // Change color based on hover state
            color:
                isHovered
                    ? Colors.grey[400]
                    : Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              widget.text,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
