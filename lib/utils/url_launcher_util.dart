import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart'; // For kDebugMode
import 'package:flutter/material.dart'; // For showing snackbars
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // For localization
import '../services/download_service.dart';
import '../providers/offline_downloads_provider.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:device_info_plus/device_info_plus.dart'; // Added for device info
import './permission_util.dart';

/// Utility function to launch a URL.
///
/// Requires the url_launcher package.
/// Includes basic error handling.
Future<void> launchURL(String urlString) async {
  final Uri url = Uri.parse(urlString);
  try {
    if (await canLaunchUrl(url)) {
      await launchUrl(url,
          mode: LaunchMode.externalApplication); // Open externally
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

/// Utility function to launch a URL with context for showing error messages.
///
/// Requires the url_launcher package.
/// Shows snackbar for errors.
Future<bool> launchUrlExternal(BuildContext context, String urlString) async {
  final Uri url = Uri.parse(urlString);
  try {
    if (await canLaunchUrl(url)) {
      await launchUrl(url,
          mode: LaunchMode.externalApplication); // Open externally
      return true;
    } else {
      // Show error message
      if (context.mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open link')),
        );
      }
      // Log error in debug mode
      if (kDebugMode) {
        print('Could not launch $urlString');
      }
      return false;
    }
  } catch (e) {
    // Show error message
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error opening link: $e')),
      );
    }
    // Log exception in debug mode
    if (kDebugMode) {
      print('Error launching URL $urlString: $e');
    }
    return false;
  }
}

/// Determines if a URL should be downloaded rather than opened in browser
bool shouldDownloadDirectly(String url) {
  final String lowerUrl = url.toLowerCase();

  // Check for document file types that should be downloaded
  return lowerUrl.endsWith('.pdf') ||
      lowerUrl.contains('/pdf') ||
      lowerUrl.endsWith('.doc') ||
      lowerUrl.endsWith('.docx') ||
      lowerUrl.endsWith('.xls') ||
      lowerUrl.endsWith('.xlsx') ||
      lowerUrl.endsWith('.ppt') ||
      lowerUrl.endsWith('.pptx');
}

/// Directly request all storage permissions using PermissionUtil
Future<bool> requestDirectStoragePermission(BuildContext context) async {
  // First, check if we already have permission
  bool hasPermission = await PermissionUtil.hasStoragePermission();

  if (hasPermission) {
    return true; // Permission already granted
  }

  // If permission is not granted, then show the explanatory dialog
  if (context.mounted) {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Storage Permissions Needed'),
        content: Text(
            'This app needs storage permissions to download files. We will now request the necessary permissions.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  // Now, request the permission using the centralized util method
  hasPermission = await PermissionUtil.requestStoragePermission();

  // If still no permission after requesting, prompt to open settings
  if (!hasPermission && context.mounted) {
    final goToSettings = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Permission Required'),
        content: Text(
            'Storage permission is required for downloads to work. Please enable it in app settings.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Open Settings'),
          ),
        ],
      ),
    );

    if (goToSettings == true) {
      await AppSettings.openAppSettings(); // Use AppSettings to open settings
      // Re-check permission after returning from settings
      hasPermission = await PermissionUtil.hasStoragePermission();
    }
  }

  return hasPermission;
}

/// Handles URL by downloading if it's a document, otherwise opening in browser
Future<bool> handleUrl(BuildContext context, String urlString) async {
  debugPrint('Handling URL: $urlString');

  if (shouldDownloadDirectly(urlString)) {
    debugPrint('URL should be downloaded directly');

    try {
      // Use our direct permission request method
      bool hasPermissions = await requestDirectStoragePermission(context);

      if (!hasPermissions) {
        debugPrint('Storage permissions denied');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Storage permission denied. Please grant storage permission to download files.'),
              duration: Duration(seconds: 4),
              action: SnackBarAction(
                label: 'Settings',
                onPressed: () async {
                  // Open app settings so user can enable permissions
                  await openAppSettings();
                },
              ),
            ),
          );
        }
        return false;
      }

      // Show download started message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Starting download...')),
        );
      }

      // Extract a title from the URL for the file name
      final Uri uri = Uri.parse(urlString);
      String fileName =
          uri.pathSegments.isNotEmpty ? uri.pathSegments.last : 'document';

      // Clean up the file name if needed
      if (fileName.isEmpty || fileName == '/') {
        fileName = 'document_${DateTime.now().millisecondsSinceEpoch}';
      }

      // Get providers
      final offlineDownloadsProvider =
          Provider.of<OfflineDownloadsProvider>(context, listen: false);

      // Start download
      final downloadService = DownloadService.instance;
      final downloadItem = await downloadService
          .downloadFromUrl(urlString, fileName, onProgress: (progress) {
        // Could update UI with progress here if needed
        debugPrint('Download progress: ${(progress * 100).toInt()}%');
      });

      if (downloadItem != null) {
        // Refresh the downloads list
        await offlineDownloadsProvider.loadOfflineDownloads();

        // Show success message
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Download complete. Opening file...'),
              duration: Duration(seconds: 2),
            ),
          );
        }

        // Wait a moment then open the file
        await Future.delayed(Duration(seconds: 2));
        if (context.mounted) {
          try {
            await downloadService.openDownloadedFile(downloadItem);
            return true;
          } catch (e) {
            debugPrint('Error opening downloaded file: $e');
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(
                        'File downloaded but couldn\'t be opened automatically')),
              );
            }
          }
        }
        return true;
      } else {
        // Show error
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Failed to download file. Check your internet connection and storage space.')),
          );
        }
        return false;
      }
    } catch (e) {
      // Show error
      debugPrint('Error handling document URL: $e');
      if (context.mounted) {
        String errorMessage = 'Error downloading file';

        // More descriptive error messages based on error type
        if (e.toString().contains('permission')) {
          errorMessage = 'Permission denied. Please grant storage permissions.';
        } else if (e.toString().contains('space') ||
            e.toString().contains('storage')) {
          errorMessage = 'Not enough storage space available.';
        } else if (e.toString().contains('network') ||
            e.toString().contains('socket') ||
            e.toString().contains('connection')) {
          errorMessage = 'Network error. Check your internet connection.';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
      return false;
    }
  } else {
    // Not a document URL, open normally in browser
    debugPrint('Opening URL in browser');
    return await launchUrlExternal(context, urlString);
  }
}
