import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import generated localizations
import '../../../providers/theme_provider.dart'; // Import ThemeProvider

/// Screen for managing application settings, including theme options.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Use Consumer to listen to ThemeProvider changes
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.settingsScreenTitle), // Use localized title
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            children: <Widget>[
              // --- Appearance Section ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  l10n.settingsThemeTitle, // "Appearance"
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ),
              ListTile(
                title: Text(l10n.settingsThemeModeTitle), // "Theme Mode"
              ),
              // Radio buttons for theme mode selection
              RadioListTile<ThemeModeSetting>(
                title: Text(l10n.settingsThemeLight), // "Light"
                value: ThemeModeSetting.light,
                groupValue: themeProvider.themeModeSetting,
                onChanged: (value) {
                  if (value != null) {
                    themeProvider.setThemeModeSetting(value);
                  }
                },
              ),
              RadioListTile<ThemeModeSetting>(
                title: Text(l10n.settingsThemeDark), // "Dark"
                value: ThemeModeSetting.dark,
                groupValue: themeProvider.themeModeSetting,
                onChanged: (value) {
                  if (value != null) {
                    themeProvider.setThemeModeSetting(value);
                  }
                },
              ),
              RadioListTile<ThemeModeSetting>(
                title: Text(l10n.settingsThemeSystem), // "System Default"
                value: ThemeModeSetting.system,
                groupValue: themeProvider.themeModeSetting,
                onChanged: (value) {
                  if (value != null) {
                    themeProvider.setThemeModeSetting(value);
                  }
                },
              ),
              const Divider(height: 20, indent: 16, endIndent: 16),
              // Switch for dynamic color
              SwitchListTile(
                title: Text(l10n.settingsDynamicColorTitle), // "Use device theme colors"
                subtitle: Text(l10n.settingsDynamicColorDescription), // Description
                value: themeProvider.useDynamicColor,
                onChanged: (value) {
                  themeProvider.setUseDynamicColor(value);
                  // Optional: Show a snackbar or info message about dynamic color limitations
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   const SnackBar(content: Text('Dynamic color requires Android 12+')),
                  // );
                },
              ),
              // Add more settings sections below if needed
            ],
          ),
        );
      },
    );
  }
}
