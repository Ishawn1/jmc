import 'package:flutter/material.dart';
import '../../../models/service_item.dart'; // Import the model

/// Displays details for a selected service.
class ServiceDetailScreen extends StatelessWidget {
  final ServiceItem serviceItem;

  const ServiceDetailScreen({super.key, required this.serviceItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(serviceItem.name), // Use service name in AppBar
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
                'Service Name:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                serviceItem.name,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 20),
              Text(
                'Service ID:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                serviceItem.id,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 20),
              // Add more details or actions related to the service here
              const Text(
                '(Further details or actions for this service will go here)',
                style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
