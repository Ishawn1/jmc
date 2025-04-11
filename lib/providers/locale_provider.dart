import 'package:flutter/material.dart';
// Import the generated localizations delegate
// Note: This import will only work after running `flutter gen-l10n`
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class LocaleProvider with ChangeNotifier {
  Locale _locale = const Locale('en'); // Default to English

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    // Check if the locale is supported before setting
    if (!AppLocalizations.supportedLocales.contains(locale)) return;

    _locale = locale;
    notifyListeners();
  }
}

// Placeholder removed as AppLocalizations will be imported above.
