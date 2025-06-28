import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PropertyPerformanceWidget extends StatelessWidget {
  final Map<String, dynamic> data;

  const PropertyPerformanceWidget({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data["value"] ?? '',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            data["title"] ?? '',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconWidget(
                iconName: data["isPositive"] == true
                    ? 'trending_up'
                    : 'trending_down',
                color: data["isPositive"] == true
                    ? AppTheme.successGreen
                    : AppTheme.primaryRed,
                size: 4.w,
              ),
              SizedBox(width: 1.w),
              Text(
                data["trend"] ?? '',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: data["isPositive"] == true
                      ? AppTheme.successGreen
                      : AppTheme.primaryRed,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
