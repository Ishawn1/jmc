import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart'; // For kDebugMode

/// Utility function to launch a URL.
///
/// Requires the url_launcher package.
/// Includes basic error handling.
Future<void> launchURL(String urlString) async {
  final Uri url = Uri.parse(urlString);
  try {
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication); // Open externally
    } else {
      // Log error in debug mode
      if (kDebugMode) {
        print('Could not launch $urlString');
      }
      // Optionally: Show a user-facing error message here
    }
  } catch (e) {
    // Log exception in debug mode
    if (kDebugMode) {
      print('Error launching URL $urlString: $e');
    }
    // Optionally: Show a user-facing error message here
  }
}
