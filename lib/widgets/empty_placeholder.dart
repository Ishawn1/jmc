import 'package:flutter/material.dart';

/// A simple reusable placeholder widget displaying centered text.
class EmptyPlaceholder extends StatelessWidget {
  final String message;

  const EmptyPlaceholder({
    super.key,
    this.message = 'No data available.', // Default message
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey[600], // Optional: Style the text
            ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
