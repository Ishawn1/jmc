import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// An enum to represent the user's theme preference.
enum ThemeModeSetting {
  /// Light theme.
  light,

  /// Dark theme.
  dark,

  /// System default theme.
  system,
}

/// A provider class for managing the application's theme settings.
///
/// This class handles the theme mode (light, dark, or system) and the use of
/// dynamic colors. It persists the user's preferences using [SharedPreferences].
class ThemeProvider extends ChangeNotifier {
  late SharedPreferences _prefs;

  // Keys for SharedPreferences
  static const String _themeModeKey = 'theme_mode_setting';
  static const String _dynamicColorKey = 'use_dynamic_color';

  // Default values
  ThemeModeSetting _themeModeSetting = ThemeModeSetting.system;
  bool _useDynamicColor = false; // Default to false for broader compatibility

  /// The current theme mode of the application.
  ThemeMode get themeMode {
    switch (_themeModeSetting) {
      case ThemeModeSetting.light:
        return ThemeMode.light;
      case ThemeModeSetting.dark:
        return ThemeMode.dark;
      case ThemeModeSetting.system:
      default:
        return ThemeMode.system;
    }
  }

  /// The user's selected theme mode setting.
  ThemeModeSetting get themeModeSetting => _themeModeSetting;

  /// A boolean indicating whether dynamic colors are enabled.
  bool get useDynamicColor => _useDynamicColor;

  /// Creates an instance of [ThemeProvider] and loads the saved preferences.
  ThemeProvider() {
    // Initialize immediately, loading preferences asynchronously
    _loadPreferences();
  }

  /// Loads the saved theme preferences from [SharedPreferences].
  Future<void> _loadPreferences() async {
    _prefs = await SharedPreferences.getInstance();

    // Load theme mode setting
    final savedThemeModeIndex = _prefs.getInt(_themeModeKey);
    if (savedThemeModeIndex != null && savedThemeModeIndex >= 0 && savedThemeModeIndex < ThemeModeSetting.values.length) {
      _themeModeSetting = ThemeModeSetting.values[savedThemeModeIndex];
    } else {
      _themeModeSetting = ThemeModeSetting.system; // Default if not found or invalid
    }

    // Load dynamic color setting
    _useDynamicColor = _prefs.getBool(_dynamicColorKey) ?? false; // Default to false if not found

    // Notify listeners after loading initial values
    notifyListeners();
  }

  /// Sets the theme mode setting and saves it to [SharedPreferences].
  Future<void> setThemeModeSetting(ThemeModeSetting setting) async {
    if (_themeModeSetting == setting) return; // No change

    _themeModeSetting = setting;
    await _prefs.setInt(_themeModeKey, setting.index);
    notifyListeners();
  }

  /// Sets the dynamic color usage and saves it to [SharedPreferences].
  Future<void> setUseDynamicColor(bool enabled) async {
    if (_useDynamicColor == enabled) return; // No change

    _useDynamicColor = enabled;
    await _prefs.setBool(_dynamicColorKey, enabled);
    notifyListeners();
  }
}
