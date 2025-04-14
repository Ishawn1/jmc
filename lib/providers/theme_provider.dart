import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Enum to represent the user's theme preference
enum ThemeModeSetting { light, dark, system }

/// Manages the application's theme settings, including theme mode
/// (light, dark, system) and dynamic color usage.
///
/// Persists settings using SharedPreferences.
class ThemeProvider extends ChangeNotifier {
  late SharedPreferences _prefs;

  // Keys for SharedPreferences
  static const String _themeModeKey = 'theme_mode_setting';
  static const String _dynamicColorKey = 'use_dynamic_color';

  // Default values
  ThemeModeSetting _themeModeSetting = ThemeModeSetting.system;
  bool _useDynamicColor = false; // Default to false for broader compatibility

  // Public getters
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

  ThemeModeSetting get themeModeSetting => _themeModeSetting;
  bool get useDynamicColor => _useDynamicColor;

  ThemeProvider() {
    // Initialize immediately, loading preferences asynchronously
    _loadPreferences();
  }

  // Load saved preferences
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

  // Set the theme mode setting and save it
  Future<void> setThemeModeSetting(ThemeModeSetting setting) async {
    if (_themeModeSetting == setting) return; // No change

    _themeModeSetting = setting;
    await _prefs.setInt(_themeModeKey, setting.index);
    notifyListeners();
  }

  // Set the dynamic color usage and save it
  Future<void> setUseDynamicColor(bool enabled) async {
    if (_useDynamicColor == enabled) return; // No change

    _useDynamicColor = enabled;
    await _prefs.setBool(_dynamicColorKey, enabled);
    notifyListeners();
  }
}
