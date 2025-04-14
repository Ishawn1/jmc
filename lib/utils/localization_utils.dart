import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import generated localizations

/// Gets the localized service name based on its ID/key.
///
/// This function maps service IDs to their corresponding localization keys
/// defined in the .arb files.
String getLocalizedServiceName(BuildContext context, String serviceId) {
  // Ensure AppLocalizations is available, handle null case gracefully if needed
  final l10n = AppLocalizations.of(context);
  if (l10n == null) {
    // Fallback if localizations are not loaded (should not happen in normal flow)
    return serviceId;
  }

  switch (serviceId) {
    // Existing cases from service_grid_item.dart
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
    // New keys added during data setup
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
