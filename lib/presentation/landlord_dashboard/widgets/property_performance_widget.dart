import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PropertyPerformanceWidget extends StatelessWidget {
  final double occupancyRate;
  final double rentCollectionRate;
  final double maintenanceCosts;

  const PropertyPerformanceWidget({
    super.key,
    required this.occupancyRate,
    required this.rentCollectionRate,
    required this.maintenanceCosts,
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
        children: [
          _buildPerformanceMetric(
            title: 'Occupancy Rate',
            value: occupancyRate,
            maxValue: 100,
            color: AppTheme.successGreen,
            suffix: '%',
            icon: 'home',
          ),
          SizedBox(height: 3.h),
          _buildPerformanceMetric(
            title: 'Rent Collection',
            value: rentCollectionRate,
            maxValue: 100,
            color: AppTheme.primaryRed,
            suffix: '%',
            icon: 'payment',
          ),
          SizedBox(height: 3.h),
          _buildMaintenanceCosts(),
        ],
      ),
    );
  }

  Widget _buildPerformanceMetric({
    required String title,
    required double value,
    required double maxValue,
    required Color color,
    required String suffix,
    required String icon,
  }) {
    final percentage = (value / maxValue).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: icon,
                  color: color,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Text(
              '${value.toStringAsFixed(1)}$suffix',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: AppTheme.borderSubtle,
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: percentage,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMaintenanceCosts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'build',
                  color: Color(0xFFED8936),
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Maintenance Costs',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Text(
              '\$${(maintenanceCosts / 1000).toStringAsFixed(1)}K',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: Color(0xFFED8936),
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: AppTheme.surfaceGray,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'This Month',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    Text(
                      '\$${maintenanceCosts.toStringAsFixed(0)}',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: AppTheme.successGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'trending_down',
                      color: AppTheme.successGreen,
                      size: 12,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      '12%',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.successGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
