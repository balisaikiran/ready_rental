import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DocumentItemWidget extends StatelessWidget {
  final Map<String, dynamic> document;
  final VoidCallback onTap;
  final VoidCallback onShare;
  final VoidCallback onDelete;

  const DocumentItemWidget({
    super.key,
    required this.document,
    required this.onTap,
    required this.onShare,
    required this.onDelete,
  });

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 7) {
      return '${difference}d ago';
    } else if (difference < 30) {
      return '${(difference / 7).floor()}w ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  IconData _getFileTypeIcon() {
    final fileName = document['name'].toString().toLowerCase();
    if (fileName.endsWith('.pdf')) {
      return Icons.picture_as_pdf;
    } else if (fileName.endsWith('.doc') || fileName.endsWith('.docx')) {
      return Icons.description;
    } else if (fileName.endsWith('.xls') || fileName.endsWith('.xlsx')) {
      return Icons.table_chart;
    } else if (fileName.endsWith('.jpg') || fileName.endsWith('.png')) {
      return Icons.image;
    } else {
      return Icons.insert_drive_file;
    }
  }

  Color _getFileTypeColor() {
    final fileName = document['name'].toString().toLowerCase();
    if (fileName.endsWith('.pdf')) {
      return Colors.red;
    } else if (fileName.endsWith('.doc') || fileName.endsWith('.docx')) {
      return Colors.blue;
    } else if (fileName.endsWith('.xls') || fileName.endsWith('.xlsx')) {
      return Colors.green;
    } else if (fileName.endsWith('.jpg') || fileName.endsWith('.png')) {
      return Colors.orange;
    } else {
      return AppTheme.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final downloadProgress = document['downloadProgress'] as double?;

    return Dismissible(
      key: Key('doc_${document['id']}'),
      background: Container(
        decoration: BoxDecoration(
          color: AppTheme.successGreen,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 4.w),
        child: CustomIconWidget(
          iconName: 'share',
          color: AppTheme.backgroundWhite,
          size: 24,
        ),
      ),
      secondaryBackground: Container(
        decoration: BoxDecoration(
          color: AppTheme.primaryRed,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 4.w),
        child: CustomIconWidget(
          iconName: 'delete',
          color: AppTheme.backgroundWhite,
          size: 24,
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          return await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Delete Document'),
              content: Text('Are you sure you want to delete this document?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text('Delete',
                      style: TextStyle(color: AppTheme.primaryRed)),
                ),
              ],
            ),
          );
        } else {
          onShare();
          return false;
        }
      },
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          onDelete();
        }
      },
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: AppTheme.surfaceGray,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.borderSubtle),
          ),
          child: Row(
            children: [
              // File thumbnail or icon
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: _getFileTypeColor().withAlpha(26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getFileTypeIcon(),
                  color: _getFileTypeColor(),
                  size: 20,
                ),
              ),

              SizedBox(width: 3.w),

              // Document details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            document['name'],
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (document['isSecure'] == true) ...[
                          SizedBox(width: 2.w),
                          CustomIconWidget(
                            iconName: 'lock',
                            color: AppTheme.primaryRed,
                            size: 14,
                          ),
                        ],
                        if (document['isOfflineAvailable'] == true) ...[
                          SizedBox(width: 2.w),
                          CustomIconWidget(
                            iconName: 'offline_pin',
                            color: AppTheme.successGreen,
                            size: 14,
                          ),
                        ],
                      ],
                    ),

                    SizedBox(height: 0.5.h),

                    Row(
                      children: [
                        Text(
                          document['propertyName'],
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        Text(
                          ' • ',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        Text(
                          document['size'],
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        Text(
                          ' • ',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        Text(
                          _formatDate(document['date']),
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),

                    // Download progress if applicable
                    if (downloadProgress != null) ...[
                      SizedBox(height: 1.h),
                      Row(
                        children: [
                          Expanded(
                            child: LinearProgressIndicator(
                              value: downloadProgress,
                              backgroundColor: AppTheme.borderSubtle,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.primaryRed),
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            '${(downloadProgress * 100).toInt()}%',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // More actions button
              IconButton(
                onPressed: () => _showMoreActions(context),
                icon: CustomIconWidget(
                  iconName: 'more_vert',
                  color: AppTheme.textSecondary,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMoreActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.backgroundWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.borderSubtle,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'open_in_new',
                color: AppTheme.textSecondary,
                size: 24,
              ),
              title: Text('Open Document'),
              onTap: () {
                Navigator.pop(context);
                onTap();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: AppTheme.successGreen,
                size: 24,
              ),
              title: Text('Share Document'),
              onTap: () {
                Navigator.pop(context);
                onShare();
              },
            ),
            if (document['isOfflineAvailable'] != true)
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'download',
                  color: AppTheme.primaryRed,
                  size: 24,
                ),
                title: Text('Download for Offline'),
                onTap: () {
                  Navigator.pop(context);
                  // Implement offline download
                },
              ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'delete',
                color: AppTheme.primaryRed,
                size: 24,
              ),
              title: Text('Delete Document'),
              onTap: () {
                Navigator.pop(context);
                onDelete();
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
