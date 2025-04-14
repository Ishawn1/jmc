import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider
import '../../../providers/locale_provider.dart'; // Import LocaleProvider
import '../../services/screens/services_list_screen.dart';
import '../../updates/screens/updates_list_screen.dart';
import '../../maps/screens/maps_screen.dart';
import '../../downloads/screens/downloads_list_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import generated localizations
// Import the new screens for navigation
import '../../settings/screens/settings_screen.dart';
import '../../profile/screens/profile_screen.dart';
// import '../../../constants/app_constants.dart'; // appTitle is not used here anymore

/// The main screen after login, containing the bottom navigation bar.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // State for selected tab index

  // List of the screens for each tab
  static const List<Widget> _widgetOptions = <Widget>[
    ServicesListScreen(),
    UpdatesListScreen(),
    MapsScreen(),
    DownloadsListScreen(),
  ];

  // No longer need static titles list, will get from l10n based on index

  void _onItemTapped(int index) {
    setState(() { // Update the state to change the screen
      _selectedIndex = index;
    });
  }

  // Helper to get localized title based on index
  String _getLocalizedTitle(BuildContext context, int index) {
    final l10n = AppLocalizations.of(context)!;
    switch (index) {
      case 0: return l10n.servicesScreenTitle;
      case 1: return l10n.updatesScreenTitle;
      case 2: return l10n.mapsScreenTitle;
      case 3: return l10n.downloadsScreenTitle;
      default: return ''; // Should not happen
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!; // Get localizations object
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false); // Get provider instance

    // Map language codes to display names
    const languageMap = {
      'en': 'English',
      'gu': 'ગુજરાતી',
      'hi': 'हिन्दी',
    };

    return Scaffold(
      appBar: AppBar(
        // Use localized title based on selected index
        title: Text(_getLocalizedTitle(context, _selectedIndex)),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String localeCode) {
              localeProvider.setLocale(Locale(localeCode));
            },
            itemBuilder: (BuildContext context) {
              return AppLocalizations.supportedLocales.map((Locale locale) {
                return PopupMenuItem<String>(
                  value: locale.languageCode,
                  child: Text(languageMap[locale.languageCode] ?? locale.languageCode),
                );
              }).toList();
            },
            // Display current language code or a generic icon
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                Provider.of<LocaleProvider>(context).locale.languageCode.toUpperCase(),
                style: TextStyle(
                  color: Theme.of(context).appBarTheme.foregroundColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Optional: Keep other actions if needed
          // IconButton(
        //     icon: const Icon(Icons.logout),
        //     onPressed: () {
        //       // Implement logout: Navigate back to LoginScreen
        //       Navigator.pushReplacement(
        //         context,
        //         MaterialPageRoute(builder: (context) => const LoginScreen()), // Need to import LoginScreen
        //       );
        //     },
        //   ),
        ], // Added missing closing bracket for actions list
      ),
      // Add the Drawer here
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                // Add background color from the theme to make the space look intentional
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
              // Optional: Add logo or user info here later
              child: Text(
                l10n.drawerMenuTitle, // Use localized title
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface, // Ensure text is visible
                  fontSize: 24, // Example style adjustment
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text(l10n.drawerSettings), // Use localized title
              onTap: () {
                // Navigate to Settings Screen
                Navigator.pop(context); // Close drawer first
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(l10n.drawerProfile), // Use localized title
              onTap: () {
                // Navigate to Profile Screen
                Navigator.pop(context); // Close drawer first
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(l10n.drawerAbout), // Use localized title
              onTap: () {
                // Placeholder
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('About Tapped (Not Implemented)')),
                );
              },
            ),
            // Add more items here if needed
          ],
        ),
      ),
      body: Center(
        // Display the widget corresponding to the selected index
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        // Items will use the theme defined in app.dart
        // Items will use the theme defined in app.dart
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.apps), // Changed icon as per plan
            label: l10n.bottomNavServices, // Use localized label
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.notifications),
            label: l10n.bottomNavUpdates, // Use localized label
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.map),
            label: l10n.bottomNavMaps, // Use localized label
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.download),
            label: l10n.bottomNavDownloads, // Use localized label
          ),
        ],
        currentIndex: _selectedIndex,
        // Removed explicit colors to use BottomNavigationBarThemeData from app.dart
        // selectedItemColor: Theme.of(context).colorScheme.primary,
        // unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed, // Ensures all labels are visible (already set in theme, but safe to keep)
        onTap: _onItemTapped,
      ),
    );
  }
}
