import 'package:flutter/material.dart';

/// Animated heart button that toggles between filled and outlined states.
class FavoriteButton extends StatelessWidget {
  const FavoriteButton({
    required this.isFavorite,
    required this.onTap,
    super.key,
  });

  final bool isFavorite;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return IconButton(
      onPressed: onTap,
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (child, animation) =>
            ScaleTransition(scale: animation, child: child),
        child: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          key: ValueKey(isFavorite),
          color: isFavorite ? colorScheme.error : colorScheme.onSurfaceVariant,
          size: 28,
        ),
      ),
    );
  }
}
