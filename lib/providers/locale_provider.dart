import 'package:flutter/material.dart';
// Import the generated localizations delegate
// Note: This import will only work after running `flutter gen-l10n`
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


/// A provider class for managing the application's locale.
///
/// This class allows the user to change the app's language and persists the
/// selected locale.
class LocaleProvider with ChangeNotifier {
  Locale _locale = const Locale('en'); // Default to English

  /// The currently selected locale.
  Locale get locale => _locale;

  /// Sets the application's locale.
  ///
  /// This method checks if the provided [locale] is supported and, if so,
  /// updates the current locale and notifies listeners of the change.
  void setLocale(Locale locale) {
    // Check if the locale is supported before setting
    if (!AppLocalizations.supportedLocales.contains(locale)) return;

    _locale = locale;
    notifyListeners();
  }
}

// Placeholder removed as AppLocalizations will be imported above.
