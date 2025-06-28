import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './settings_section_widget.dart';

class PrivacySectionWidget extends StatelessWidget {
  final VoidCallback onDataExport;
  final VoidCallback onAccountDeletion;

  const PrivacySectionWidget({
    super.key,
    required this.onDataExport,
    required this.onAccountDeletion,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsSectionWidget(
      title: 'Privacy & Data',
      children: [
        _buildActionTile(
          'Data Export',
          'Download a copy of your data',
          'download',
          onTap: onDataExport,
        ),
        _buildActionTile(
          'Privacy Policy',
          'Read our privacy policy',
          'privacy_tip',
          onTap: () => _showPrivacyPolicy(context),
        ),
        _buildActionTile(
          'Data Sharing',
          'Manage data sharing preferences',
          'share',
          onTap: () => _showDataSharingSettings(context),
        ),
        _buildActionTile(
          'Delete Account',
          'Permanently delete your account',
          'delete_forever',
          textColor: AppTheme.primaryRed,
          onTap: onAccountDeletion,
        ),
      ],
    );
  }

  Widget _buildActionTile(
    String title,
    String subtitle,
    String iconName, {
    Color? textColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: iconName,
        color: textColor ?? AppTheme.textSecondary,
        size: 24,
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
          color: textColor,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          color: AppTheme.textSecondary,
        ),
      ),
      trailing: CustomIconWidget(
        iconName: 'arrow_forward_ios',
        color: AppTheme.textSecondary,
        size: 16,
      ),
      onTap: onTap,
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: 80.h,
        decoration: BoxDecoration(
          color: AppTheme.backgroundWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            SizedBox(height: 2.h),
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.borderSubtle,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Privacy Policy',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: CustomIconWidget(
                      iconName: 'close',
                      color: AppTheme.textSecondary,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(4.w),
                child: Text(
                  '''
Our Privacy Policy outlines how we collect, use, and protect your personal information when you use our rental management platform.

Data Collection:
• Personal information (name, email, phone)
• Property information and preferences
• Usage data and analytics
• Location data (with permission)

Data Usage:
• To provide and improve our services
• To match tenants with suitable properties
• To facilitate communication between users
• To ensure platform security

Data Protection:
• We use industry-standard encryption
• Regular security audits and updates
• Limited access to authorized personnel only
• Compliance with data protection regulations

Your Rights:
• Access your personal data
• Request data correction or deletion
• Opt-out of marketing communications
• Data portability options

Contact us if you have any questions about our privacy practices.
                  ''',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    height: 1.6,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDataSharingSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          bool shareWithPartners = false;
          bool shareForAnalytics = true;
          bool shareForMarketing = false;

          return Container(
            decoration: BoxDecoration(
              color: AppTheme.backgroundWhite,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 2.h),
                Container(
                  width: 12.w,
                  height: 0.5.h,
                  decoration: BoxDecoration(
                    color: AppTheme.borderSubtle,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(height: 2.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Data Sharing Preferences',
                        style:
                            AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: CustomIconWidget(
                          iconName: 'close',
                          color: AppTheme.textSecondary,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 2.h),
                SwitchListTile(
                  title: Text('Share with Trusted Partners'),
                  subtitle: Text('Allow data sharing with verified partners'),
                  value: shareWithPartners,
                  onChanged: (value) =>
                      setState(() => shareWithPartners = value),
                ),
                SwitchListTile(
                  title: Text('Analytics Data'),
                  subtitle: Text('Help improve our services with usage data'),
                  value: shareForAnalytics,
                  onChanged: (value) =>
                      setState(() => shareForAnalytics = value),
                ),
                SwitchListTile(
                  title: Text('Marketing Communications'),
                  subtitle: Text('Receive personalized offers and updates'),
                  value: shareForMarketing,
                  onChanged: (value) =>
                      setState(() => shareForMarketing = value),
                ),
                SizedBox(height: 2.h),
                Padding(
                  padding: EdgeInsets.all(4.w),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text('Data sharing preferences updated')),
                        );
                      },
                      child: Text('Save Preferences'),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
