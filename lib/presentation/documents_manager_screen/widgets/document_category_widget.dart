import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './document_item_widget.dart';

class DocumentCategoryWidget extends StatefulWidget {
  final String category;
  final List<Map<String, dynamic>> documents;
  final Function(Map<String, dynamic>) onDocumentTap;
  final Function(Map<String, dynamic>) onDocumentShare;
  final Function(Map<String, dynamic>) onDocumentDelete;

  const DocumentCategoryWidget({
    super.key,
    required this.category,
    required this.documents,
    required this.onDocumentTap,
    required this.onDocumentShare,
    required this.onDocumentDelete,
  });

  @override
  State<DocumentCategoryWidget> createState() => _DocumentCategoryWidgetState();
}

class _DocumentCategoryWidgetState extends State<DocumentCategoryWidget> {
  bool _isExpanded = true;

  IconData _getCategoryIcon() {
    switch (widget.category) {
      case 'Leases':
        return Icons.description;
      case 'Applications':
        return Icons.assignment;
      case 'Property Documents':
        return Icons.home;
      case 'Financial Records':
        return Icons.account_balance;
      default:
        return Icons.folder;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          // Category header
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(12),
              bottom: _isExpanded ? Radius.zero : Radius.circular(12),
            ),
            child: Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.surfaceGray,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(12),
                  bottom: _isExpanded ? Radius.zero : Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _getCategoryIcon(),
                    color: AppTheme.primaryRed,
                    size: 20,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    widget.category,
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Spacer(),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryRed,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      widget.documents.length.toString(),
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.backgroundWhite,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: Duration(milliseconds: 200),
                    child: CustomIconWidget(
                      iconName: 'keyboard_arrow_down',
                      color: AppTheme.textSecondary,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Documents list
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            height: _isExpanded ? null : 0,
            child: _isExpanded
                ? ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(4.w),
                    itemCount: widget.documents.length,
                    separatorBuilder: (context, index) => SizedBox(height: 1.h),
                    itemBuilder: (context, index) {
                      return DocumentItemWidget(
                        document: widget.documents[index],
                        onTap: () =>
                            widget.onDocumentTap(widget.documents[index]),
                        onShare: () =>
                            widget.onDocumentShare(widget.documents[index]),
                        onDelete: () =>
                            widget.onDocumentDelete(widget.documents[index]),
                      );
                    },
                  )
                : SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
