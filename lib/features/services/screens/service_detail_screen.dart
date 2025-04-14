import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import generated localizations
import '../../../models/service_item.dart'; // Import the model
import '../../../utils/localization_utils.dart'; // Import the shared helper

// Removed the duplicate helper function and TODO comment

/// Displays details for a selected service.
class ServiceDetailScreen extends StatelessWidget {
  final ServiceItem serviceItem;

  const ServiceDetailScreen({super.key, required this.serviceItem});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!; // Get localizations
    // Use the same helper as ServiceGridItem to get localized name
    // Use the shared helper function
    final localizedServiceName = getLocalizedServiceName(context, serviceItem.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizedServiceName), // Use localized service name
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // Align content to top
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                serviceItem.icon,
                size: 60.0,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 20),
              Text(
                l10n.serviceDetailNameLabel, // Use localized label
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                localizedServiceName, // Use localized name
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 20),
              Text(
                l10n.serviceDetailIdLabel, // Use localized label
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                serviceItem.id,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 20),
              // Add more details or actions related to the service here
              Text(
                l10n.serviceDetailPlaceholder, // Use localized placeholder
                style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
