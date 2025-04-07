import 'package:flutter/material.dart';
import '../../../models/service_item.dart';
import '../widgets/service_grid_item.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import generated localizations
import '../../../constants/colors.dart'; // Import colors for styling
import 'service_detail_screen.dart'; // To navigate to detail screen

// --- SERVICE DATA (Based on instructionforcline.txt) ---
// Categories defined based on the structure in the instructions file
const String catTax = 'Tax Services';
const String catCertificate = 'Certificate Services';
const String catApplication = 'Application Services';
const String catOther = 'Other Services/Information';

final List<ServiceItem> serviceItems = [
  // Tax Services
  const ServiceItem(id: 'tax_prop_water_pay', name: 'Property Tax / Water Charges (Online Payment)', icon: Icons.receipt_long, category: catTax),
  const ServiceItem(id: 'tax_prof_pay_cert', name: 'Professional Tax (Online Payment & Certificate)', icon: Icons.work_history, category: catTax), // Changed icon
  const ServiceItem(id: 'tax_prop_app', name: 'Property Tax Application (Application)', icon: Icons.description, category: catTax),

  // Certificate Services
  const ServiceItem(id: 'cert_birth', name: 'Birth Certificate', icon: Icons.cake, category: catCertificate),
  const ServiceItem(id: 'cert_death', name: 'Death Certificate', icon: Icons.book_online, category: catCertificate), // Changed icon
  const ServiceItem(id: 'cert_marriage', name: 'Marriage Certificate', icon: Icons.family_restroom, category: catCertificate),
  const ServiceItem(id: 'cert_food', name: 'Food Certificate', icon: Icons.restaurant, category: catCertificate),
  const ServiceItem(id: 'cert_shop_est', name: 'Shop & Establishment Certificate', icon: Icons.store, category: catCertificate),
  const ServiceItem(id: 'cert_factory_license', name: 'Factory License Certificate', icon: Icons.factory, category: catCertificate),
  const ServiceItem(id: 'cert_prof_tax', name: 'Professional Tax Certificate', icon: Icons.badge, category: catCertificate), // Changed icon

  // Application Services
  const ServiceItem(id: 'app_online', name: 'Online Application', icon: Icons.web, category: catApplication),
  const ServiceItem(id: 'app_check_status', name: 'Check Application Status', icon: Icons.search_sharp, category: catApplication), // Changed icon
  const ServiceItem(id: 'app_dev_permission', name: 'Development Permission Application', icon: Icons.construction, category: catApplication), // Changed icon
  const ServiceItem(id: 'app_factory_license', name: 'Factory License Application', icon: Icons.factory, category: catApplication),

  // Other Services/Information
  const ServiceItem(id: 'other_dev_collect_pay', name: 'Development Collection Charges (Online Payment)', icon: Icons.payment, category: catOther),
  const ServiceItem(id: 'other_water_meter_pay', name: 'Water Meter Charges (Online Payment)', icon: Icons.water_damage, category: catOther), // Changed icon
  const ServiceItem(id: 'other_complaints', name: 'Complaints (Others)', icon: Icons.report_problem, category: catOther),
  const ServiceItem(id: 'other_hospital_user', name: 'Hospital User (Others)', icon: Icons.local_hospital, category: catOther),
  const ServiceItem(id: 'other_arch_eng_login', name: 'Architecture/Engineer Login (Others)', icon: Icons.engineering, category: catOther),
  const ServiceItem(id: 'other_town_planning', name: 'For Town Planning (Others)', icon: Icons.map, category: catOther),
  const ServiceItem(id: 'other_vendor_reg', name: 'Vendor Registration (Others)', icon: Icons.person_add, category: catOther),
  const ServiceItem(id: 'other_vehicle_dealer', name: 'Vehicle Dealer (Others)', icon: Icons.directions_car, category: catOther),
];

// Filter category keys based on the new categories
// These keys need corresponding entries in app_en.arb etc.
final List<String> filterCategoryKeys = [
  'servicesFilterChipAll', // Keep "All"
  'servicesFilterChipTax',
  'servicesFilterChipCertificate',
  'servicesFilterChipApplication',
  'servicesFilterChipOther',
];
// --- END SERVICE DATA ---

// Helper function to get localized category name
String _getLocalizedCategoryName(BuildContext context, String categoryKey) {
  final l10n = AppLocalizations.of(context)!;
  // Map keys to localization strings (ensure these exist in your .arb files)
  switch (categoryKey) {
    case 'servicesFilterChipAll': return l10n.servicesFilterChipAll;
    // TODO: Add these keys to app_en.arb and other localization files
    case 'servicesFilterChipTax': return l10n.servicesFilterChipTax ?? 'Tax Services';
    case 'servicesFilterChipCertificate': return l10n.servicesFilterChipCertificate ?? 'Certificate Services';
    case 'servicesFilterChipApplication': return l10n.servicesFilterChipApplication ?? 'Application Services';
    case 'servicesFilterChipOther': return l10n.servicesFilterChipOther ?? 'Other Services';
    default: return categoryKey; // Fallback
  }
}

// Helper function to get the English category name from the key for filtering
String _getEnglishCategoryNameFromKey(String categoryKey) {
  switch (categoryKey) {
    // Map keys back to the English category names used in the ServiceItem model
    case 'servicesFilterChipTax': return catTax;
    case 'servicesFilterChipCertificate': return catCertificate;
    case 'servicesFilterChipApplication': return catApplication;
    case 'servicesFilterChipOther': return catOther;
    default: return ''; // For 'All' or invalid keys
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
      return serviceItems; // Use the new serviceItems list
    }

    // Get the English category name corresponding to the selected key
    final englishCategoryToFilter = _getEnglishCategoryNameFromKey(_selectedCategoryKey);

    // Filter based on the English category name stored in the ServiceItem model
    return serviceItems // Use the new serviceItems list
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
              // Use updated category keys for mapping
              children: filterCategoryKeys.map((categoryKey) {
                final isSelected = categoryKey == _selectedCategoryKey;
                // Get localized label with fallback
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
                // Use selected category name as header, or "All Services" if 'All' is selected
                _selectedCategoryKey == 'servicesFilterChipAll'
                    ? l10n.servicesHeader // "All Services"
                    : _getLocalizedCategoryName(context, _selectedCategoryKey),
                style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              // Keep the filter/sort icon for potential future use, but it's not functional now
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
