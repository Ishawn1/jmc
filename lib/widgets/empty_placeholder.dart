import 'package:flutter/material.dart';

/// A simple reusable placeholder widget displaying centered text and optional icon.
class EmptyPlaceholder extends StatelessWidget {
  final String message;
  final IconData? icon;
  final double iconSize;
  final Color? iconColor;

  const EmptyPlaceholder({
    super.key,
    this.message = 'No data available.', // Default message
    this.icon,
    this.iconSize = 80.0,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: iconSize,
                color: iconColor ??
                    theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
              ),
              const SizedBox(height: 24),
            ],
            Text(
              message,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
