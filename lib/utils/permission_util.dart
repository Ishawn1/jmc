import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

/// A utility class to manage app permissions
class PermissionUtil {
  static Future<int> _getAndroidSdkInt() async {
    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.version.sdkInt ?? 0;
    }
    return 0;
  }

  /// Check if storage permission is granted
  static Future<bool> hasStoragePermission() async {
    if (Platform.isAndroid || Platform.isIOS) {
      debugPrint('Checking storage permissions...');

      if (Platform.isAndroid) {
        bool hasPermission = false;
        final sdkInt = await _getAndroidSdkInt();

        // Check Android version to determine which permissions to check
        if (sdkInt >= 33) {
          // Android 13+
          // For Android 13+ (API 33+), check the specific media permissions
          final photos = await Permission.photos.status;
          final videos = await Permission.videos.status;

          debugPrint('Photos permission status: $photos');
          debugPrint('Videos permission status: $videos');

          hasPermission = photos.isGranted || videos.isGranted;
        }

        // Always check basic storage as fallback or for older versions
        final storageStatus = await Permission.storage.status;
        // On Android 11+ (SDK 30+), MANAGE_EXTERNAL_STORAGE is an option
        final manageExternalStatus = sdkInt >= 30
            ? await Permission.manageExternalStorage.status
            : PermissionStatus.denied;

        debugPrint('Storage permission status: $storageStatus');
        debugPrint(
            'Manage external storage permission status: $manageExternalStatus');

        return hasPermission ||
            storageStatus.isGranted ||
            manageExternalStatus.isGranted;
      } else {
        // For iOS
        final status = await Permission.storage.status;
        debugPrint('iOS storage permission status: $status');
        return status.isGranted;
      }
    }
    return true; // For desktop platforms
  }

  /// Request storage permission
  static Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid || Platform.isIOS) {
      debugPrint('Requesting storage permissions...');

      if (Platform.isAndroid) {
        bool hasPermission = false;
        final sdkInt = await _getAndroidSdkInt();

        // Check Android version to determine which permissions to request
        if (sdkInt >= 33) {
          // Android 13+
          // For Android 13+ (API 33+), request the specific media permissions
          debugPrint('Android 13+ detected, requesting media permissions');

          final photos = await Permission.photos.request();
          final videos = await Permission.videos.request();
          final audio = await Permission.audio.request(); // Also request audio

          debugPrint('Photos permission: $photos');
          debugPrint('Videos permission: $videos');
          debugPrint('Audio permission: $audio');

          // Consider granted if any relevant media permission is granted
          hasPermission =
              photos.isGranted || videos.isGranted || audio.isGranted;
        }

        // Always request basic storage as fallback or for older versions
        // If not Android 13+ OR if media permissions were not granted, try .storage
        if (!hasPermission) {
          final storageStatus = await Permission.storage.request();
          debugPrint(
              'After request, storage permission status: $storageStatus');
          if (storageStatus.isGranted) {
            hasPermission = true;
          }
        }

        // For Android 11+ (API 30+), also try to request manage external storage if other permissions failed
        // This is a powerful permission, so only request if necessary
        if (!hasPermission && sdkInt >= 30) {
          try {
            final manageExternalStatus =
                await Permission.manageExternalStorage.request();
            debugPrint(
                'After request, manage external storage permission status: $manageExternalStatus');

            if (manageExternalStatus.isGranted) {
              hasPermission = true;
            }
          } catch (e) {
            debugPrint(
                'Exception requesting manage external storage permission: $e');
          }
        }

        return hasPermission;
      } else {
        // For iOS
        final status = await Permission.storage.request();
        debugPrint('After request, iOS storage permission status: $status');
        return status.isGranted;
      }
    }
    return true; // For desktop platforms
  }

  /// Show dialog explaining permission needs to user
  static Future<void> showPermissionDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Storage Permission Required'),
          content: Text(
              'This app needs storage permission to download and save files. Please grant this permission in the app settings.'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Open Settings'),
              onPressed: () {
                openAppSettings();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /// Check and request all permissions needed by the app
  static Future<void> checkAndRequestAllPermissions(
      BuildContext context) async {
    // Request storage permission
    bool hasPermission = await hasStoragePermission();
    if (!hasPermission) {
      hasPermission = await requestStoragePermission();

      // If still not granted, show dialog
      if (!hasPermission && context.mounted) {
        await showPermissionDialog(context);
      }
    }
  }
}
