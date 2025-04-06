import 'package:flutter/material.dart';
import 'app.dart'; // Import the root App widget

void main() {
  // Ensure Flutter bindings are initialized (good practice)
  WidgetsFlutterBinding.ensureInitialized();

  // Run the application by passing the root App widget
  runApp(const App());
}
