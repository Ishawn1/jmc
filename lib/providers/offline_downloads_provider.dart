import 'package:flutter/foundation.dart';
import '../models/offline_download_item.dart';
import '../services/database_service.dart';
import '../services/download_service.dart';
import '../features/downloads/screens/downloads_list_screen.dart';
import 'dart:io';

/// A provider class for managing offline downloads.
///
/// This class handles the downloading, storing, and retrieving of files for
/// offline access. It interacts with [DatabaseService] to persist download
/// metadata and with [DownloadService] to perform the actual file downloads.
class OfflineDownloadsProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService.instance;
  final DownloadService _downloadService = DownloadService.instance;

  List<OfflineDownloadItem> _offlineDownloads = [];
  bool _isLoading = false;
  String? _error;

  /// A list of all offline download items.
  List<OfflineDownloadItem> get offlineDownloads =>
      List.unmodifiable(_offlineDownloads);

  /// A boolean indicating whether the provider is currently loading data.
  bool get isLoading => _isLoading;

  /// An error message, if any, that occurred during an operation.
  String? get error => _error;

  /// Creates an instance of [OfflineDownloadsProvider] and loads the offline
  /// downloads from the database.
  OfflineDownloadsProvider() {
    loadOfflineDownloads();
  }

  /// Loads all offline downloads from the database.
  Future<void> loadOfflineDownloads() async {
    _setLoading(true);
    try {
      _offlineDownloads = await _databaseService.getAllOfflineDownloads();
      _error = null;
    } catch (e) {
      _error = 'Failed to load offline downloads: ${e.toString()}';
      debugPrint(_error);
    } finally {
      _setLoading(false);
    }
  }

  /// Downloads a file and saves it for offline access.
  ///
  /// This method checks if the item is already being downloaded or has been
  /// downloaded. If not, it initiates the download process and updates the
  /// UI with the progress.
  Future<void> downloadFile(DownloadItem item) async {
    // Check if the item is already in the downloads list
    final String itemId = item.url.hashCode.toString();
    final existingItem =
        _offlineDownloads.where((d) => d.id == itemId).firstOrNull;

    if (existingItem != null) {
      if (existingItem.status == DownloadStatus.downloading) {
        // Already downloading, do nothing
        return;
      } else if (existingItem.status == DownloadStatus.downloaded) {
        // Already downloaded, do nothing
        return;
      }
    }

    // Create offline download item from download item
    final offlineItem = OfflineDownloadItem.fromDownloadItem(item);

    // Save initial state to database
    await _databaseService.saveOfflineDownload(offlineItem);

    // Add to list if not exists
    if (existingItem == null) {
      _offlineDownloads.add(offlineItem);
      notifyListeners();
    }

    try {
      // Start download
      final downloadedItem = await _downloadService.downloadFile(
        offlineItem,
        onProgress: (progress) {
          // Update UI with progress
          _updateDownloadProgress(offlineItem.id, progress);
        },
      );

      // Update list with downloaded item
      final index = _offlineDownloads.indexWhere((d) => d.id == offlineItem.id);
      if (index != -1) {
        _offlineDownloads[index] = downloadedItem;
        notifyListeners();
      }

      _error = null;
    } catch (e) {
      _error = 'Failed to download file: ${e.toString()}';
      debugPrint(_error);
      notifyListeners();
    }
  }

  /// Cancels an ongoing download.
  Future<void> cancelDownload(String id) async {
    await _downloadService.cancelDownload(id);

    // Update list
    final index = _offlineDownloads.indexWhere((d) => d.id == id);
    if (index != -1) {
      _offlineDownloads[index] = _offlineDownloads[index].copyWith(
        status: DownloadStatus.notDownloaded,
        progress: 0.0,
      );
      notifyListeners();
    }
  }

  /// Deletes an offline download from the device.
  Future<void> deleteOfflineDownload(String id) async {
    final item = _offlineDownloads.where((d) => d.id == id).firstOrNull;
    if (item != null) {
      await _downloadService.deleteDownloadedFile(item);

      // Remove from list
      _offlineDownloads.removeWhere((d) => d.id == id);
      notifyListeners();
    }
  }

  /// Opens a downloaded file.
  Future<void> openOfflineDownload(String id) async {
    final item = _offlineDownloads.where((d) => d.id == id).firstOrNull;

    if (item == null) {
      _error = 'Cannot find download item with ID: $id';
      debugPrint(_error);
      notifyListeners();
      return;
    }

    if (item.status != DownloadStatus.downloaded) {
      _error = 'Cannot open file: item is not downloaded';
      debugPrint(_error);
      notifyListeners();
      return;
    }

    if (item.localFilePath == null) {
      _error = 'Cannot open file: local file path is null';
      debugPrint(_error);
      notifyListeners();
      return;
    }

    // Check if file exists before attempting to open
    final file = File(item.localFilePath!);
    if (!await file.exists()) {
      _error =
          'Cannot open file: file does not exist at path ${item.localFilePath}';
      debugPrint(_error);
      notifyListeners();
      return;
    }

    debugPrint('Attempting to open file: ${item.localFilePath}');

    try {
      await _downloadService.openDownloadedFile(item);
    } catch (e) {
      _error = 'Failed to open file: ${e.toString()}';
      debugPrint('Error details: $e');
      notifyListeners();

      // Try exporting as fallback
      try {
        final exported = await _downloadService.exportFile(item);
        if (exported) {
          _error = null;
          notifyListeners();
        }
      } catch (exportError) {
        debugPrint('Export fallback also failed: $exportError');
      }
    }
  }

  /// Exports a downloaded file to external storage.
  ///
  /// Returns `true` if the file was exported successfully, `false` otherwise.
  Future<bool> exportFile(String id) async {
    final item = _offlineDownloads.where((d) => d.id == id).firstOrNull;
    if (item != null && item.status == DownloadStatus.downloaded) {
      return await _downloadService.exportFile(item);
    }
    return false;
  }

  // Update download progress in the list
  void _updateDownloadProgress(String id, double progress) {
    final index = _offlineDownloads.indexWhere((d) => d.id == id);
    if (index != -1) {
      _offlineDownloads[index] = _offlineDownloads[index].copyWith(
        status: DownloadStatus.downloading,
        progress: progress,
      );
      notifyListeners();
    }
  }

  // Update loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
