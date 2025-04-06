import 'package:flutter/material.dart';

// --- MOCK DATA ---
// Replace with actual update/notification data later
final List<Map<String, String>> mockUpdates = [
  {'title': 'Water Supply Interruption', 'subtitle': 'Scheduled maintenance on 10th April in Zone A.', 'date': 'April 5'},
  {'title': 'Property Tax Deadline Extended', 'subtitle': 'The deadline for property tax payment is now May 15th.', 'date': 'April 4'},
  {'title': 'New Park Inauguration', 'subtitle': 'Join us for the opening of the new community park on April 12th.', 'date': 'April 3'},
  {'title': 'Road Closure Notice', 'subtitle': 'Main Street will be closed for repairs from April 8th to 10th.', 'date': 'April 2'},
  {'title': 'Waste Collection Schedule Change', 'subtitle': 'New schedule effective from April 15th. Check website for details.', 'date': 'April 1'},
];
// --- END MOCK DATA ---

/// Displays a list of recent updates or notifications.
class UpdatesListScreen extends StatelessWidget {
  const UpdatesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: mockUpdates.length,
      itemBuilder: (context, index) {
        final update = mockUpdates[index];
        return Card( // Wrap ListTile in a Card for better visual separation
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: ListTile(
            leading: const Icon(Icons.notifications_active), // Example icon
            title: Text(update['title'] ?? 'No Title'),
            subtitle: Text(update['subtitle'] ?? ''),
            trailing: Text(
              update['date'] ?? '',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            onTap: () {
              // Placeholder action: Show details or navigate
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Tapped on: ${update['title']}')),
              );
            },
          ),
        );
      },
    );
  }
}
