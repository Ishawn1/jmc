import 'package:flutter/foundation.dart';
import '../features/downloads/screens/downloads_list_screen.dart';

/// Represents the status of an offline download
enum DownloadStatus { notDownloaded, downloading, downloaded, failed }

/// Model class representing an offline download item
class OfflineDownloadItem {
  final String id;
  final String name;
  final String category;
  final String url;
  final String? fileType;
  final String? localFilePath;
  final DownloadStatus status;
  final double? progress;
  final DateTime? downloadDate;

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

  // Helper to guess file type from URL if not provided
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

  // Create a copy of this item with updated fields
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

  // Create an OfflineDownloadItem from a DownloadItem
  factory OfflineDownloadItem.fromDownloadItem(DownloadItem item) {
    return OfflineDownloadItem(
      id: item.url.hashCode.toString(), // Use URL hash as a unique ID
      name: item.name,
      category: item.category,
      url: item.url,
      fileType: item.fileType,
    );
  }

  // Convert to map for database storage
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

  // Create from map for database retrieval
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
