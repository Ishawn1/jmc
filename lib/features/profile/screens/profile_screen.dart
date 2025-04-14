import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import generated localizations

/// Placeholder screen for user profile details.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profileScreenTitle), // Use localized title
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(Icons.person_outline, size: 80, color: Colors.grey),
              const SizedBox(height: 20),
              Text(
                'Profile Information', // Placeholder text
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 10),
              const Text(
                'User details and settings will appear here.', // Placeholder text
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              // Add profile details widgets here later
            ],
          ),
        ),
      ),
    );
  }
}
