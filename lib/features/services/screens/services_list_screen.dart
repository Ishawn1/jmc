import 'package:flutter/material.dart';
import '../../../models/service_item.dart';
import '../widgets/service_grid_item.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import generated localizations
import '../../../constants/colors.dart'; // Import colors for styling
import 'service_detail_screen.dart'; // To navigate to detail screen

// --- MOCK DATA ---
// Replace these with actual services and categories later
final List<ServiceItem> mockServiceItems = [
  const ServiceItem(id: 'prop_tax', name: 'Property Tax', icon: Icons.house_rounded, category: 'Taxes'),
  const ServiceItem(id: 'water_bill', name: 'Water Bill', icon: Icons.water_drop, category: 'Bills'),
  const ServiceItem(id: 'birth_cert', name: 'Birth Certificate', icon: Icons.cake, category: 'Certificates'),
  const ServiceItem(id: 'death_cert', name: 'Death Certificate', icon: Icons.book, category: 'Certificates'),
  const ServiceItem(id: 'trade_license', name: 'Trade License', icon: Icons.store, category: 'Licenses'),
  const ServiceItem(id: 'complaint', name: 'File Complaint', icon: Icons.report_problem, category: 'Grievance'),
  const ServiceItem(id: 'feedback', name: 'Feedback', icon: Icons.feedback, category: 'Grievance'),
  const ServiceItem(id: 'contact_us', name: 'Contact Us', icon: Icons.contact_phone, category: 'Info'),
  const ServiceItem(id: 'public_grievance', name: 'Public Grievance', icon: Icons.group, category: 'Grievance'),
  const ServiceItem(id: 'fire_dept', name: 'Fire Department', icon: Icons.local_fire_department, category: 'Emergency Services'),
  const ServiceItem(id: 'ambulance', name: 'Ambulance', icon: Icons.emergency, category: 'Emergency Services'),
];

// Mock filter categories (These keys will be used to look up localized strings)
final List<String> filterCategoryKeys = [
  'servicesFilterChipAll',
  'servicesFilterChipGrievance',
  'servicesFilterChipCertificates',
  'servicesFilterChipEmergency',
  'servicesFilterChipBills',
  'servicesFilterChipTaxes',
  'servicesFilterChipLicenses',
  'servicesFilterChipInfo',
];
// --- END MOCK DATA ---

// Helper function to get localized category name
String _getLocalizedCategoryName(BuildContext context, String categoryKey) {
  final l10n = AppLocalizations.of(context)!;
  switch (categoryKey) {
    case 'servicesFilterChipAll': return l10n.servicesFilterChipAll; // "All"
    case 'servicesFilterChipGrievance': return l10n.servicesFilterChipGrievance; // "Grievance"
    case 'servicesFilterChipCertificates': return l10n.servicesFilterChipCertificates; // "Certificates"
    case 'servicesFilterChipEmergency': return l10n.servicesFilterChipEmergency; // "Emergency Services"
    case 'servicesFilterChipBills': return l10n.servicesFilterChipBills; // "Bills"
    case 'servicesFilterChipTaxes': return l10n.servicesFilterChipTaxes; // "Taxes"
    case 'servicesFilterChipLicenses': return l10n.servicesFilterChipLicenses; // "Licenses"
    case 'servicesFilterChipInfo': return l10n.servicesFilterChipInfo; // "Info"
    default: return categoryKey; // Fallback
  }
}

// Helper function to get the English category name from the key
String _getEnglishCategoryNameFromKey(String categoryKey) {
  switch (categoryKey) {
    // Map keys back to the English names used in the mock data model
    case 'servicesFilterChipGrievance': return 'Grievance';
    case 'servicesFilterChipCertificates': return 'Certificates';
    case 'servicesFilterChipEmergency': return 'Emergency Services';
    case 'servicesFilterChipBills': return 'Bills';
    case 'servicesFilterChipTaxes': return 'Taxes';
    case 'servicesFilterChipLicenses': return 'Licenses';
    case 'servicesFilterChipInfo': return 'Info';
    default: return ''; // Should not happen for valid keys other than 'All'
  }
}

/// Displays a grid of available municipal services with filtering.
class ServicesListScreen extends StatefulWidget {
  const ServicesListScreen({super.key});

  @override
  State<ServicesListScreen> createState() => _ServicesListScreenState();
}

class _ServicesListScreenState extends State<ServicesListScreen> {
  // Store the key of the selected category
  String _selectedCategoryKey = 'servicesFilterChipAll';

  // Filter the services based on the selected category
  List<ServiceItem> get _filteredServiceItems {
    if (_selectedCategoryKey == 'servicesFilterChipAll') {
      return mockServiceItems; // Return all if 'All' is selected
    }

    // Get the English category name corresponding to the selected key
    final englishCategoryToFilter = _getEnglishCategoryNameFromKey(_selectedCategoryKey);

    // Filter based on the English category name stored in the ServiceItem model
    return mockServiceItems
        .where((item) => item.category == englishCategoryToFilter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!; // Get localizations object
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- Filter Chips Row ---
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              // Use category keys for mapping
              children: filterCategoryKeys.map((categoryKey) {
                final isSelected = categoryKey == _selectedCategoryKey;
                final localizedLabel = _getLocalizedCategoryName(context, categoryKey);
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: FilterChip(
                    label: Text(localizedLabel), // Use localized label
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedCategoryKey = categoryKey; // Update selected key
                        });
                      }
                    },
                    // Basic MD3 styling
                    selectedColor: jmcPrimaryAccent.withOpacity(0.12),
                    checkmarkColor: jmcPrimaryAccent,
                    labelStyle: TextStyle(
                      color: isSelected ? jmcPrimaryAccent : jmcSecondaryTextColor,
                    ),
                    side: isSelected
                        ? BorderSide.none
                        : BorderSide(color: Colors.grey.shade400),
                  ),
                );
              }).toList(),
            ),
          ),
        ),

        // --- "All Services" Header ---
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.servicesHeader, // Use localized header
                style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.filter_list, color: jmcUnselectedColor),
                tooltip: l10n.servicesFilterSortTooltip, // Use localized tooltip
                onPressed: () {
                  // Placeholder for filter/sort action
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.servicesFilterSortSnackbar)), // Use localized snackbar text
                  );
                },
              ),
            ],
          ),
        ),

        // --- Services Grid ---
        Expanded( // Use Expanded to make GridView fill remaining space
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // Number of columns
              crossAxisSpacing: 8.0, // Reduced spacing
              mainAxisSpacing: 8.0, // Reduced spacing
              childAspectRatio: 1.0, // Adjust aspect ratio (width/height) if needed
            ),
            padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0), // Adjusted padding
            itemCount: _filteredServiceItems.length,
            itemBuilder: (context, index) {
              final item = _filteredServiceItems[index];
              return ServiceGridItem(
                item: item,
                onTap: () {
                  // Navigate to the detail screen, passing the selected service item
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ServiceDetailScreen(serviceItem: item),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
