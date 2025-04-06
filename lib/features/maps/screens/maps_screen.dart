import 'package:flutter/material.dart';
import '../../../widgets/empty_placeholder.dart'; // Use the reusable placeholder

/// Placeholder screen for map-related features.
///
/// Actual map integration (e.g., using google_maps_flutter)
/// will be implemented later.
class MapsScreen extends StatelessWidget {
  const MapsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Using the reusable placeholder widget
    return const EmptyPlaceholder(
      message: 'Map View Placeholder\n(Integration pending)',
    );
  }
}
