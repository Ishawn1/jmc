import 'package:flutter/material.dart';
import '../../services/screens/services_list_screen.dart';
import '../../updates/screens/updates_list_screen.dart';
import '../../maps/screens/maps_screen.dart';
import '../../downloads/screens/downloads_list_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import generated localizations
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

    return Scaffold(
      appBar: AppBar(
        // Use localized title based on selected index
        title: Text(_getLocalizedTitle(context, _selectedIndex)),
        // Optionally add actions like logout or profile here
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.logout),
        //     onPressed: () {
        //       // Implement logout: Navigate back to LoginScreen
        //       Navigator.pushReplacement(
        //         context,
        //         MaterialPageRoute(builder: (context) => const LoginScreen()), // Need to import LoginScreen
        //       );
        //     },
        //   ),
        // ],
      ),
      // Add the Drawer here
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                // Optional: Add background color or image
                // color: Theme.of(context).colorScheme.primary,
              ),
              // Optional: Add logo or user info here later
              child: Text('JMC App Menu'), // Placeholder title
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                // Placeholder: Close the drawer and maybe show a message
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Settings Tapped (Not Implemented)')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                // Placeholder
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile Tapped (Not Implemented)')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
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
