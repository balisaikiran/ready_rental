import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class FilterBottomSheetWidget extends StatefulWidget {
  final String selectedFilter;
  final Function(String) onFilterChanged;

  const FilterBottomSheetWidget({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  State<FilterBottomSheetWidget> createState() =>
      _FilterBottomSheetWidgetState();
}

class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget> {
  late String _selectedFilter;
  String _selectedDateRange = 'All Time';
  String _selectedProperty = 'All Properties';

  final List<String> _filterOptions = [
    'All',
    'Leases',
    'Applications',
    'Property Documents',
    'Financial Records',
  ];

  final List<String> _dateRangeOptions = [
    'All Time',
    'Last 7 days',
    'Last 30 days',
    'Last 3 months',
    'Last year',
  ];

  final List<String> _propertyOptions = [
    'All Properties',
    'Oak Street Apartment',
    'Maple Avenue House',
    'Downtown Condo',
    'Suburban Villa',
  ];

  @override
  void initState() {
    super.initState();
    _selectedFilter = widget.selectedFilter;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 2.h),

          // Handle bar
          Container(
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.borderSubtle,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          SizedBox(height: 3.h),

          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter Documents',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedFilter = 'All';
                      _selectedDateRange = 'All Time';
                      _selectedProperty = 'All Properties';
                    });
                  },
                  child: Text('Reset'),
                ),
              ],
            ),
          ),

          SizedBox(height: 2.h),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Document Type Filter
                  _buildFilterSection(
                    'Document Type',
                    _filterOptions,
                    _selectedFilter,
                    (value) => setState(() => _selectedFilter = value),
                  ),

                  SizedBox(height: 3.h),

                  // Date Range Filter
                  _buildFilterSection(
                    'Date Range',
                    _dateRangeOptions,
                    _selectedDateRange,
                    (value) => setState(() => _selectedDateRange = value),
                  ),

                  SizedBox(height: 3.h),

                  // Property Filter
                  _buildFilterSection(
                    'Property',
                    _propertyOptions,
                    _selectedProperty,
                    (value) => setState(() => _selectedProperty = value),
                  ),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),

          // Apply button
          Padding(
            padding: EdgeInsets.all(4.w),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  widget.onFilterChanged(_selectedFilter);
                  Navigator.pop(context);
                },
                child: Text('Apply Filter'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(
    String title,
    List<String> options,
    String selectedValue,
    Function(String) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: options.map((option) {
            final isSelected = option == selectedValue;
            return InkWell(
              onTap: () => onChanged(option),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color:
                      isSelected ? AppTheme.primaryRed : AppTheme.surfaceGray,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.primaryRed
                        : AppTheme.borderSubtle,
                  ),
                ),
                child: Text(
                  option,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: isSelected
                        ? AppTheme.backgroundWhite
                        : AppTheme.textPrimary,
                    fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
