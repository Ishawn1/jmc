import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import generated localizations
import '../../home/screens/home_screen.dart'; // Navigate to home after login

/// A mock login screen that provides a user interface for authentication.
///
/// This screen includes text fields for a username and password, along with a
/// login button. Upon pressing the login button, it navigates to the [HomeScreen].
///
/// Note: This is a mock implementation and does not perform real authentication.
class LoginScreen extends StatelessWidget {
  /// Creates an instance of the [LoginScreen].
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the localizations object
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        // Use localized title
        title: Text(l10n.loginScreenTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView( // Allows scrolling if content overflows
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Placeholder for Logo or App Name
                Text(
                  l10n.loginWelcomeMessage, // Use localized welcome message
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 40),

                // Username/Mobile Number Field (Mock)
                TextField(
                  decoration: InputDecoration(
                    labelText: l10n.loginUsernameLabel, // Use localized label
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.person),
                  ),
                  keyboardType: TextInputType.text, // Adjust as needed
                ),
                const SizedBox(height: 20),

                // Password Field (Mock)
                TextField(
                  decoration: InputDecoration(
                    labelText: l10n.loginPasswordLabel, // Use localized label
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 40),

                // Login Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50), // Full width button
                    textStyle: Theme.of(context).textTheme.titleMedium,
                  ),
                  onPressed: () {
                    // Mock login: Navigate directly to HomeScreen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                    );
                  },
                  child: Text(l10n.loginButtonText), // Use localized button text
                ),
                const SizedBox(height: 20),

                // Optional: Add links for "Forgot Password?" or "Register"
                TextButton(
                  onPressed: () {
                    // Placeholder action
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.loginForgotPasswordSnackbar)), // Use localized snackbar text
                    );
                  },
                  child: Text(l10n.loginForgotPassword), // Use localized text
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
