import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AmenitiesWidget extends StatelessWidget {
  final List<Map<String, dynamic>> amenities;

  const AmenitiesWidget({
    super.key,
    required this.amenities,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Amenities',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: 2.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children:
                amenities.map((amenity) => _buildAmenityChip(amenity)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenityChip(Map<String, dynamic> amenity) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
      decoration: BoxDecoration(
        color: AppTheme.primaryRed.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppTheme.primaryRed.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: amenity['icon'] ?? 'check_circle',
            color: AppTheme.primaryRed,
            size: 16,
          ),
          SizedBox(width: 2.w),
          Text(
            amenity['name'] ?? 'Amenity',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.primaryRed,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
