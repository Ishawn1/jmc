import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import generated localizations
import '../../../utils/url_launcher_util.dart'; // Import the utility
import '../../../constants/colors.dart'; // Import colors for styling
import '../../../widgets/empty_placeholder.dart'; // Import placeholder widget

// --- DATA MODEL ---
class DownloadItem {
  final String name;
  final String category;
  final String url;
  final String? fileType; // e.g., 'pdf', 'doc', 'jpg'

  const DownloadItem({
    required this.name,
    required this.category,
    required this.url,
    this.fileType,
  });

  // Helper to guess file type from URL if not provided
  String get guessedFileType {
    if (fileType != null) return fileType!;
    if (url.toLowerCase().endsWith('.pdf')) return 'pdf';
    if (url.toLowerCase().endsWith('.doc') || url.toLowerCase().endsWith('.docx')) return 'doc';
    if (url.toLowerCase().endsWith('.jpg') || url.toLowerCase().endsWith('.jpeg')) return 'jpg';
    if (url.toLowerCase().endsWith('.png')) return 'png';
    return 'unknown';
  }
}

// --- PARSED DOWNLOAD DATA (from instructionforcline.txt) ---
// Note: Manually parsed and structured based on the provided text file.
final List<DownloadItem> allDownloadItems = [
  // 1. Accounts & Audit
  const DownloadItem(name: 'ANNUAL ACCOUNT YEAR 2018_2019', category: 'Accounts & Audit', url: 'https://www.mcjamnagar.com/jmcForms/Documents/ANNUAL ACCOUNT YEAR 2018_2019_21_18_2018-19_23_24.pdf'),
  const DownloadItem(name: 'ANNUAL AUDIT ACCOUNT YEAR 2019_2020', category: 'Accounts & Audit', url: 'https://www.mcjamnagar.com/jmcForms/Documents/19_20_FINAL.pdf'),
  const DownloadItem(name: 'ANNUAL AUDIT ACCOUNT YEAR 2020_2021', category: 'Accounts & Audit', url: 'https://www.mcjamnagar.com/jmcForms/Documents/20_21_FINAL.pdf'),
  const DownloadItem(name: 'ANNUAL AUDIT ACCOUNT YEAR 2021_2022', category: 'Accounts & Audit', url: 'https://www.mcjamnagar.com/jmcForms/Documents/21_22_FINAL.pdf'),
  const DownloadItem(name: 'INCOME AND EXPENDITURE STATEMENT FOR THE YEAR 2015-16', category: 'Accounts & Audit', url: 'https://www.mcjamnagar.com/jmcForms/Documents/INCOME AND EXPENDITURE STATEMENT FOR THE YEAR 2015-16_21_balancesheet 2016.pdf'),
  const DownloadItem(name: 'INCOME AND EXPENDITURE STATEMENT FOR THE YEAR 2016-17', category: 'Accounts & Audit', url: 'https://www.mcjamnagar.com/jmcForms/Documents/INCOME AND EXPENDITURE STATEMENT FOR THE YEAR 2016-17_21_balancesheet 2017.pdf'),
  const DownloadItem(name: 'INCOME AND EXPENDITURE STATEMENT FOR THE YEAR 2017-18', category: 'Accounts & Audit', url: 'https://www.mcjamnagar.com/jmcForms/Documents/INCOME AND EXPENDITURE STATEMENT FOR THE YEAR 2017-18_21_balancesheet 2018.pdf'),
  const DownloadItem(name: 'INCOME AND EXPENDITURE STATEMENT FOR THE YEAR 2018-19', category: 'Accounts & Audit', url: 'https://www.mcjamnagar.com/jmcForms/Documents/INCOME AND EXPENDITURE STATEMENT FOR THE YEAR 2018-19_21_Receipt & Payment Account 2019.pdf'),
  const DownloadItem(name: 'INCOME AND EXPENDITURE STATEMENT FOR THE YEAR 2019-20', category: 'Accounts & Audit', url: 'https://www.mcjamnagar.com/jmcForms/Documents/INCOME AND EXPENDITURE STATEMENT FOR THE YEAR 2019-20_21_Receipt & Payment Account 2020.pdf'),
  const DownloadItem(name: 'INCOME AND EXPENDITURE STATEMENT FOR THE YEAR 2020-21', category: 'Accounts & Audit', url: 'https://www.mcjamnagar.com/jmcForms/Documents/INCOME AND EXPENDITURE STATEMENT FOR THE YEAR 2020-21_21_Receipt & Payment Account 2021.pdf'),
  const DownloadItem(name: 'INCOME AND EXPENDITURE STATEMENT FOR THE YEAR 2021-22', category: 'Accounts & Audit', url: 'https://www.mcjamnagar.com/jmcForms/Documents/INCOME AND EXPENDITURE STATEMENT FOR THE YEAR 2021-22_21_Receipt & Payment Account 2022.pdf'),
  // 2. Birth & Death Registration
  const DownloadItem(name: 'જન્મ મરણ ના દાખલા માટે નુ ફોર્મ', category: 'Birth & Death Registration', url: 'https://www.mcjamnagar.com/jmcForms/Documents/જન્મ મરણ ના દાખલા માટે નુ ફોર્મ_Birth & Death_RBD.pdf'),
  // 3. Estate (Factory Licence & Advertisement)
  const DownloadItem(name: 'APPLICATION FOR ADVERTISEMENT HOARDINGS', category: 'Estate', url: 'https://www.mcjamnagar.com/jmcForms/Documents/APPLICATION FOR ADVERTISEMENT HOARDINGS_Estate_private_adv_hordings.pdf'),
  const DownloadItem(name: 'Draft Notification-Rules', category: 'Estate', url: 'https://www.mcjamnagar.com/jmcForms/Documents/Draft Notification-Rules_7_Draft Notifiction-Rules-Ex. 584 UD & UH Dept.pdf'),
  const DownloadItem(name: 'FACTORY LICENCE FORM', category: 'Estate', url: 'https://www.mcjamnagar.com/jmcForms/Documents/FACTORY LICENCE FORM_Estate_factory_licence.pdf'),
  const DownloadItem(name: 'FORMS', category: 'Estate', url: 'https://www.mcjamnagar.com/jmcForms/Documents/FORMS_Estate_form.pdf'),
  const DownloadItem(name: 'HANGAMI KHEDUT GRAHAK BAZAR', category: 'Estate', url: 'https://www.mcjamnagar.com/jmcForms/Documents/HANGAMI KHEDUT GRAHAK BAZAR_7_img699.jpg'),
  const DownloadItem(name: 'RULES FOR ADVERTISEMENT HOARDINGS', category: 'Estate', url: 'https://www.mcjamnagar.com/jmcForms/Documents/RULES FOR ADVERTISEMENT HOARDINGS_Estate_rules.pdf'),
  // 4. Fire Safety
  const DownloadItem(name: 'APPLICATION FOR NO OBJECTION CERTIFICATE', category: 'Fire Safety', url: 'https://www.mcjamnagar.com/jmcForms/Documents/APPLICATION FOR NO OBJECTION CERTIFICATE_Fire_Fire_NOC.pdf'),
  const DownloadItem(name: 'APPLI. FOR TEM. FATAKDA CER. & DOC.', category: 'Fire Safety', url: 'https://www.mcjamnagar.com/jmcForms/Documents/APPLI. FOR TEM. FATAKDA CER. & DOC._13_ilovepdf_merged.pdf'),
  const DownloadItem(name: 'Application form for fire NOC', category: 'Fire Safety', url: 'https://www.mcjamnagar.com/jmcForms/Documents/Application form for fire NOC_13_NEW_APPLI_FRM_BAHENH_EFFIDVT_FIRE.doc.pdf'),
  // 5. Food Registration & Licensing
  const DownloadItem(name: 'LICENCE FORM-B (Above Rs 12 lakh turnover For manufacturer and packing)', category: 'Food Registration & Licensing', url: 'https://www.mcjamnagar.com/jmcForms/Documents/LICENCE FORM-B (Above Rs 12 lakh turnover For manufacturer and packing)_32_form B.pdf'),
  const DownloadItem(name: 'REGISTRATION FORM-A (below Rs 12 lakh turnover)', category: 'Food Registration & Licensing', url: 'https://www.mcjamnagar.com/jmcForms/Documents/REGISTRATION FORM-A (below Rs 12 lakh turnover)_32_form-A.pdf'),
  // 6. General Administration
  const DownloadItem(name: 'Recruitment Rules', category: 'General Administration', url: 'https://www.mcjamnagar.com/jmcForms/Documents/Recruitment Rules_23_JMC-Recruitment Rules.pdf'),
  const DownloadItem(name: 'SENIORITY LIST SPORT MANAGER', category: 'General Administration', url: 'https://www.mcjamnagar.com/jmcForms/Documents/SENIORITY LIST SPORT MANAGER_23_sm.pdf'),
  // 7. Health
  const DownloadItem(name: 'BPL SUDHARNAFORM', category: 'Health', url: 'https://www.mcjamnagar.com/jmcForms/Documents/BPL SUDHARNAFORM_Urban Community Development_UCD_BPLSUDHARNAFORM.pdf'),
  const DownloadItem(name: 'MA AMRUTAM ANE MA VATSLY', category: 'Health', url: 'https://www.mcjamnagar.com/jmcForms/Documents/MA AMRUTAM ANE MA VATSLY_Urban Community Development_UCD_MA_AMRUTAM_VATSLY.pdf'),
  const DownloadItem(name: 'RASHTRIY KUTUMB SAHAY YOJNA', category: 'Health', url: 'https://www.mcjamnagar.com/jmcForms/Documents/RASHTRIY KUTUMB SAHAY YOJNA_Urban Community Development_UCD_KUTUMBSAHAY.pdf'),
  const DownloadItem(name: 'TABIBI SAHAY MATE NU FORM', category: 'Health', url: 'https://www.mcjamnagar.com/jmcForms/Documents/TABIBI SAHAY MATE NU FORM_Urban Community Development_UCD_TABIBISAHAY MATE.pdf'),
  // 8. House Tax & Water Tax
  const DownloadItem(name: 'Carpet Rules', category: 'House Tax & Water Tax', url: 'https://www.mcjamnagar.com/jmcForms/Documents/Carpet Rules_Property Tax_CARPETRULES.pdf'),
  const DownloadItem(name: 'Demand Collection Report 2016-17', category: 'House Tax & Water Tax', url: 'https://www.mcjamnagar.com/jmcForms/Documents/Demand Collection Report 2016-17_10_RPT_ACCOUNT_MIS (23).pdf'),
  const DownloadItem(name: 'Demand Collection Report 2017-Till Date', category: 'House Tax & Water Tax', url: 'https://www.mcjamnagar.com/jmcForms/Documents/Demand Collection Report 2017-Till Date_10_RPT_ACCOUNT_MIS (24).pdf'),
  const DownloadItem(name: 'HouseTax Oustanding Upto 31-Mar-2016', category: 'House Tax & Water Tax', url: 'https://www.mcjamnagar.com/jmcForms/Documents/HouseTax Oustanding Upto 31-Mar-2016_10_Outstanding_Upto31032016.pdf'),
  const DownloadItem(name: 'Name Transfer', category: 'House Tax & Water Tax', url: 'https://www.mcjamnagar.com/jmcForms/Documents/Name Transfer_Property Tax_NTF.pdf'),
  const DownloadItem(name: 'SELF ASSESSMENT FORM', category: 'House Tax & Water Tax', url: 'https://www.mcjamnagar.com/jmcForms/Documents/SELF ASSESSMENT FORM_Property Tax_SelfAssessment.pdf'),
  const DownloadItem(name: 'Water Oustanding Upto 31-Mar-2016', category: 'House Tax & Water Tax', url: 'https://www.mcjamnagar.com/jmcForms/Documents/Water Oustanding Upto 31-Mar-2016_10_WaterOutstanding_Upto31032016.pdf'),
  // 9. ICDS (Integrated Child Development Services)
  const DownloadItem(name: 'APPLICATION FORM', category: 'ICDS', url: 'https://www.mcjamnagar.com/jmcForms/Documents/APPLICATION FORM_I.C.D.S._ICDS_Application.pdf'),
  // 10. Legal Branch - Laws & Regulations
  const DownloadItem(name: 'GPMC ACT', category: 'Legal Branch', url: 'https://www.mcjamnagar.com/jmcForms/Documents/GPMC ACT_26_gpmcact(1).pdf'),
  const DownloadItem(name: 'GSHRC Rules', category: 'Legal Branch', url: 'https://www.mcjamnagar.com/jmcForms/Documents/GSHRC Rules_26_GSHRC_Rules.pdf'),
  const DownloadItem(name: 'ID ACT', category: 'Legal Branch', url: 'https://www.mcjamnagar.com/jmcForms/Documents/ID.pdf'),
  const DownloadItem(name: 'LABOUR BYE LAWS', category: 'Legal Branch', url: 'https://www.mcjamnagar.com/jmcForms/Documents/Labour_ByeLaws.pdf'),
  const DownloadItem(name: 'MINIMUM WAGES ACT', category: 'Legal Branch', url: 'https://www.mcjamnagar.com/jmcForms/Documents/MINIMUM WAGES ACT_26_M.pdf'),
  const DownloadItem(name: 'Sexual Harassment of Women at Work Place(Prevention, Prohibition and Redressal) Act,2013', category: 'Legal Branch', url: 'https://www.mcjamnagar.com/jmcForms/Documents/Sexual Harassment of Women at Work Place(Prevention, Prohibition and Redressal) Act,2013_26_Women Cell _ GR-4-15.pdf'),
  const DownloadItem(name: 'STANDING ORDER', category: 'Legal Branch', url: 'https://www.mcjamnagar.com/jmcForms/Documents/STANDING ORDER_26_STANDING ORDER.pdf'),
  const DownloadItem(name: 'Street Vendors Act, 2014', category: 'Legal Branch', url: 'https://www.mcjamnagar.com/jmcForms/Documents/Street Vendors Act, 2014_26_Street Vendors Act, 2014_English.pdf'),
  const DownloadItem(name: 'The Gujarat Street Vendors Rules - 2016', category: 'Legal Branch', url: 'https://www.mcjamnagar.com/jmcForms/Documents/The Gujarat Street Vendors Rules - 2016_26_The Gujarat Street Vendors Rules - 2016.pdf'),
  const DownloadItem(name: 'The Protection of Human Rights Act 1993', category: 'Legal Branch', url: 'https://www.mcjamnagar.com/jmcForms/Documents/The Protection of Human Rights Act 1993_26_TheProtectionofHumanRightsAct1993_guj.pdf'),
  const DownloadItem(name: 'THE PAYMENT OF GRATUITY ACT, 1972_0', category: 'Legal Branch', url: 'https://www.mcjamnagar.com/jmcForms/Documents/THE PAYMENT OF GRATUITY ACT, 1972_0_26_p.pdf'),
  // 11. Marriage Registration
  const DownloadItem(name: 'Marriage Application', category: 'Marriage Registration', url: 'https://www.mcjamnagar.com/jmcForms/Documents/Marriage Application_28_APPLICATION_M.pdf'),
  const DownloadItem(name: 'Marriage Registration Fee & Info', category: 'Marriage Registration', url: 'https://www.mcjamnagar.com/jmcForms/Documents/Marriage Registration Fee & Info_28_M_FEE.pdf'),
  const DownloadItem(name: 'MEMORANDUM OF MARRIAGE', category: 'Marriage Registration', url: 'https://www.mcjamnagar.com/jmcForms/Documents/MEMORANDUM OF MARRIAGE_28_MEMORANDUM.pdf'),
  // 12. Professional Tax
  const DownloadItem(name: 'FORM 1', category: 'Professional Tax', url: 'https://www.mcjamnagar.com/jmcForms/Documents/FORM 1_Professional Tax_form1.pdf'),
  const DownloadItem(name: 'FORM 3', category: 'Professional Tax', url: 'https://www.mcjamnagar.com/jmcForms/Documents/FORM 3_Professional Tax_form3.pdf'),
  const DownloadItem(name: 'FORM 5', category: 'Professional Tax', url: 'https://www.mcjamnagar.com/jmcForms/Documents/FORM 5_Professional Tax_form5.pdf'),
  // 13. Shop & Establishment
  const DownloadItem(name: 'CONSENT OF WOMEN WORKER TO WORK IN NIGHTSHIFT', category: 'Shop & Establishment', url: 'https://www.mcjamnagar.com/jmcForms/Documents/CONSENT OF WOMEN WORKER TO WORK IN NIGHTSHIFT_18_FORM-J.pdf'),
  const DownloadItem(name: 'FORM-N', category: 'Shop & Establishment', url: 'https://www.mcjamnagar.com/jmcForms/Documents/FORM-N_18_FORM-N.pdf'),
  const DownloadItem(name: 'IDENTITY CARD', category: 'Shop & Establishment', url: 'https://www.mcjamnagar.com/jmcForms/Documents/IDENTITY CARD_18_M.pdf'),
  const DownloadItem(name: 'INTIMATION OF CLOSING OF BUSINESS', category: 'Shop & Establishment', url: 'https://www.mcjamnagar.com/jmcForms/Documents/INTIMATION OF CLOSING OF BUSINESS_18_FORM-I-INTIMATION-OF-CLOSING-OF-BUSINESS.pdf'),
  const DownloadItem(name: 'LIST OF WORKERS ENGAGED IN SHIFT', category: 'Shop & Establishment', url: 'https://www.mcjamnagar.com/jmcForms/Documents/LIST OF WORKERS ENGAGED IN SHIFT_18_L.pdf'),
  const DownloadItem(name: 'MUSTER –ROLL CUM WAGE REGISTER', category: 'Shop & Establishment', url: 'https://www.mcjamnagar.com/jmcForms/Documents/MUSTER –ROLL CUM WAGE REGISTER_18_P.pdf'),
  const DownloadItem(name: 'NOTICE FOR CHANGE IN REGISTRATION CERTIFICATE (FORM-G)', category: 'Shop & Establishment', url: 'https://www.mcjamnagar.com/jmcForms/Documents/NOTICE FOR CHANGE IN REGISTRATION CERTIFICATE (FORM-G)_18_FORMG9-1_FORMG9-2_merged.pdf'),
  const DownloadItem(name: 'NOTICE OF MEXIMUM LEAVE ACCUMULATED', category: 'Shop & Establishment', url: 'https://www.mcjamnagar.com/jmcForms/Documents/NOTICE OF MEXIMUM LEAVE ACCUMULATED_18_O.pdf'),
  const DownloadItem(name: 'NOTICE OF WEEKLY HOLIDAY', category: 'Shop & Establishment', url: 'https://www.mcjamnagar.com/jmcForms/Documents/NOTICE OF WEEKLY HOLIDAY_18_K.pdf'),
  // 14. Solid Waste Management
  const DownloadItem(name: 'Solid Wate Management', category: 'Solid Waste Management', url: 'https://www.mcjamnagar.com/jmcForms/Documents/Solid Wate Management_6_SWM Mahiti_2017.pdf'),
  // 15. T.P.D.P. (Town Planning Development Plan)
  const DownloadItem(name: 'Form 4 Notice to the Competent Authority of Discontinuation as Person on Record', category: 'T.P.D.P.', url: 'https://www.mcjamnagar.com/jmcForms/Documents/Form 4 Notice to the Competent Authority of Discontinuation as Person on Record_19_FORM NO. 4.pdf'),
  const DownloadItem(name: 'TP Scheme No. 1 Jamnagar', category: 'T.P.D.P.', url: 'https://www.mcjamnagar.com/jmcForms/Documents/TP Scheme No. 1 Jamnagar_T.P.D.P._TP_scheme-1_MAP.jpg'),
  const DownloadItem(name: 'TP Scheme No. 1 Jamnagar JADA', category: 'T.P.D.P.', url: 'https://www.mcjamnagar.com/jmcForms/Documents/TP Scheme No. 1 Jamnagar JADA_T.P.D.P._JADA-1.jpg'),
  const DownloadItem(name: 'TP Scheme No. 2 Jamnagar', category: 'T.P.D.P.', url: 'https://www.mcjamnagar.com/jmcForms/Documents/TP Scheme No. 2 Jamnagar_T.P.D.P._tp_scheme-2.jpg'),
  const DownloadItem(name: 'TP Scheme No. 2 Jamnagar JADA', category: 'T.P.D.P.', url: 'https://www.mcjamnagar.com/jmcForms/Documents/TP Scheme No. 2 Jamnagar JADA_T.P.D.P._JADA-2.jpg'),
  const DownloadItem(name: 'TP Scheme No. 3A Jamnagar JADA', category: 'T.P.D.P.', url: 'https://www.mcjamnagar.com/jmcForms/Documents/TP Scheme No. 3A Jamnagar JADA_T.P.D.P._JADA_3-A.jpg'),
  const DownloadItem(name: 'TP Scheme No. 3B Jamnagar JADA', category: 'T.P.D.P.', url: 'https://www.mcjamnagar.com/jmcForms/Documents/TP Scheme No. 3B Jamnagar JADA_T.P.D.P._JADA_3-B.jpg'),
  // 16. Town Planning
  const DownloadItem(name: 'AA List Of SUMMARY FORMS', category: 'Town Planning', url: 'https://www.mcjamnagar.com/jmcForms/Documents/AA List Of SUMMARY FORMS_8_SUMMARY_FORMS.pdf'),
  const DownloadItem(name: 'APPLICATION FORM FOR UNAUTHORISED DEVELOPEMENT', category: 'Town Planning', url: 'https://www.mcjamnagar.com/jmcForms/Documents/APPLICATION FORM FOR UNAUTHORISED DEVELOPEMENT_8_form-A.pdf'),
  const DownloadItem(name: 'APPLICATION FORM FOR UNAUTHORISED DEVELOPEMENT', category: 'Town Planning', url: 'https://www.mcjamnagar.com/jmcForms/Documents/APPLICATION FORM FOR UNAUTHORISED DEVELOPEMENT_8_FORM B.pdf'), // Duplicate name, keeping both
  const DownloadItem(name: 'BUILDING PERMISSION CHECK LIST', category: 'Town Planning', url: 'https://www.mcjamnagar.com/jmcForms/Documents/BUILDING PERMISSION CHECK LIST_Town Planning_BU_PERMISSION_CHECK_LIST.pdf'),
  const DownloadItem(name: 'DP PLAN US 16 PART-1', category: 'Town Planning', url: 'https://www.mcjamnagar.com/jmcForms/Documents/DP PLAN US 16 PART-1_Town Planning_sectoin_16_final_Model_300_dpi.jpg'),
  const DownloadItem(name: 'DP PLAN US 16 PART-2', category: 'Town Planning', url: 'https://www.mcjamnagar.com/jmcForms/Documents/DP PLAN US 16 PART-2_Town Planning_2_300_dpi.jpg'),
  const DownloadItem(name: 'Form 1 Application for Registering as Person on Record', category: 'Town Planning', url: 'https://www.mcjamnagar.com/jmcForms/Documents/Form 1 Application for Registering as Person on Record_8_FORM NO. 1.pdf'),
  const DownloadItem(name: 'Form 10 Notice for Commencement of Construction', category: 'Town Planning', url: 'https://www.mcjamnagar.com/jmcForms/Documents/Form 10 Notice for Commencement of Construction_8_FORM NO. 10.pdf'),
  const DownloadItem(name: 'Form 11 Notice of Progress of Construction', category: 'Town Planning', url: 'https://www.mcjamnagar.com/jmcForms/Documents/Form 11 Notice of Progress of Construction_8_FORM NO. 11.pdf'),
  const DownloadItem(name: 'Form 12 Notice of Completion of Construction and Compliance Certification', category: 'Town Planning', url: 'https://www.mcjamnagar.com/jmcForms/Documents/Form 12 Notice of Completion of Construction and Compliance Certification_8_FORM NO. 12.pdf'),
  const DownloadItem(name: 'Form 13 Application for Building Use Permission', category: 'Town Planning', url: 'https://www.mcjamnagar.com/jmcForms/Documents/Form 13 Application for Building Use Permission_8_FORM NO. 13.pdf'),
  const DownloadItem(name: 'Form 15 Structural Inspection Report', category: 'Town Planning', url: 'https://www.mcjamnagar.com/jmcForms/Documents/Form 15 Structural Inspection Report_8_FORM NO. 15.pdf'),
  const DownloadItem(name: 'Form 16 Fire Safety Certificate', category: 'Town Planning', url: 'https://www.mcjamnagar.com/jmcForms/Documents/Form 16 Fire Safety Certificate_8_FORM NO. 16.pdf'),
  const DownloadItem(name: 'Form 17 Undertaking for Built up area up to 125.00sq.mt.', category: 'Town Planning', url: 'https://www.mcjamnagar.com/jmcForms/Documents/Form 17 Undertaking for Built up area up to 125.00sq.mt._8_FORM NO. 17.pdf'),
  const DownloadItem(name: 'Form 18 Certificate of Undertaking for Person on Record', category: 'Town Planning', url: 'https://www.mcjamnagar.com/jmcForms/Documents/Form 18 Certificate of Undertaking for Person on Record_8_FORM NO. 18.pdf'),
  const DownloadItem(name: 'Form 2A Certificate of Undertaking for Persons on Record', category: 'Town Planning', url: 'https://www.mcjamnagar.com/jmcForms/Documents/Form 2A Certificate of Undertaking for Persons on Record_8_FORM NO. 2A.pdf'),
  const DownloadItem(name: 'FORM 2D SPECIAL BUILDING INFORMATION SCHEDULE (TO BE ANNEXED WITH FORM 2D)', category: 'Town Planning', url: 'https://www.mcjamnagar.com/jmcForms/Documents/FORM 2D SPECIAL BUILDING INFORMATION SCHEDULE (TO BE ANNEXED WITH FORM 2D)_8_FORM NO. 2D.pdf'),
  const DownloadItem(name: 'Form 3 Notice to the Competent Authority of Non‐Compliance of Building to Sanctioned Design and Specifications', category: 'Town Planning', url: 'https://www.mcjamnagar.com/jmcForms/Documents/Form 3 Notice to the Competent Authority of Non‐Compliance of Building to Sanctioned Design and Specifications_8_FORM NO. 3.pdf'),
  const DownloadItem(name: 'Form 5A Application for Development Permission for Brick‐kiln, Mining and Quarrying', category: 'Town Planning', url: 'https://www.mcjamnagar.com/jmcForms/Documents/Form 5A Application for Development Permission for Brick‐kiln, Mining and Quarrying_8_FORM NO. 5A.pdf'),
  const DownloadItem(name: 'Form 6A Area Statement for Buildings', category: 'Town Planning', url: 'https://www.mcjamnagar.com/jmcForms/Documents/Form 6A Area Statement for Buildings_8_FORM NO. 6A.pdf'),
  const DownloadItem(name: 'Form 5 Application for Development Permission for Building', category: 'Town Planning', url: 'https://www.mcjamnagar.com/jmcForms/Documents/Form No 5 Application for Development Permission for Building_8_FORM NO. 5.pdf'),
  const DownloadItem(name: 'Form 6B Area Statement for Subdivision and Amalgamation of Land', category: 'Town Planning', url: 'https://www.mcjamnagar.com/jmcForms/Documents/Form 6B Area Statement for Subdivision and Amalgamation of Land_8_FORM NO. 6B.pdf'),
  const DownloadItem(name: 'Form 9 Application for Revalidating Development Permission', category: 'Town Planning', url: 'https://www.mcjamnagar.com/jmcForms/Documents/Form 9 Application for Revalidating Development Permission_8_FORM NO. 9.pdf'),
  const DownloadItem(name: 'LABOR CESS CERTIFICATE', category: 'Town Planning', url: 'https://www.mcjamnagar.com/jmcForms/Documents/LABOR CESS CERTIFICATE_8_02.pdf'),
  const DownloadItem(name: 'LAY OUT CHECK LIST', category: 'Town Planning', url: 'https://www.mcjamnagar.com/jmcForms/Documents/LAY OUT CHECK LIST_Town Planning_LAYOUT_CHECK LIST.pdf'),
  // 17. UCD (Urban Community Development)
  const DownloadItem(name: 'ARBAN LAIVLIHOOD MISSION LOAN FORM', category: 'UCD', url: 'https://www.mcjamnagar.com/jmcForms/Documents/ARBAN LAIVLIHOOD MISSION LOAN FORM_11_UCD_ARBAN_LAIVLIHOOD_LOAN.pdf'),
  const DownloadItem(name: 'BPL SUDHARNAFORM', category: 'UCD', url: 'https://www.mcjamnagar.com/jmcForms/Documents/BPL SUDHARNAFORM_11_UCD_BPLSUDHARNAFORM.pdf'), // Duplicate name, different category
  const DownloadItem(name: 'HomeLess People List', category: 'UCD', url: 'https://www.mcjamnagar.com/jmcForms/Documents/HomeLess People List_11_Jamnagar Homeless People Survey List 517.pdf'),
  const DownloadItem(name: 'MA AMRUTAM ANE MA VATSLY', category: 'UCD', url: 'https://www.mcjamnagar.com/jmcForms/Documents/MA AMRUTAM ANE MA VATSLY_11_UCD_MA_AMRUTAM_VATSLY.pdf'), // Duplicate name, different category
  const DownloadItem(name: 'MISSION MANGALAM SAKHI MANDL FORM', category: 'UCD', url: 'https://www.mcjamnagar.com/jmcForms/Documents/MISSION MANGALAM SAKHI MANDL FORM_11_UCD_MISSION_MANGALAM.pdf'),
  const DownloadItem(name: 'NULM SKILL TRAINING FORM', category: 'UCD', url: 'https://www.mcjamnagar.com/jmcForms/Documents/NULM SKILL TRAINING FORM_11_UCD_NULM_SKILL_TRAINING_FORM.pdf'),
  const DownloadItem(name: 'RASHTRIY KUTUMB SAHAY YOJNA', category: 'UCD', url: 'https://www.mcjamnagar.com/jmcForms/Documents/RASHTRIY KUTUMB SAHAY YOJNA_11_UCD_KUTUMBSAHAY.pdf'), // Duplicate name, different category
  const DownloadItem(name: 'TABIBI SAHAY MATE NU FORM', category: 'UCD', url: 'https://www.mcjamnagar.com/jmcForms/Documents/TABIBI SAHAY MATE NU FORM_11_UCD_TABIBISAHAY MATE.pdf'), // Duplicate name, different category
  const DownloadItem(name: 'જામનગર શહેરમાં સરકાર માન્ય એજન્સી દ્વારા સર્વે દરમ્યાન નોંધણી થયેલ શહેરી શેરી ફેરિયાઓની યાદી', category: 'UCD', url: 'https://www.mcjamnagar.com/jmcForms/Documents/જામનગર શહેરમાં સરકાર માન્ય એજન્સી દ્વારા સર્વે દરમ્યાન નોંધણી થયેલ શહેરી શેરી ફેરિયાઓની યાદી_11_Jamnagar_Vendor Details (FINAL 3542) SV Line List.pdf'),
  // 18. Water Works
  const DownloadItem(name: 'Drinking Water Quality Monitoring Standards', category: 'Water Works', url: 'https://www.mcjamnagar.com/jmcForms/Documents/Drinking Water Quality Monitoring Standards_1_WQM.pdf'),
  const DownloadItem(name: 'NEW CONNECTION FORM-2015', category: 'Water Works', url: 'https://www.mcjamnagar.com/jmcForms/Documents/NEW CONNECTION FORM-2015_Water Works_NEW_CONNECTION.pdf'),
  const DownloadItem(name: 'OCCUPAN- WATER MASTER DATA FORMS-14', category: 'Water Works', url: 'https://www.mcjamnagar.com/jmcForms/Documents/OCCUPAN- WATER MASTER DATA FORMS-14_Water Works_OCCUPAN.pdf'),
  const DownloadItem(name: 'SLIP BOOK ALL FORMS', category: 'Water Works', url: 'https://www.mcjamnagar.com/jmcForms/Documents/SLIP BOOK ALL FORMS_Water Works_SLIP_BOOK.pdf'),
  const DownloadItem(name: 'WATER CONECTION DIS CONECTION LIS-2015', category: 'Water Works', url: 'https://www.mcjamnagar.com/jmcForms/Documents/WATER CONECTION DIS CONECTION LIS-2015_1_WATER_CONECTIONDIS_CONECTION.pdf'),
  const DownloadItem(name: 'Water Distribution Schedule', category: 'Water Works', url: 'https://www.mcjamnagar.com/jmcForms/Documents/Water Distribution Schedule_1_ALL E.S.R. MAHITI-2018.pdf'),
];

// Extract unique categories for filter chips
final List<String> downloadFilterCategories = [
  'All', // Add 'All' category
  ...allDownloadItems.map((item) => item.category).toSet() // Removed unnecessary .toList()
];

// Helper function to get localized category name from the English category string
String _getLocalizedDownloadCategoryName(BuildContext context, String englishCategoryName) {
  final l10n = AppLocalizations.of(context)!;
  switch (englishCategoryName) {
    case 'All': return l10n.downloadCategoryAll;
    case 'Accounts & Audit': return l10n.downloadCategoryAccountsAudit;
    case 'Birth & Death Registration': return l10n.downloadCategoryBirthDeathReg;
    case 'Estate': return l10n.downloadCategoryEstate;
    case 'Fire Safety': return l10n.downloadCategoryFireSafety;
    case 'Food Registration & Licensing': return l10n.downloadCategoryFoodRegLic;
    case 'General Administration': return l10n.downloadCategoryGenAdmin;
    case 'Health': return l10n.downloadCategoryHealth;
    case 'House Tax & Water Tax': return l10n.downloadCategoryHouseWaterTax;
    case 'ICDS': return l10n.downloadCategoryICDS;
    case 'Legal Branch': return l10n.downloadCategoryLegal;
    case 'Marriage Registration': return l10n.downloadCategoryMarriageReg;
    case 'Professional Tax': return l10n.downloadCategoryProfTax;
    case 'Shop & Establishment': return l10n.downloadCategoryShopEst;
    case 'Solid Waste Management': return l10n.downloadCategorySolidWaste;
    case 'T.P.D.P.': return l10n.downloadCategoryTPDP;
    case 'Town Planning': return l10n.downloadCategoryTownPlanning;
    case 'UCD': return l10n.downloadCategoryUCD;
    case 'Water Works': return l10n.downloadCategoryWaterWorks;
    default: return englishCategoryName; // Fallback
  }
}

/// Displays a list of downloadable documents or forms with filtering.
class DownloadsListScreen extends StatefulWidget {
  const DownloadsListScreen({super.key});

  @override
  State<DownloadsListScreen> createState() => _DownloadsListScreenState();
}

class _DownloadsListScreenState extends State<DownloadsListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filter the downloads based on selected category and search query
  List<DownloadItem> get _filteredDownloadItems {
    List<DownloadItem> items = allDownloadItems;

    // Filter by category
    if (_selectedCategory != 'All') {
      items = items.where((item) => item.category == _selectedCategory).toList();
    }

    // Filter by search query (case-insensitive)
    if (_searchQuery.isNotEmpty) {
      items = items.where((item) =>
          item.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }

    return items;
  }

  // Helper to get an appropriate icon based on file type
  IconData _getIconForType(String fileType) {
    switch (fileType.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf_outlined;
      case 'doc':
      case 'docx':
        return Icons.description_outlined;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image_outlined;
      default:
        return Icons.download_for_offline_outlined; // Default download icon
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!; // Get localizations object
    final filteredItems = _filteredDownloadItems;

    return Column(
      children: [
        // --- Search Bar ---
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: l10n.downloadsSearchHint, // Use localized hint
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
              filled: true,
              // Replace deprecated surfaceVariant and withOpacity
              fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha((255 * 0.5).round()),
              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                      },
                    )
                  : null,
            ),
          ),
        ),

        // --- Filter Chips Row ---
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: downloadFilterCategories.map((englishCategory) {
                final isSelected = englishCategory == _selectedCategory;
                // Get localized label
                final localizedLabel = _getLocalizedDownloadCategoryName(context, englishCategory);
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: FilterChip(
                    label: Text(localizedLabel), // Use localized label
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedCategory = englishCategory; // Fix: Use correct variable name
                        });
                      }
                    },
                    // Replace deprecated withOpacity
                    // Use theme colors for chip styling
                    selectedColor: Theme.of(context).colorScheme.primaryContainer,
                    checkmarkColor: Theme.of(context).colorScheme.onPrimaryContainer,
                     labelStyle: TextStyle(
                      // Use theme colors for text based on selection
                      color: isSelected
                          ? Theme.of(context).colorScheme.onPrimaryContainer // Color for selected chip text
                          : Theme.of(context).colorScheme.onSurfaceVariant, // Color for unselected chip text
                    ),
                   side: isSelected
                        ? BorderSide.none // No border when selected (uses background)
                        : BorderSide(color: Colors.grey.shade400),
                  ),
                );
              }).toList(),
            ),
          ),
        ),

        // --- Downloads List ---
        Expanded(
          child: filteredItems.isEmpty
              ? EmptyPlaceholder(
                  message: l10n.downloadsNoResults, // Use localized message
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(top: 8.0), // Add padding above list
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    final download = filteredItems[index];
                    final IconData icon = _getIconForType(download.guessedFileType);

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      child: ListTile(
                        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
                        title: Text(download.name),
                        subtitle: Text(download.category), // Show category
                        trailing: const Icon(Icons.download_outlined), // Indicate action
                        onTap: () {
                          launchURL(download.url); // Call the utility function
                        },
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
