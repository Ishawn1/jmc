import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // Import localization delegates
import 'features/auth/screens/login_screen.dart'; // Import the initial screen
import 'constants/app_constants.dart'; // For app title
import 'constants/colors.dart'; // For theme colors
// Import the generated localizations delegate
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// The root widget of the application.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle, // This title is not localized by default, but often set in native config
      // Localization settings
      localizationsDelegates: const [
        AppLocalizations.delegate, // Add the generated delegate
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('gu'), // Gujarati
        Locale('hi'), // Hindi
      ],
      // locale: Locale('gu'), // Optional: Force a specific locale for testing
      theme: ThemeData(
        useMaterial3: true,
        // Define the color scheme using the primary accent color
        colorScheme: ColorScheme.fromSeed(
          seedColor: jmcPrimaryAccent,
          brightness: Brightness.light, // Ensure light theme
          background: jmcScaffoldBackground, // Set default background
        ),
        scaffoldBackgroundColor: jmcScaffoldBackground, // Explicitly set scaffold background
        // Configure AppBar theme globally
        appBarTheme: const AppBarTheme(
          backgroundColor: jmcAppBarBackground, // Light gray background
          foregroundColor: jmcPrimaryTextColor, // Dark text/icons
          elevation: 0.5, // Subtle elevation/border
          shadowColor: Colors.black26, // Color for the shadow/border
          surfaceTintColor: Colors.transparent, // Avoid tinting on scroll
          titleTextStyle: TextStyle( // Ensure title text style is consistent
            color: jmcPrimaryTextColor,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
          iconTheme: IconThemeData( // Ensure icon colors are consistent
            color: jmcPrimaryTextColor,
          ),
        ),
        // Configure BottomNavigationBar theme globally
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: jmcAppBarBackground, // Match AppBar background
          selectedItemColor: jmcPrimaryAccent, // Medium blue for selected
          unselectedItemColor: jmcUnselectedColor, // Medium gray for unselected
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.w500), // Optional: style label
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500), // Optional: style label
          type: BottomNavigationBarType.fixed, // Ensure labels are always visible
          elevation: 1.0, // Subtle elevation
        ),
        // Optional: Configure other themes like TextTheme, ButtonTheme etc. if needed
        // textTheme: TextTheme(...)
      ),
      debugShowCheckedModeBanner: false,
      // Set the initial screen of the app to the LoginScreen
      home: const LoginScreen(),
    );
  }
}
