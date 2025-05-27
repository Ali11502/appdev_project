import '../models/food.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/button_hover_provider.dart';

class FoodTile extends StatelessWidget {
  final Food food;
  final void Function()? onTap;
  const FoodTile({super.key, required this.food, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ButtonHoverProvider(),
      child: Consumer<ButtonHoverProvider>(
        builder: (context, hoverProvider, child) {
          return MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => hoverProvider.onEnter(),
            onExit: (_) => hoverProvider.onExit(),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              // Lift effect with transform
              transform:
                  Matrix4.identity()
                    ..translate(0.0, hoverProvider.isHovered ? -4.0 : 0.0),
              // Enhanced shadow and glow effect
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(12),
                boxShadow:
                    hoverProvider.isHovered
                        ? [
                          // Glow effect
                          BoxShadow(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.3),
                            blurRadius: 20,
                            spreadRadius: 2,
                            offset: const Offset(0, 8),
                          ),
                          // Additional depth shadow
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 15,
                            spreadRadius: 1,
                            offset: const Offset(0, 6),
                          ),
                        ]
                        : [
                          // Default subtle shadow
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                            spreadRadius: 0,
                            offset: const Offset(0, 2),
                          ),
                        ],
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: onTap,
                    child: Container(
                      // Make the container transparent to allow the outer container's decoration to show
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          children: [
                            // text food details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    food.name,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      // Slight color change on hover
                                      color:
                                          hoverProvider.isHovered
                                              ? Theme.of(
                                                context,
                                              ).colorScheme.inversePrimary
                                              : Theme.of(
                                                context,
                                              ).colorScheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '\$${food.price.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    food.description,
                                    style: TextStyle(
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.inversePrimary,
                                      fontSize: 14,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 15),
                            // Enhanced image container with hover effect
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                boxShadow:
                                    hoverProvider.isHovered
                                        ? [
                                          BoxShadow(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary
                                                .withValues(alpha: 0.2),
                                            blurRadius: 10,
                                            spreadRadius: 1,
                                            offset: const Offset(0, 4),
                                          ),
                                        ]
                                        : [
                                          BoxShadow(
                                            color: Colors.black.withValues(
                                              alpha: 0.1,
                                            ),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  food.imagePath,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    // Fallback widget if image fails to load
                                    return Container(
                                      width: 100,
                                      height: 100,
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                      child: Icon(
                                        Icons.image_not_supported,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withValues(alpha: 0.5),
                                        size: 40,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    color: Theme.of(context).colorScheme.surface,
                    thickness: 3,
                    height: 1,
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
