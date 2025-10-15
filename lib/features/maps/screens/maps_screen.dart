import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import generated localizations
import '../../../widgets/empty_placeholder.dart'; // Use the reusable placeholder

/// A placeholder screen for map-related features.
///
/// This screen is intended to be replaced with a full map integration in a
/// future update. Currently, it displays a placeholder message.
class MapsScreen extends StatelessWidget {
  /// Creates an instance of [MapsScreen].
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
