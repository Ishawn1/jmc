import 'package:flutter/material.dart';
import '../../../utils/url_launcher_util.dart'; // Import the utility

// --- MOCK DATA ---
// Replace with actual downloadable forms/documents later
final List<Map<String, String>> mockDownloads = [
  {'name': 'Property Tax Form (PDF)', 'url': 'https://www.jamnagarcorporation.com/dummy/property_tax_form.pdf', 'icon': 'pdf'},
  {'name': 'Birth Certificate Application (PDF)', 'url': 'https://www.jamnagarcorporation.com/dummy/birth_cert_app.pdf', 'icon': 'pdf'},
  {'name': 'Trade License Renewal Form (DOCX)', 'url': 'https://www.jamnagarcorporation.com/dummy/trade_license_renewal.docx', 'icon': 'doc'},
  {'name': 'Water Connection Application', 'url': 'https://www.jamnagarcorporation.com/dummy/water_connection.pdf', 'icon': 'pdf'},
  {'name': 'Building Plan Approval Guidelines', 'url': 'https://www.jamnagarcorporation.com/dummy/building_guidelines.pdf', 'icon': 'pdf'},
];
// --- END MOCK DATA ---

/// Displays a list of downloadable documents or forms.
class DownloadsListScreen extends StatelessWidget {
  const DownloadsListScreen({super.key});

  // Helper to get an appropriate icon based on file type (simple example)
  IconData _getIconForType(String? iconType) {
    switch (iconType?.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description; // Generic document icon
      default:
        return Icons.download_for_offline; // Default download icon
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: mockDownloads.length,
      itemBuilder: (context, index) {
        final download = mockDownloads[index];
        final String name = download['name'] ?? 'Unnamed File';
        final String? url = download['url'];
        final IconData icon = _getIconForType(download['icon']);

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: ListTile(
            leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
            title: Text(name),
            trailing: const Icon(Icons.download), // Indicate action
            onTap: url == null ? null : () { // Disable tap if URL is missing
              launchURL(url); // Call the utility function
            },
          ),
        );
      },
    );
  }
}
