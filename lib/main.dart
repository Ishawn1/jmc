import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import 'app.dart'; // Import the root App widget

/// The main entry point of the application.
///
/// This function ensures that the Flutter bindings are initialized, initializes
/// SharedPreferences, and then runs the application by creating an instance of
/// the [App] widget.
Future<void> main() async {
  // Ensure Flutter bindings are initialized, which is necessary for running the app.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences to make it available throughout the app.
  await SharedPreferences.getInstance();

  // Run the application by passing the root App widget.
  runApp(const App());
}
