import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import generated localizations
import '../../../constants/colors.dart'; // Import colors
import '../../../models/service_item.dart'; // Import the model

// Helper function to get localized service name based on ID/key
String _getLocalizedServiceName(BuildContext context, String serviceId) {
  final l10n = AppLocalizations.of(context)!;
  switch (serviceId) {
    case 'prop_tax': return l10n.serviceNamePropertyTax;
    case 'water_bill': return l10n.serviceNameWaterBill;
    case 'birth_cert': return l10n.serviceNameBirthCertificate;
    case 'death_cert': return l10n.serviceNameDeathCertificate;
    case 'trade_license': return l10n.serviceNameTradeLicense;
    case 'complaint': return l10n.serviceNameFileComplaint;
    case 'feedback': return l10n.serviceNameFeedback;
    case 'contact_us': return l10n.serviceNameContactUs;
    case 'public_grievance': return l10n.serviceNamePublicGrievance;
    case 'fire_dept': return l10n.serviceNameFireDepartment;
    case 'ambulance': return l10n.serviceNameAmbulance;
    default: return serviceId; // Fallback to ID if no match
  }
}

/// A widget representing a single item in the services grid.
/// Displays an icon and a label, intended to be placed directly on the background.
class ServiceGridItem extends StatelessWidget {
  final ServiceItem item;
  final VoidCallback onTap; // Callback function when tapped

  const ServiceGridItem({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!; // Get localizations
    final textTheme = Theme.of(context).textTheme;
    final localizedServiceName = _getLocalizedServiceName(context, item.id); // Get localized name

    // Removed Card, using InkWell directly for tap feedback
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.0), // Optional: Add ripple effect radius
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            item.icon,
            size: 36.0, // Slightly smaller icon size might look better without card
            color: jmcIconColor, // Use the defined medium blue icon color
          ),
          const SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              localizedServiceName, // Use localized name
              textAlign: TextAlign.center,
              // Use a slightly more prominent style like labelMedium
              style: textTheme.labelMedium?.copyWith(color: jmcPrimaryTextColor),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}
