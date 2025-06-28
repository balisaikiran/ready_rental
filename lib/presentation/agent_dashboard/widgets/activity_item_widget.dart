import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ActivityItemWidget extends StatelessWidget {
  final Map<String, dynamic> data;
  final Function(String) onAction;

  const ActivityItemWidget({
    super.key,
    required this.data,
    required this.onAction,
  });

  Color _getPriorityColor() {
    switch (data["priority"]) {
      case "high":
        return AppTheme.primaryRed;
      case "medium":
        return Color(0xFFED8936);
      case "low":
        return AppTheme.successGreen;
      default:
        return AppTheme.textSecondary;
    }
  }

  IconData _getTypeIcon() {
    switch (data["type"]) {
      case "application":
        return Icons.description;
      case "message":
        return Icons.message;
      case "inquiry":
        return Icons.help_outline;
      case "service":
        return Icons.build;
      default:
        return Icons.notifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(data["id"].toString()),
      background: Container(
        color: AppTheme.successGreen.withValues(alpha: 0.1),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 4.w),
        child: CustomIconWidget(
          iconName: 'reply',
          color: AppTheme.successGreen,
          size: 6.w,
        ),
      ),
      secondaryBackground: Container(
        color: AppTheme.textSecondary.withValues(alpha: 0.1),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 4.w),
        child: CustomIconWidget(
          iconName: 'archive',
          color: AppTheme.textSecondary,
          size: 6.w,
        ),
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          onAction('respond');
        } else {
          onAction('archive');
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 2.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.backgroundWhite,
          borderRadius: BorderRadius.circular(12),
          boxShadow: AppTheme.cardShadow,
          border: Border.all(
            color: AppTheme.borderSubtle,
            width: 1,
          ),
        ),
        child: InkWell(
          onTap: () => onAction('view'),
          onLongPress: () => _showContextMenu(context),
          borderRadius: BorderRadius.circular(12),
          child: Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 6.w,
                    backgroundImage: data["avatar"] != null
                        ? NetworkImage(data["avatar"])
                        : null,
                    child: data["avatar"] == null
                        ? CustomIconWidget(
                            iconName: 'person',
                            color: AppTheme.textSecondary,
                            size: 6.w,
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 4.w,
                      height: 4.w,
                      decoration: BoxDecoration(
                        color: _getPriorityColor(),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: AppTheme.backgroundWhite,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: _getTypeIcon().codePoint.toString(),
                          color: AppTheme.textSecondary,
                          size: 4.w,
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            data["title"] ?? '',
                            style: AppTheme.lightTheme.textTheme.titleSmall
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      data["description"] ?? '',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      data["timestamp"] ?? '',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              CustomIconWidget(
                iconName: 'chevron_right',
                color: AppTheme.textSecondary,
                size: 5.w,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
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
            Text(
              'Activity Actions',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'reply',
                color: AppTheme.successGreen,
                size: 6.w,
              ),
              title: Text('Respond'),
              onTap: () {
                Navigator.pop(context);
                onAction('respond');
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'schedule',
                color: AppTheme.primaryRed,
                size: 6.w,
              ),
              title: Text('Schedule'),
              onTap: () {
                Navigator.pop(context);
                onAction('schedule');
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'group',
                color: Color(0xFF3182CE),
                size: 6.w,
              ),
              title: Text('Delegate'),
              onTap: () {
                Navigator.pop(context);
                onAction('delegate');
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
