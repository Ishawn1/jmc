import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import generated localizations
import '../../../widgets/empty_placeholder.dart'; // Use the reusable placeholder

/// Placeholder screen for map-related features.
///
/// Actual map integration (e.g., using google_maps_flutter)
/// will be implemented later.
class MapsScreen extends StatelessWidget {
  const MapsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!; // Get localizations

    // Using the reusable placeholder widget with localized message
    return EmptyPlaceholder(
      message: l10n.mapScreenPlaceholder, // Use localized placeholder text
    );
  }
}
