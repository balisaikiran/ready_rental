import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyDocumentsWidget extends StatelessWidget {
  final VoidCallback onUploadPressed;

  const EmptyDocumentsWidget({
    super.key,
    required this.onUploadPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: AppTheme.surfaceGray,
                borderRadius: BorderRadius.circular(20),
              ),
              child: CustomIconWidget(
                iconName: 'folder_open',
                color: AppTheme.textSecondary,
                size: 60,
              ),
            ),

            SizedBox(height: 4.h),

            // Title
            Text(
              'No Documents Yet',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: 2.h),

            // Subtitle
            Text(
              'Add your first document to get started.\nYou can upload leases, applications, property documents, and financial records.',
              textAlign: TextAlign.center,
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
            ),

            SizedBox(height: 4.h),

            // Upload button
            ElevatedButton.icon(
              onPressed: onUploadPressed,
              icon: CustomIconWidget(
                iconName: 'add',
                color: AppTheme.backgroundWhite,
                size: 20,
              ),
              label: Text('Add Your First Document'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryRed,
                foregroundColor: AppTheme.backgroundWhite,
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            SizedBox(height: 4.h),

            // Supported formats
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.surfaceGray,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.borderSubtle),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'info',
                        color: AppTheme.textSecondary,
                        size: 16,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Supported File Formats',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildFormatChip('PDF', Icons.picture_as_pdf, Colors.red),
                      _buildFormatChip('DOC', Icons.description, Colors.blue),
                      _buildFormatChip('XLS', Icons.table_chart, Colors.green),
                      _buildFormatChip('IMG', Icons.image, Colors.orange),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Maximum file size: 10MB',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormatChip(String label, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            color: color.withAlpha(26),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
