import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/offline_download_item.dart';
import '../../../providers/offline_downloads_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OfflineDownloadCard extends StatelessWidget {
  final OfflineDownloadItem item;

  const OfflineDownloadCard({
    Key? key,
    required this.item,
  }) : super(key: key);

  // Helper to get an appropriate icon based on file type
  IconData _getIconForType(String fileType) {
    switch (fileType.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf_outlined;
      case 'doc':
      case 'docx':
        return Icons.description_outlined;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image_outlined;
      default:
        return Icons.insert_drive_file_outlined;
    }
  }

  // Helper to get a human-readable date string
  String _getFormattedDate(BuildContext context, DateTime? date) {
    if (date == null) return '';

    // Format: 'Jan 01, 2023'
    final month = _getShortMonthName(context, date.month);
    return '$month ${date.day}, ${date.year}';
  }

  // Helper to get short month name
  String _getShortMonthName(BuildContext context, int month) {
    final l10n = AppLocalizations.of(context)!;

    // You would need to add these localizations to your app_*.arb files
    switch (month) {
      case 1:
        return l10n.monthJan;
      case 2:
        return l10n.monthFeb;
      case 3:
        return l10n.monthMar;
      case 4:
        return l10n.monthApr;
      case 5:
        return l10n.monthMay;
      case 6:
        return l10n.monthJun;
      case 7:
        return l10n.monthJul;
      case 8:
        return l10n.monthAug;
      case 9:
        return l10n.monthSep;
      case 10:
        return l10n.monthOct;
      case 11:
        return l10n.monthNov;
      case 12:
        return l10n.monthDec;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final offlineDownloadsProvider =
        Provider.of<OfflineDownloadsProvider>(context);

    return Card(
      elevation: 1.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          foregroundColor: theme.colorScheme.onPrimaryContainer,
          child: Icon(_getIconForType(item.guessedFileType)),
        ),
        title: Text(
          item.name,
          style: theme.textTheme.titleMedium,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4.0),
            Text(
              item.category,
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 4.0),
            // Show download progress or date based on status
            if (item.status == DownloadStatus.downloading)
              LinearProgressIndicator(
                value: item.progress,
                backgroundColor: theme.colorScheme.surfaceVariant,
                valueColor:
                    AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
              )
            else if (item.status == DownloadStatus.downloaded &&
                item.downloadDate != null)
              Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                    size: 16.0,
                  ),
                  const SizedBox(width: 4.0),
                  Text(
                    '${l10n.downloadedOn} ${_getFormattedDate(context, item.downloadDate)}',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              )
            else if (item.status == DownloadStatus.failed)
              Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 16.0,
                  ),
                  const SizedBox(width: 4.0),
                  Text(
                    l10n.downloadFailed,
                    style:
                        theme.textTheme.bodySmall?.copyWith(color: Colors.red),
                  ),
                ],
              ),
          ],
        ),
        trailing:
            _buildActionButtons(context, offlineDownloadsProvider, l10n, theme),
        onTap: () {
          if (item.status == DownloadStatus.downloaded) {
            offlineDownloadsProvider.openOfflineDownload(item.id);
          }
        },
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    OfflineDownloadsProvider provider,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    // Different actions based on download status
    switch (item.status) {
      case DownloadStatus.notDownloaded:
        return IconButton(
          icon: const Icon(Icons.download),
          tooltip: l10n.downloadTooltip,
          onPressed: () {
            // Since we don't have direct access to DownloadItem here,
            // we'll need to handle this in the parent screen
            // This button should typically not appear in this context
          },
        );

      case DownloadStatus.downloading:
        return IconButton(
          icon: const Icon(Icons.cancel_outlined),
          tooltip: l10n.cancelDownloadTooltip,
          onPressed: () {
            provider.cancelDownload(item.id);
          },
        );

      case DownloadStatus.downloaded:
        return PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          tooltip: l10n.moreOptionsTooltip,
          onSelected: (value) async {
            switch (value) {
              case 'open':
                await provider.openOfflineDownload(item.id);
                break;
              case 'export':
                await provider.exportFile(item.id);
                break;
              case 'delete':
                await provider.deleteOfflineDownload(item.id);
                break;
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem<String>(
              value: 'open',
              child: Row(
                children: [
                  Icon(Icons.open_in_new,
                      size: 20, color: theme.iconTheme.color),
                  const SizedBox(width: 8),
                  Text(l10n.openFileActionText),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'export',
              child: Row(
                children: [
                  Icon(Icons.save_alt, size: 20, color: theme.iconTheme.color),
                  const SizedBox(width: 8),
                  Text(l10n.exportFileActionText),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete_outline, size: 20, color: Colors.red),
                  const SizedBox(width: 8),
                  Text(l10n.deleteFileActionText,
                      style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        );

      case DownloadStatus.failed:
        return IconButton(
          icon: const Icon(Icons.refresh),
          tooltip: l10n.retryDownloadTooltip,
          onPressed: () {
            // Will need handling in parent screen
          },
        );
    }
  }
}
