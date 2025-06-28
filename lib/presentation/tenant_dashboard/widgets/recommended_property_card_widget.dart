import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecommendedPropertyCardWidget extends StatelessWidget {
  final Map<String, dynamic> property;
  final VoidCallback onInterested;
  final VoidCallback onShare;
  final VoidCallback onContactAgent;

  const RecommendedPropertyCardWidget({
    super.key,
    required this.property,
    required this.onInterested,
    required this.onShare,
    required this.onContactAgent,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => _showContextMenu(context),
      child: Dismissible(
        key: Key('property_${property["id"]}'),
        direction: DismissDirection.horizontal,
        onDismissed: (direction) {
          if (direction == DismissDirection.endToStart) {
            // Left swipe - dismiss
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Property dismissed'),
                backgroundColor: AppTheme.textSecondary,
              ),
            );
          } else if (direction == DismissDirection.startToEnd) {
            // Right swipe - add to interested
            onInterested();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Added to interested properties'),
                backgroundColor: AppTheme.successGreen,
              ),
            );
          }
        },
        background: Container(
          margin: EdgeInsets.only(right: 4.w),
          decoration: BoxDecoration(
            color: AppTheme.successGreen,
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 6.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'favorite',
                color: AppTheme.backgroundWhite,
                size: 24,
              ),
              SizedBox(height: 1.h),
              Text(
                'Interested',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.backgroundWhite,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        secondaryBackground: Container(
          margin: EdgeInsets.only(right: 4.w),
          decoration: BoxDecoration(
            color: AppTheme.textSecondary,
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 6.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'close',
                color: AppTheme.backgroundWhite,
                size: 24,
              ),
              SizedBox(height: 1.h),
              Text(
                'Dismiss',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.backgroundWhite,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        child: Container(
          width: 80.w,
          margin: EdgeInsets.only(right: 4.w),
          decoration: BoxDecoration(
            color: AppTheme.backgroundWhite,
            borderRadius: BorderRadius.circular(16),
            boxShadow: AppTheme.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPropertyImage(),
              _buildPropertyDetails(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPropertyImage() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          child: CustomImageWidget(
            imageUrl: property["imageUrl"] ?? '',
            width: double.infinity,
            height: 20.h,
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
                borderRadius: BorderRadius.circular(20),
              ),
              child: CustomIconWidget(
                iconName: property["isInterested"] == true
                    ? 'favorite'
                    : 'favorite_border',
                color: property["isInterested"] == true
                    ? AppTheme.primaryRed
                    : AppTheme.textSecondary,
                size: 20,
              ),
            ),
          ),
        ),
        Positioned(
          top: 2.w,
          left: 2.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
            decoration: BoxDecoration(
              color: AppTheme.primaryRed,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'star',
                  color: AppTheme.backgroundWhite,
                  size: 12,
                ),
                SizedBox(width: 1.w),
                Text(
                  property["rating"]?.toString() ?? '0.0',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.backgroundWhite,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPropertyDetails() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              property["title"] ?? '',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 1.h),
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'location_on',
                  color: AppTheme.textSecondary,
                  size: 16,
                ),
                SizedBox(width: 1.w),
                Expanded(
                  child: Text(
                    property["location"] ?? '',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Row(
              children: [
                _buildPropertyFeature(
                    'bed', property["bedrooms"]?.toString() ?? '0'),
                SizedBox(width: 4.w),
                _buildPropertyFeature(
                    'bathtub', property["bathrooms"]?.toString() ?? '0'),
                SizedBox(width: 4.w),
                _buildPropertyFeature('square_foot', property["area"] ?? ''),
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: property["price"] ?? '',
                            style: AppTheme.lightTheme.textTheme.titleLarge
                                ?.copyWith(
                              color: AppTheme.primaryRed,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(
                            text: property["period"] ?? '',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: onContactAgent,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryRed,
                    foregroundColor: AppTheme.backgroundWhite,
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Contact',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.backgroundWhite,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyFeature(String iconName, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: AppTheme.textSecondary,
          size: 14,
        ),
        SizedBox(width: 1.w),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.backgroundWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.borderSubtle,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: AppTheme.textSecondary,
                size: 24,
              ),
              title: Text(
                'Share Property',
                style: AppTheme.lightTheme.textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                onShare();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: property["isInterested"] == true
                    ? 'favorite'
                    : 'favorite_border',
                color: AppTheme.primaryRed,
                size: 24,
              ),
              title: Text(
                property["isInterested"] == true
                    ? 'Remove from Interested'
                    : 'Add to Interested',
                style: AppTheme.lightTheme.textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                onInterested();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'phone',
                color: AppTheme.successGreen,
                size: 24,
              ),
              title: Text(
                'Contact Agent',
                style: AppTheme.lightTheme.textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                onContactAgent();
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
