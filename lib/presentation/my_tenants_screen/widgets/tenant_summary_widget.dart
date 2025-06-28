import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TenantSummaryWidget extends StatelessWidget {
  final Map<String, int> tenantCounts;

  const TenantSummaryWidget({
    super.key,
    required this.tenantCounts,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tenant Overview',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.backgroundWhite,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  'Total',
                  '${_getTotalTenants()}',
                  CustomIconWidget(
                    iconName: 'group',
                    color: AppTheme.backgroundWhite,
                    size: 24,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildSummaryCard(
                  'Active',
                  '${tenantCounts['active'] ?? 0}',
                  CustomIconWidget(
                    iconName: 'check_circle',
                    color: AppTheme.successGreen,
                    size: 24,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildSummaryCard(
                  'Pending',
                  '${tenantCounts['pending'] ?? 0}',
                  CustomIconWidget(
                    iconName: 'schedule',
                    color: Colors.orange,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  int _getTotalTenants() {
    return (tenantCounts['active'] ?? 0) +
        (tenantCounts['pending'] ?? 0) +
        (tenantCounts['expired'] ?? 0);
  }

  Widget _buildSummaryCard(String label, String count, Widget icon) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.backgroundWhite.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          icon,
          SizedBox(height: 1.h),
          Text(
            count,
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.backgroundWhite,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.backgroundWhite.withValues(alpha: 0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
