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
  const ServiceItem(id: 'serviceNamePropTaxWaterPay', name: 'Property Tax / Water Charges (Online Payment)', icon: Icons.receipt_long, category: catTax), // ID Updated
  const ServiceItem(id: 'serviceNameProfTaxPayCert', name: 'Professional Tax (Online Payment & Certificate)', icon: Icons.work_history, category: catTax), // ID Updated, Changed icon
  const ServiceItem(id: 'serviceNamePropTaxApp', name: 'Property Tax Application (Application)', icon: Icons.description, category: catTax), // ID Updated

  // Certificate Services
  const ServiceItem(id: 'birth_cert', name: 'Birth Certificate', icon: Icons.cake, category: catCertificate), // ID Updated
  const ServiceItem(id: 'death_cert', name: 'Death Certificate', icon: Icons.book_online, category: catCertificate), // ID Updated, Changed icon
  const ServiceItem(id: 'serviceNameMarriageCert', name: 'Marriage Certificate', icon: Icons.family_restroom, category: catCertificate), // ID Updated
  const ServiceItem(id: 'serviceNameFoodCert', name: 'Food Certificate', icon: Icons.restaurant, category: catCertificate), // ID Updated
  const ServiceItem(id: 'serviceNameShopEstCert', name: 'Shop & Establishment Certificate', icon: Icons.store, category: catCertificate), // ID Updated
  const ServiceItem(id: 'serviceNameFactoryLicenseCert', name: 'Factory License Certificate', icon: Icons.factory, category: catCertificate), // ID Updated
  const ServiceItem(id: 'serviceNameProfTaxCert', name: 'Professional Tax Certificate', icon: Icons.badge, category: catCertificate), // ID Updated, Changed icon

  // Application Services
  const ServiceItem(id: 'serviceNameAppOnline', name: 'Online Application', icon: Icons.web, category: catApplication), // ID Updated
  const ServiceItem(id: 'serviceNameAppCheckStatus', name: 'Check Application Status', icon: Icons.search_sharp, category: catApplication), // ID Updated, Changed icon
  const ServiceItem(id: 'serviceNameAppDevPermission', name: 'Development Permission Application', icon: Icons.construction, category: catApplication), // ID Updated, Changed icon
  const ServiceItem(id: 'serviceNameAppFactoryLicense', name: 'Factory License Application', icon: Icons.factory, category: catApplication), // ID Updated

  // Other Services/Information
  const ServiceItem(id: 'serviceNameOtherDevCollectPay', name: 'Development Collection Charges (Online Payment)', icon: Icons.payment, category: catOther), // ID Updated
  const ServiceItem(id: 'serviceNameOtherWaterMeterPay', name: 'Water Meter Charges (Online Payment)', icon: Icons.water_damage, category: catOther), // ID Updated, Changed icon
  const ServiceItem(id: 'complaint', name: 'Complaints (Others)', icon: Icons.report_problem, category: catOther), // ID Updated (maps to File Complaint)
  const ServiceItem(id: 'serviceNameOtherHospitalUser', name: 'Hospital User (Others)', icon: Icons.local_hospital, category: catOther), // ID Updated
  const ServiceItem(id: 'serviceNameOtherArchEngLogin', name: 'Architecture/Engineer Login (Others)', icon: Icons.engineering, category: catOther), // ID Updated
  const ServiceItem(id: 'serviceNameOtherTownPlanning', name: 'For Town Planning (Others)', icon: Icons.map, category: catOther), // ID Updated
  const ServiceItem(id: 'serviceNameOtherVendorReg', name: 'Vendor Registration (Others)', icon: Icons.person_add, category: catOther), // ID Updated
  const ServiceItem(id: 'serviceNameOtherVehicleDealer', name: 'Vehicle Dealer (Others)', icon: Icons.directions_car, category: catOther), // ID Updated
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
