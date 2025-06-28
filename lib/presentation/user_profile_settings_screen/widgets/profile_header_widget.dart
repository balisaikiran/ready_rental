import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final Map<String, dynamic> userData;
  final VoidCallback onProfileImageTap;
  final VoidCallback onEditPressed;

  const ProfileHeaderWidget({
    super.key,
    required this.userData,
    required this.onProfileImageTap,
    required this.onEditPressed,
  });

  String _getRoleBadgeText(String role) {
    switch (role) {
      case 'tenant':
        return 'Tenant';
      case 'landlord':
        return 'Landlord';
      case 'agent':
        return 'Agent';
      default:
        return 'User';
    }
  }

  Color _getRoleBadgeColor(String role) {
    switch (role) {
      case 'tenant':
        return Colors.blue;
      case 'landlord':
        return AppTheme.primaryRed;
      case 'agent':
        return AppTheme.successGreen;
      default:
        return AppTheme.textSecondary;
    }
  }

  String _formatJoinDate(DateTime joinDate) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return 'Member since ${months[joinDate.month - 1]} ${joinDate.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(6.w),
        child: Column(
          children: [
            SizedBox(height: 2.h),

            // Profile image with edit overlay
            Stack(
              children: [
                GestureDetector(
                  onTap: onProfileImageTap,
                  child: Container(
                    width: 30.w,
                    height: 30.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.backgroundWhite,
                        width: 4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(26),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: userData['profileImage'] != null
                          ? CustomImageWidget(
                              imageUrl: userData['profileImage'],
                              width: 30.w,
                              height: 30.w,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              color: AppTheme.backgroundWhite,
                              child: CustomIconWidget(
                                iconName: 'person',
                                color: AppTheme.textSecondary,
                                size: 40,
                              ),
                            ),
                    ),
                  ),
                ),

                // Edit overlay
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: onProfileImageTap,
                    child: Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: BoxDecoration(
                        color: AppTheme.backgroundWhite,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppTheme.primaryRed,
                          width: 2,
                        ),
                      ),
                      child: CustomIconWidget(
                        iconName: 'edit',
                        color: AppTheme.primaryRed,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 3.h),

            // User name
            Text(
              userData['name'],
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                color: AppTheme.backgroundWhite,
                fontWeight: FontWeight.w700,
              ),
            ),

            SizedBox(height: 1.h),

            // Role badge
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: _getRoleBadgeColor(userData['role']),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _getRoleBadgeText(userData['role']),
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.backgroundWhite,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            SizedBox(height: 2.h),

            // Contact information
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'email',
                  color: AppTheme.backgroundWhite.withAlpha(204),
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Text(
                  userData['email'],
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.backgroundWhite.withAlpha(230),
                  ),
                ),
              ],
            ),

            SizedBox(height: 1.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'phone',
                  color: AppTheme.backgroundWhite.withAlpha(204),
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Text(
                  userData['phone'],
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.backgroundWhite.withAlpha(230),
                  ),
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Additional info based on role
            if (userData['role'] == 'landlord') ...[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppTheme.backgroundWhite.withAlpha(26),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'home',
                      color: AppTheme.backgroundWhite,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      '${userData['propertiesManaged'] ?? 0} Properties Managed',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.backgroundWhite,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2.h),
            ],

            // Join date
            Text(
              _formatJoinDate(userData['joinDate']),
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.backgroundWhite.withAlpha(204),
              ),
            ),

            SizedBox(height: 3.h),

            // Edit profile button
            OutlinedButton.icon(
              onPressed: onEditPressed,
              icon: CustomIconWidget(
                iconName: 'edit',
                color: AppTheme.backgroundWhite,
                size: 16,
              ),
              label: Text(
                'Edit Profile',
                style: TextStyle(
                  color: AppTheme.backgroundWhite,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppTheme.backgroundWhite, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
