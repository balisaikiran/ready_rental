import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PropertyCardWidget extends StatelessWidget {
  final Map<String, dynamic> property;
  final VoidCallback onInterested;
  final VoidCallback onTap;

  const PropertyCardWidget({
    super.key,
    required this.property,
    required this.onInterested,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isInterested = property['isInterested'] as bool? ?? false;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 4.w),
        decoration: BoxDecoration(
          color: AppTheme.backgroundWhite,
          borderRadius: BorderRadius.circular(12),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSection(isInterested),
            _buildContentSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(bool isInterested) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          child: CustomImageWidget(
            imageUrl: property['imageUrl'] as String,
            width: double.infinity,
            height: 25.h,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 2.w,
          right: 2.w,
          child: GestureDetector(
            onTap: onInterested,
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.backgroundWhite.withValues(alpha: 0.9),
                shape: BoxShape.circle,
                boxShadow: AppTheme.cardShadow,
              ),
              child: CustomIconWidget(
                iconName: isInterested ? 'favorite' : 'favorite_border',
                color:
                    isInterested ? AppTheme.primaryRed : AppTheme.textSecondary,
                size: 20,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 2.w,
          left: 2.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.w),
            decoration: BoxDecoration(
              color: AppTheme.primaryRed,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              property['price'] as String,
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.backgroundWhite,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContentSection() {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            property['title'] as String,
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 1.h),
          Text(
            property['address'] as String,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              _buildFeatureChip(
                icon: 'bed',
                text: '${property['bedrooms']} bed',
              ),
              SizedBox(width: 2.w),
              _buildFeatureChip(
                icon: 'bathtub',
                text: '${property['bathrooms']} bath',
              ),
              SizedBox(width: 2.w),
              _buildFeatureChip(
                icon: 'location_on',
                text: property['distance'] as String,
              ),
              Spacer(),
              _buildRating(),
            ],
          ),
          SizedBox(height: 2.h),
          _buildAmenities(),
        ],
      ),
    );
  }

  Widget _buildFeatureChip({required String icon, required String text}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceGray,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: icon,
            color: AppTheme.textSecondary,
            size: 14,
          ),
          SizedBox(width: 1.w),
          Text(
            text,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRating() {
    final rating = property['rating'] as double? ?? 0.0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomIconWidget(
          iconName: 'star',
          color: Colors.amber,
          size: 16,
        ),
        SizedBox(width: 1.w),
        Text(
          rating.toStringAsFixed(1),
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildAmenities() {
    final amenities = (property['amenities'] as List).cast<String>();

    if (amenities.isEmpty) return SizedBox.shrink();

    return Wrap(
      spacing: 2.w,
      runSpacing: 1.w,
      children: amenities
          .take(3)
          .map((amenity) => Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.w),
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.borderSubtle),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  amenity,
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ))
          .toList(),
    );
  }
}
