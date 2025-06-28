import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterBottomSheetWidget extends StatefulWidget {
  final Function(int) onFiltersApplied;

  const FilterBottomSheetWidget({
    super.key,
    required this.onFiltersApplied,
  });

  @override
  State<FilterBottomSheetWidget> createState() =>
      _FilterBottomSheetWidgetState();
}

class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget> {
  RangeValues _priceRange = RangeValues(1000, 5000);
  String _selectedPropertyType = '';
  int _bedrooms = 0;
  int _bathrooms = 0;
  double _distanceRadius = 5.0;
  final Set<String> _selectedAmenities = {};

  final List<String> _propertyTypes = [
    'Apartment',
    'House',
    'Condo',
    'Studio',
    'Loft',
    'Townhouse',
  ];

  final List<String> _amenities = [
    'Parking',
    'Gym',
    'Pool',
    'Laundry',
    'Pet Friendly',
    'Balcony',
    'Garden',
    'Concierge',
    'WiFi',
    'Air Conditioning',
  ];

  int get _activeFilterCount {
    int count = 0;
    if (_priceRange.start > 1000 || _priceRange.end < 5000) count++;
    if (_selectedPropertyType.isNotEmpty) count++;
    if (_bedrooms > 0) count++;
    if (_bathrooms > 0) count++;
    if (_distanceRadius < 5.0) count++;
    if (_selectedAmenities.isNotEmpty) count++;
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPriceRangeSection(),
                  _buildPropertyTypeSection(),
                  _buildBedroomsBathroomsSection(),
                  _buildDistanceSection(),
                  _buildAmenitiesSection(),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
          _buildBottomActions(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppTheme.borderSubtle),
        ),
      ),
      child: Row(
        children: [
          Text(
            'Filters',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Spacer(),
          if (_activeFilterCount > 0)
            TextButton(
              onPressed: _clearAllFilters,
              child: Text(
                'Clear All',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.primaryRed,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: CustomIconWidget(
              iconName: 'close',
              color: AppTheme.textSecondary,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRangeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 3.h),
        Text(
          'Price Range',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Text(
              '\$${_priceRange.start.round()}',
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Spacer(),
            Text(
              '\$${_priceRange.end.round()}',
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        RangeSlider(
          values: _priceRange,
          min: 500,
          max: 10000,
          divisions: 95,
          activeColor: AppTheme.primaryRed,
          inactiveColor: AppTheme.borderSubtle,
          onChanged: (values) {
            setState(() {
              _priceRange = values;
            });
          },
        ),
      ],
    );
  }

  Widget _buildPropertyTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 3.h),
        Text(
          'Property Type',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 2.w,
          children: _propertyTypes.map((type) {
            final isSelected = _selectedPropertyType == type;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedPropertyType = isSelected ? '' : type;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.w),
                decoration: BoxDecoration(
                  color:
                      isSelected ? AppTheme.primaryRed : AppTheme.surfaceGray,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.primaryRed
                        : AppTheme.borderSubtle,
                  ),
                ),
                child: Text(
                  type,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: isSelected
                        ? AppTheme.backgroundWhite
                        : AppTheme.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildBedroomsBathroomsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 3.h),
        Text(
          'Bedrooms & Bathrooms',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Expanded(
              child: _buildCounterWidget(
                label: 'Bedrooms',
                value: _bedrooms,
                onChanged: (value) {
                  setState(() {
                    _bedrooms = value;
                  });
                },
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: _buildCounterWidget(
                label: 'Bathrooms',
                value: _bathrooms,
                onChanged: (value) {
                  setState(() {
                    _bathrooms = value;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCounterWidget({
    required String label,
    required int value,
    required Function(int) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                if (value > 0) onChanged(value - 1);
              },
              child: Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.borderSubtle),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: CustomIconWidget(
                  iconName: 'remove',
                  color:
                      value > 0 ? AppTheme.textPrimary : AppTheme.textSecondary,
                  size: 16,
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 2.w),
                child: Text(
                  value == 0 ? 'Any' : value.toString(),
                  textAlign: TextAlign.center,
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (value < 5) onChanged(value + 1);
              },
              child: Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.borderSubtle),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: CustomIconWidget(
                  iconName: 'add',
                  color:
                      value < 5 ? AppTheme.textPrimary : AppTheme.textSecondary,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDistanceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 3.h),
        Text(
          'Distance Radius',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          '${_distanceRadius.toStringAsFixed(1)} miles',
          style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppTheme.primaryRed,
          ),
        ),
        Slider(
          value: _distanceRadius,
          min: 0.5,
          max: 20.0,
          divisions: 39,
          activeColor: AppTheme.primaryRed,
          inactiveColor: AppTheme.borderSubtle,
          onChanged: (value) {
            setState(() {
              _distanceRadius = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildAmenitiesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 3.h),
        Text(
          'Amenities',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 2.w,
          children: _amenities.map((amenity) {
            final isSelected = _selectedAmenities.contains(amenity);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedAmenities.remove(amenity);
                  } else {
                    _selectedAmenities.add(amenity);
                  }
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.w),
                decoration: BoxDecoration(
                  color:
                      isSelected ? AppTheme.primaryRed : AppTheme.surfaceGray,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.primaryRed
                        : AppTheme.borderSubtle,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isSelected)
                      Padding(
                        padding: EdgeInsets.only(right: 1.w),
                        child: CustomIconWidget(
                          iconName: 'check',
                          color: AppTheme.backgroundWhite,
                          size: 14,
                        ),
                      ),
                    Text(
                      amenity,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: isSelected
                            ? AppTheme.backgroundWhite
                            : AppTheme.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        border: Border(
          top: BorderSide(color: AppTheme.borderSubtle),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _clearAllFilters,
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 3.h),
              ),
              child: Text('Clear All'),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () {
                widget.onFiltersApplied(_activeFilterCount);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 3.h),
              ),
              child: Text(
                _activeFilterCount > 0
                    ? 'Apply Filters ($_activeFilterCount)'
                    : 'Apply Filters',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _clearAllFilters() {
    setState(() {
      _priceRange = RangeValues(1000, 5000);
      _selectedPropertyType = '';
      _bedrooms = 0;
      _bathrooms = 0;
      _distanceRadius = 5.0;
      _selectedAmenities.clear();
    });
  }
}
