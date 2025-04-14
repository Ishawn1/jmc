import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'features/auth/screens/login_screen.dart';
import 'constants/app_constants.dart';
import 'constants/colors.dart';
import 'providers/locale_provider.dart';
import 'providers/theme_provider.dart'; // Import ThemeProvider
import 'package:dynamic_color/dynamic_color.dart'; // Import dynamic_color
// Import the generated localizations delegate
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// The root widget of the application.
class App extends StatelessWidget {
  const App({super.key});

  // Updated helper function to build ThemeData
  // Accepts optional dynamic ColorScheme
  ThemeData _buildThemeData(
    Brightness brightness,
    bool useDynamicColor,
    ColorScheme? dynamicColorScheme, // Optional dynamic scheme
  ) {
    ColorScheme colorScheme;

    // Use dynamic scheme if available and enabled, otherwise use seed
    if (useDynamicColor && dynamicColorScheme != null) {
      colorScheme = dynamicColorScheme;
    } else {
      colorScheme = ColorScheme.fromSeed(
        seedColor: jmcPrimaryAccent,
        brightness: brightness,
      );
    }

    // Define base ThemeData
    final baseTheme = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      // Use scheme background color, fallback to custom if needed
      scaffoldBackgroundColor: colorScheme.brightness == Brightness.light
          ? jmcScaffoldBackground // Keep custom light background
          : colorScheme.background, // Use scheme background for dark
    );

    // Apply component themes based on the final colorScheme
    return baseTheme.copyWith(
      appBarTheme: AppBarTheme(
        // Use scheme surface/background for AppBar, adjust as needed
        backgroundColor: colorScheme.brightness == Brightness.light
            ? jmcAppBarBackground // Keep custom light AppBar background
            : colorScheme.surface, // Use scheme surface for dark AppBar
        // Use scheme's onSurface/onBackground for text/icons
        foregroundColor: colorScheme.onSurface,
        elevation: 0.5,
        shadowColor: colorScheme.shadow.withOpacity(0.1), // Use scheme shadow
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: colorScheme.onSurface, // Use scheme color
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        iconTheme: IconThemeData(
          color: colorScheme.onSurface, // Use scheme color
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        // Use scheme surface/background for Nav Bar
         backgroundColor: colorScheme.brightness == Brightness.light
            ? jmcAppBarBackground // Keep custom light Nav background
            : colorScheme.surface, // Use scheme surface for dark Nav
        selectedItemColor: colorScheme.primary, // Use scheme primary
        // Use scheme's onSurface with some opacity for unselected items
        unselectedItemColor: colorScheme.onSurface.withOpacity(0.6),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
        type: BottomNavigationBarType.fixed,
        elevation: 1.0,
      ),
      // Add other theme customizations if necessary
      // Example: Ensure FilterChip colors adapt
      chipTheme: baseTheme.chipTheme.copyWith(
        selectedColor: colorScheme.primaryContainer,
        checkmarkColor: colorScheme.onPrimaryContainer,
        labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
        secondaryLabelStyle: TextStyle(color: colorScheme.onPrimaryContainer),
        // Adjust side based on brightness or selection state if needed
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      // Example: Ensure RadioListTile colors adapt
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color?>((states) {
          if (states.contains(MaterialState.selected)) {
            return colorScheme.primary;
          }
          return colorScheme.onSurface.withOpacity(0.6); // Unselected color
        }),
      ),
      // Example: Ensure SwitchListTile colors adapt
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith<Color?>((states) {
           if (states.contains(MaterialState.selected)) {
             return colorScheme.primary;
           }
           return null; // Use default thumb color
        }),
        trackColor: MaterialStateProperty.resolveWith<Color?>((states) {
           if (states.contains(MaterialState.selected)) {
             return colorScheme.primary.withOpacity(0.5);
           }
           return null; // Use default track color
        }),
         trackOutlineColor: MaterialStateProperty.resolveWith((states) {
           if (states.contains(MaterialState.selected)) {
             return Colors.transparent; // No outline when selected
           }
           return colorScheme.outline; // Default outline
         }),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    // Wrap with MultiProvider for both Locale and Theme
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()), // Add ThemeProvider
      ],
      child: Consumer2<LocaleProvider, ThemeProvider>( // Use Consumer2
        builder: (context, localeProvider, themeProvider, child) { // Add themeProvider
          // Wrap MaterialApp with DynamicColorBuilder
          return DynamicColorBuilder(
            builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
              // Determine which dynamic scheme to potentially use based on brightness
              // Only pass the dynamic scheme if useDynamicColor is true
              ColorScheme? lightColorScheme = themeProvider.useDynamicColor ? lightDynamic : null;
              ColorScheme? darkColorScheme = themeProvider.useDynamicColor ? darkDynamic : null;

              return MaterialApp(
                title: appTitle,
                // Localization settings
                locale: localeProvider.locale,
      localizationsDelegates: [ // Removed 'const'
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
      // Theme settings using the updated helper and potentially dynamic schemes
      themeMode: themeProvider.themeMode,
      theme: _buildThemeData(Brightness.light, themeProvider.useDynamicColor, lightColorScheme),
      darkTheme: _buildThemeData(Brightness.dark, themeProvider.useDynamicColor, darkColorScheme),

      debugShowCheckedModeBanner: false,
      // Set the initial screen of the app to the LoginScreen
      home: const LoginScreen(),
              );
            },
          );
        },
      ),
    );
  }
}
