import 'package:flutter/material.dart';

/// A reusable placeholder widget that displays a centered message and an
/// optional icon.
///
/// This widget is useful for showing a message when a list is empty or when
/// there is no data to display.
class EmptyPlaceholder extends StatelessWidget {
  /// The message to be displayed.
  final String message;

  /// An optional icon to be displayed above the message.
  final IconData? icon;

  /// The size of the icon.
  final double iconSize;

  /// The color of the icon.
  final Color? iconColor;

  /// Creates an instance of [EmptyPlaceholder].
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
