import 'dart:io';
import 'dart:io' show Process;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:open_file/open_file.dart';
import '../models/offline_download_item.dart';
import 'database_service.dart';
import '../utils/permission_util.dart';

class DownloadService {
  static final DownloadService _instance = DownloadService._internal();
  static DownloadService get instance => _instance;

  final Dio _dio = Dio();
  final DatabaseService _databaseService = DatabaseService.instance;
  final Map<String, CancelToken> _cancelTokens = {};

  DownloadService._internal();

  // Check and request storage permissions
  Future<bool> checkPermissions() async {
    // Use the improved PermissionUtil instead of duplicating permission logic
    return await PermissionUtil.hasStoragePermission();
  }

  // Get directory for storing files
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    final downloadsDir = Directory('${directory.path}/offline_downloads');

    if (!await downloadsDir.exists()) {
      await downloadsDir.create(recursive: true);
    }

    return downloadsDir.path;
  }

  // Generate file name based on URL and document name
  String _generateFileName(String url, String name) {
    final uri = Uri.parse(url);
    final path = uri.path;

    // Extract file extension from URL
    String extension = '';
    if (path.contains('.')) {
      extension = path.substring(path.lastIndexOf('.'));
    } else {
      // Default to PDF if no extension found but try to guess from URL
      if (url.toLowerCase().contains('pdf')) {
        extension = '.pdf';
      }
    }

    // Use a sanitized version of the document name as the file name
    final sanitizedName = name
        .replaceAll(RegExp(r'[^\w\s.-]'), '')
        .replaceAll(RegExp(r'\s+'), '_');

    // Return file name with extension
    return '$sanitizedName$extension';
  }

  // Direct download of a URL (for use with in-app link handling)
  Future<OfflineDownloadItem?> downloadFromUrl(String url, String name,
      {Function(double)? onProgress}) async {
    try {
      debugPrint('Starting direct download from URL: $url');

      // Generate a unique ID based on the URL
      final id = url.hashCode.toString();

      // Explicitly check permissions first to handle permission errors clearly
      final hasPermission = await checkPermissions();
      if (!hasPermission) {
        debugPrint(
            'Storage permission denied while attempting to download: $url');
        throw Exception('Storage permission denied');
      }

      // Check if already downloaded
      final existingDownload = await _databaseService.getOfflineDownload(id);
      if (existingDownload != null &&
          existingDownload.status == DownloadStatus.downloaded &&
          existingDownload.localFilePath != null) {
        // Check if file still exists
        final file = File(existingDownload.localFilePath!);
        if (await file.exists()) {
          debugPrint(
              'File already downloaded: ${existingDownload.localFilePath}');
          return existingDownload;
        } else {
          debugPrint(
              'Downloaded file no longer exists, will re-download: ${existingDownload.localFilePath}');
        }
      }

      // Verify storage path is accessible
      final downloadPath = await _localPath;
      final directory = Directory(downloadPath);
      if (!await directory.exists()) {
        debugPrint('Creating download directory at: $downloadPath');
        try {
          await directory.create(recursive: true);
        } catch (e) {
          debugPrint('Failed to create download directory: $e');
          throw Exception('Could not create download directory: $e');
        }
      }

      // Create new download item
      final item = OfflineDownloadItem(
        id: id,
        name: name,
        category: 'Document',
        url: url,
        status: DownloadStatus.notDownloaded,
      );

      // Start download process
      debugPrint('Beginning download for: $name');
      return await downloadFile(item, onProgress: onProgress);
    } catch (e) {
      debugPrint('Error in direct download: $e');
      // Re-throw specific errors for better handling upstream
      if (e.toString().contains('permission')) {
        throw Exception('Storage permission denied');
      } else if (e.toString().contains('No space')) {
        throw Exception('Not enough storage space');
      } else if (e.toString().contains('network') ||
          e.toString().contains('connection')) {
        throw Exception('Network error');
      }
      return null;
    }
  }

  // Download file and save it to local storage
  Future<OfflineDownloadItem> downloadFile(OfflineDownloadItem item,
      {Function(double)? onProgress}) async {
    try {
      debugPrint('Starting download process for: ${item.url}');

      // Check permissions
      final hasPermission = await checkPermissions();
      if (!hasPermission) {
        debugPrint('Storage permission denied');
        return item.copyWith(status: DownloadStatus.failed);
      }

      // Create cancel token and update database with download status
      final cancelToken = CancelToken();
      _cancelTokens[item.id] = cancelToken;

      await _databaseService.updateOfflineDownloadStatus(
        item.id,
        DownloadStatus.downloading,
        progress: 0.0,
      );

      // Generate filename and get download path
      final fileName = _generateFileName(item.url, item.name);
      final savePath = '${await _localPath}/$fileName';

      debugPrint('Downloading to: $savePath');

      // Download file with progress tracking
      await _dio.download(
        item.url,
        savePath,
        cancelToken: cancelToken,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            final progress = received / total;
            if (onProgress != null) {
              onProgress(progress);
            }
            _databaseService.updateOfflineDownloadStatus(
              item.id,
              DownloadStatus.downloading,
              progress: progress,
            );
          }
        },
      );

      debugPrint('Download completed successfully');

      // Update database with completed download
      final updatedItem = item.copyWith(
        status: DownloadStatus.downloaded,
        localFilePath: savePath,
        progress: 1.0,
        downloadDate: DateTime.now(),
      );

      await _databaseService.saveOfflineDownload(updatedItem);
      _cancelTokens.remove(item.id);

      return updatedItem;
    } catch (e) {
      // Handle errors
      debugPrint('Error during download: $e');

      if (e is DioException && e.type == DioExceptionType.cancel) {
        // Download was canceled
        await _databaseService.updateOfflineDownloadStatus(
          item.id,
          DownloadStatus.notDownloaded,
          progress: 0.0,
        );
      } else {
        // Download failed for other reasons
        await _databaseService.updateOfflineDownloadStatus(
          item.id,
          DownloadStatus.failed,
        );
      }

      _cancelTokens.remove(item.id);
      rethrow;
    }
  }

  // Cancel an ongoing download
  Future<void> cancelDownload(String id) async {
    if (_cancelTokens.containsKey(id)) {
      _cancelTokens[id]?.cancel('Download canceled by user');
      _cancelTokens.remove(id);

      await _databaseService.updateOfflineDownloadStatus(
        id,
        DownloadStatus.notDownloaded,
        progress: 0.0,
      );
    }
  }

  // Delete a downloaded file
  Future<void> deleteDownloadedFile(OfflineDownloadItem item) async {
    if (item.localFilePath != null &&
        item.status == DownloadStatus.downloaded) {
      final file = File(item.localFilePath!);
      if (await file.exists()) {
        await file.delete();
      }

      await _databaseService.deleteOfflineDownload(item.id);
    }
  }

  // Open a downloaded file
  Future<void> openDownloadedFile(OfflineDownloadItem item) async {
    if (item.localFilePath == null ||
        item.status != DownloadStatus.downloaded) {
      debugPrint('Cannot open file: File not downloaded or path is null');
      return;
    }

    final file = File(item.localFilePath!);
    if (!await file.exists()) {
      debugPrint('File does not exist: ${item.localFilePath}');
      return;
    }

    debugPrint('Attempting to open file with path: ${item.localFilePath}');

    try {
      // First approach: try using open_file package
      debugPrint('Trying open_file package first');
      final result = await OpenFile.open(item.localFilePath!);

      if (result.type == ResultType.done) {
        debugPrint('File opened successfully with open_file package');
        return;
      } else {
        debugPrint('open_file package error: ${result.message}');

        // Continue with other approaches if open_file fails
      }

      // Get file mime type based on extension
      String mimeType = '*/*';
      final path = item.localFilePath!.toLowerCase();
      if (path.endsWith('.pdf')) {
        mimeType = 'application/pdf';
      } else if (path.endsWith('.doc') || path.endsWith('.docx')) {
        mimeType = 'application/msword';
      } else if (path.endsWith('.jpg') || path.endsWith('.jpeg')) {
        mimeType = 'image/jpeg';
      } else if (path.endsWith('.png')) {
        mimeType = 'image/png';
      } else if (path.endsWith('.txt')) {
        mimeType = 'text/plain';
      }

      // Second approach: try platform-specific methods
      if (Platform.isAndroid || Platform.isIOS) {
        // Try sharing as the most reliable option for mobile
        debugPrint('Trying share approach');
        try {
          await shareDownloadedFile(item);
          return;
        } catch (shareError) {
          debugPrint('Share approach failed: $shareError');
          // Continue to other approaches
        }

        // Try URL launcher as fallback
        try {
          debugPrint('Trying url_launcher with file URI');
          final uri = Uri.file(item.localFilePath!);

          if (await canLaunchUrl(uri)) {
            final success =
                await launchUrl(uri, mode: LaunchMode.externalApplication);
            if (success) {
              debugPrint('url_launcher succeeded');
              return;
            } else {
              debugPrint('url_launcher failed');
            }
          } else {
            debugPrint('Cannot launch file URI: $uri');
          }
        } catch (e) {
          debugPrint('url_launcher exception: $e');
        }
      } else if (Platform.isWindows) {
        // On Windows, use cmd with start
        debugPrint('Using cmd start for Windows');
        final result =
            await Process.run('cmd', ['/c', 'start', '', item.localFilePath!]);

        if (result.exitCode != 0) {
          debugPrint('Windows open failed: ${result.stderr}');
          throw Exception(
              'Failed to open file with Windows cmd: ${result.stderr}');
        }
      } else if (Platform.isMacOS) {
        // On macOS, use open command
        debugPrint('Using open for macOS');
        final result = await Process.run('open', [item.localFilePath!]);

        if (result.exitCode != 0) {
          debugPrint('macOS open failed: ${result.stderr}');
          throw Exception(
              'Failed to open file with macOS open: ${result.stderr}');
        }
      } else if (Platform.isLinux) {
        // On Linux, use xdg-open
        debugPrint('Using xdg-open for Linux');
        final result = await Process.run('xdg-open', [item.localFilePath!]);

        if (result.exitCode != 0) {
          debugPrint('Linux xdg-open failed: ${result.stderr}');
          throw Exception(
              'Failed to open file with Linux xdg-open: ${result.stderr}');
        }
      } else {
        // Web or other platforms - not supported
        debugPrint('Platform not supported for file opening');
        throw Exception('Platform not supported for file opening');
      }
    } catch (e) {
      debugPrint('Error opening file: $e');

      // Final fallback - try sharing for all platforms
      try {
        debugPrint('Attempting to share as final fallback');
        await shareDownloadedFile(item);
      } catch (shareError) {
        debugPrint('Error sharing file as fallback: $shareError');
        throw Exception(
            'Failed to open or share file: $e, share error: $shareError');
      }
    }
  }

  // Export file to user's download directory
  Future<bool> exportFile(OfflineDownloadItem item) async {
    if (item.localFilePath != null &&
        item.status == DownloadStatus.downloaded) {
      final file = File(item.localFilePath!);
      if (await file.exists()) {
        try {
          final params = SaveFileDialogParams(
            sourceFilePath: item.localFilePath!,
            fileName: _generateFileName(item.url, item.name),
          );

          final String? filePath =
              await FlutterFileDialog.saveFile(params: params);
          return filePath != null;
        } catch (e) {
          debugPrint('Error exporting file: $e');
          return false;
        }
      }
    }
    return false;
  }

  // Share a downloaded file with other apps
  Future<void> shareDownloadedFile(OfflineDownloadItem item) async {
    if (item.localFilePath == null ||
        item.status != DownloadStatus.downloaded) {
      debugPrint('Cannot share file: File not downloaded or path is null');
      return;
    }

    final file = File(item.localFilePath!);
    if (!await file.exists()) {
      debugPrint(
          'Cannot share file: File does not exist at ${item.localFilePath}');
      return;
    }

    debugPrint('Attempting to share file: ${item.localFilePath}');

    try {
      // Get file mime type based on extension
      String? mimeType;
      final path = item.localFilePath!.toLowerCase();
      if (path.endsWith('.pdf')) {
        mimeType = 'application/pdf';
      } else if (path.endsWith('.doc') || path.endsWith('.docx')) {
        mimeType = 'application/msword';
      } else if (path.endsWith('.jpg') || path.endsWith('.jpeg')) {
        mimeType = 'image/jpeg';
      } else if (path.endsWith('.png')) {
        mimeType = 'image/png';
      } else if (path.endsWith('.txt')) {
        mimeType = 'text/plain';
      }

      // Share with specified mime type if available
      await Share.shareXFiles(
        [XFile(item.localFilePath!, mimeType: mimeType)],
        text: 'Sharing ${item.name}',
        subject: item.name,
      );

      debugPrint('File shared successfully');
    } catch (e) {
      debugPrint('Error sharing file: $e');

      // Fallback for Android: try using intent
      if (Platform.isAndroid) {
        try {
          debugPrint('Trying Android intent for sharing');
          await Process.run('am', [
            'start',
            '--user',
            '0',
            '-a',
            'android.intent.action.SEND',
            '-t',
            '*/*',
            '--eu',
            'android.intent.extra.STREAM',
            'file://${item.localFilePath}',
          ]);
          return;
        } catch (intentError) {
          debugPrint('Android intent sharing failed: $intentError');
        }
      }

      // If all else fails, rethrow the error
      throw Exception('Failed to share file: $e');
    }
  }
}
