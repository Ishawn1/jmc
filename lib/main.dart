import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import 'app.dart'; // Import the root App widget

// Make main async
Future<void> main() async {
  // Ensure Flutter bindings are initialized (good practice)
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences before running the app
  await SharedPreferences.getInstance();

  // Run the application by passing the root App widget
  runApp(const App());
}
