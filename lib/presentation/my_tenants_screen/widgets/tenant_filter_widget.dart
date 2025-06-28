import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class TenantFilterWidget extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onFiltersChanged;

  const TenantFilterWidget({
    super.key,
    required this.currentFilters,
    required this.onFiltersChanged,
  });

  @override
  State<TenantFilterWidget> createState() => _TenantFilterWidgetState();
}

class _TenantFilterWidgetState extends State<TenantFilterWidget> {
  late Map<String, dynamic> _tempFilters;

  final List<String> _leaseStatuses = ['All', 'Active', 'Pending', 'Expired'];
  final List<String> _paymentStatuses = ['All', 'Paid', 'Due', 'Overdue'];
  final List<String> _properties = [
    'All Properties',
    'Downtown Apt',
    'Midtown Loft',
    'Uptown House'
  ];

  @override
  void initState() {
    super.initState();
    _tempFilters = Map.from(widget.currentFilters);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.borderSubtle,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 3.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter Tenants',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: _resetFilters,
                  child: Text(
                    'Reset',
                    style: TextStyle(color: AppTheme.primaryRed),
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            _buildFilterSection(
              title: 'Lease Status',
              options: _leaseStatuses,
              selectedValue: _tempFilters['leaseStatus'] ?? 'All',
              onChanged: (value) {
                setState(() {
                  _tempFilters['leaseStatus'] = value;
                });
              },
            ),
            SizedBox(height: 3.h),
            _buildFilterSection(
              title: 'Payment Status',
              options: _paymentStatuses,
              selectedValue: _tempFilters['paymentStatus'] ?? 'All',
              onChanged: (value) {
                setState(() {
                  _tempFilters['paymentStatus'] = value;
                });
              },
            ),
            SizedBox(height: 3.h),
            _buildFilterSection(
              title: 'Property',
              options: _properties,
              selectedValue: _tempFilters['property'] ?? 'All Properties',
              onChanged: (value) {
                setState(() {
                  _tempFilters['property'] = value;
                });
              },
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onFiltersChanged(_tempFilters);
                      Navigator.pop(context);
                    },
                    child: Text('Apply Filters'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection({
    required String title,
    required List<String> options,
    required String selectedValue,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: options.map((option) {
            final isSelected = selectedValue == option;
            return GestureDetector(
              onTap: () => onChanged(option),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.primaryRed.withValues(alpha: 0.1)
                      : AppTheme.surfaceGray,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.primaryRed
                        : AppTheme.borderSubtle,
                  ),
                ),
                child: Text(
                  option,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color:
                        isSelected ? AppTheme.primaryRed : AppTheme.textPrimary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _resetFilters() {
    setState(() {
      _tempFilters = {
        'leaseStatus': 'All',
        'paymentStatus': 'All',
        'property': 'All Properties',
      };
    });
  }
}
