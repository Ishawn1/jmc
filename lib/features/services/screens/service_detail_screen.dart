import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import generated localizations
import '../../../models/service_item.dart'; // Import the model
// Removed import for service_grid_item.dart as we copy the helper function
// import '../widgets/service_grid_item.dart';

// Helper function copied from service_grid_item.dart
// TODO: Consider moving this to a shared utility file for better code organization
String _getLocalizedServiceName(BuildContext context, String serviceId) {
  final l10n = AppLocalizations.of(context)!;
  switch (serviceId) {
    // Keep existing cases from service_grid_item.dart
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


/// Displays details for a selected service.
class ServiceDetailScreen extends StatelessWidget {
  final ServiceItem serviceItem;

  const ServiceDetailScreen({super.key, required this.serviceItem});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!; // Get localizations
    // Use the same helper as ServiceGridItem to get localized name
    // Note: This assumes _getLocalizedServiceName is accessible or moved to a shared location.
    // If not, we need to duplicate or refactor it. For now, assume it's accessible via import.
    // A better approach might be to pass the localized name from the list screen.
    final localizedServiceName = _getLocalizedServiceName(context, serviceItem.id);

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
