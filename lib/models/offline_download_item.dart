import 'package:flutter/foundation.dart';
import '../features/downloads/screens/downloads_list_screen.dart';

/// Represents the status of an offline download.
enum DownloadStatus {
  /// The item has not been downloaded yet.
  notDownloaded,

  /// The item is currently being downloaded.
  downloading,

  /// The item has been successfully downloaded.
  downloaded,

  /// The download failed.
  failed,
}

/// A model class that represents an offline download item.
///
/// This class stores information about a downloaded file, including its ID,
/// name, category, URL, local file path, and download status.
class OfflineDownloadItem {
  /// A unique identifier for the download item.
  final String id;

  /// The name of the download item.
  final String name;

  /// The category to which the item belongs.
  final String category;

  /// The original URL of the item.
  final String url;

  /// The file type of the item (e.g., 'pdf', 'doc').
  final String? fileType;

  /// The local path where the file is stored.
  final String? localFilePath;

  /// The current status of the download.
  final DownloadStatus status;

  /// The download progress, from 0.0 to 1.0.
  final double? progress;

  /// The date and time when the download was completed.
  final DateTime? downloadDate;

  /// Creates an instance of [OfflineDownloadItem].
  const OfflineDownloadItem({
    required this.id,
    required this.name,
    required this.category,
    required this.url,
    this.fileType,
    this.localFilePath,
    this.status = DownloadStatus.notDownloaded,
    this.progress = 0.0,
    this.downloadDate,
  });

  /// Guesses the file type from the URL if not explicitly provided.
  String get guessedFileType {
    if (fileType != null) return fileType!;
    if (url.toLowerCase().endsWith('.pdf')) return 'pdf';
    if (url.toLowerCase().endsWith('.doc') ||
        url.toLowerCase().endsWith('.docx')) return 'doc';
    if (url.toLowerCase().endsWith('.jpg') ||
        url.toLowerCase().endsWith('.jpeg')) return 'jpg';
    if (url.toLowerCase().endsWith('.png')) return 'png';
    return 'unknown';
  }

  /// Creates a copy of this item with updated fields.
  OfflineDownloadItem copyWith({
    String? id,
    String? name,
    String? category,
    String? url,
    String? fileType,
    String? localFilePath,
    DownloadStatus? status,
    double? progress,
    DateTime? downloadDate,
  }) {
    return OfflineDownloadItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      url: url ?? this.url,
      fileType: fileType ?? this.fileType,
      localFilePath: localFilePath ?? this.localFilePath,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      downloadDate: downloadDate ?? this.downloadDate,
    );
  }

  /// Creates an [OfflineDownloadItem] from a [DownloadItem].
  factory OfflineDownloadItem.fromDownloadItem(DownloadItem item) {
    return OfflineDownloadItem(
      id: item.url.hashCode.toString(), // Use URL hash as a unique ID
      name: item.name,
      category: item.category,
      url: item.url,
      fileType: item.fileType,
    );
  }

  /// Converts the item to a map for database storage.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'url': url,
      'fileType': fileType,
      'localFilePath': localFilePath,
      'status': status.index,
      'progress': progress,
      'downloadDate': downloadDate?.millisecondsSinceEpoch,
    };
  }

  /// Creates an [OfflineDownloadItem] from a map retrieved from a database.
  factory OfflineDownloadItem.fromMap(Map<String, dynamic> map) {
    return OfflineDownloadItem(
      id: map['id'],
      name: map['name'],
      category: map['category'],
      url: map['url'],
      fileType: map['fileType'],
      localFilePath: map['localFilePath'],
      status: DownloadStatus.values[map['status'] ?? 0],
      progress: map['progress'],
      downloadDate: map['downloadDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['downloadDate'])
          : null,
    );
  }
}
