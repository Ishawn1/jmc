import 'package:flutter/material.dart';
// Removed AppLocalizations import as it's no longer directly used here
import '../../../constants/colors.dart'; // Import colors
import '../../../models/service_item.dart'; // Import the model
import '../../../utils/localization_utils.dart'; // Import the shared helper

/// A widget representing a single item in the services grid.
/// Displays an icon and a label, intended to be placed directly on the background.
class ServiceGridItem extends StatelessWidget {
  final ServiceItem item;
  final VoidCallback onTap; // Callback function when tapped

  const ServiceGridItem({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // final l10n = AppLocalizations.of(context)!; // Removed unused variable
    final textTheme = Theme.of(context).textTheme;
    // Use the shared helper function
    final localizedServiceName = getLocalizedServiceName(context, item.id);

    // Removed Card, using InkWell directly for tap feedback
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.0), // Optional: Add ripple effect radius
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            item.icon,
            size: 36.0,
            // Use theme's primary color for the icon
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              localizedServiceName, // Use localized name
              textAlign: TextAlign.center,
              // Remove hardcoded color, rely on theme's default labelMedium color
              style: textTheme.labelMedium,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}
