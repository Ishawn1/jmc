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
    // Add cases for the new keys
    case 'serviceNamePropTaxWaterPay': return l10n.serviceNamePropTaxWaterPay;
    case 'serviceNameProfTaxPayCert': return l10n.serviceNameProfTaxPayCert;
    case 'serviceNamePropTaxApp': return l10n.serviceNamePropTaxApp;
    case 'serviceNameMarriageCert': return l10n.serviceNameMarriageCert;
    case 'serviceNameFoodCert': return l10n.serviceNameFoodCert;
    case 'serviceNameShopEstCert': return l10n.serviceNameShopEstCert;
    case 'serviceNameFactoryLicenseCert': return l10n.serviceNameFactoryLicenseCert;
    case 'serviceNameProfTaxCert': return l10n.serviceNameProfTaxCert;
    case 'serviceNameAppOnline': return l10n.serviceNameAppOnline;
    case 'serviceNameAppCheckStatus': return l10n.serviceNameAppCheckStatus;
    case 'serviceNameAppDevPermission': return l10n.serviceNameAppDevPermission;
    case 'serviceNameAppFactoryLicense': return l10n.serviceNameAppFactoryLicense;
    case 'serviceNameOtherDevCollectPay': return l10n.serviceNameOtherDevCollectPay;
    case 'serviceNameOtherWaterMeterPay': return l10n.serviceNameOtherWaterMeterPay;
    case 'serviceNameOtherHospitalUser': return l10n.serviceNameOtherHospitalUser;
    case 'serviceNameOtherArchEngLogin': return l10n.serviceNameOtherArchEngLogin;
    case 'serviceNameOtherTownPlanning': return l10n.serviceNameOtherTownPlanning;
    case 'serviceNameOtherVendorReg': return l10n.serviceNameOtherVendorReg;
    case 'serviceNameOtherVehicleDealer': return l10n.serviceNameOtherVehicleDealer;
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
