import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './settings_section_widget.dart';

class SupportSectionWidget extends StatelessWidget {
  const SupportSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsSectionWidget(
      title: 'Support & Information',
      children: [
        _buildActionTile(
          'Help Center',
          'Find answers to common questions',
          'help',
          onTap: () => _showHelpCenter(context),
        ),
        _buildActionTile(
          'Contact Support',
          'Get help from our support team',
          'support_agent',
          onTap: () => _showContactOptions(context),
        ),
        _buildActionTile(
          'Terms of Service',
          'Read our terms and conditions',
          'description',
          onTap: () => _showTermsOfService(context),
        ),
        _buildActionTile(
          'App Version',
          'v1.2.3 (Build 123)',
          'info',
          onTap: () => _showAppInfo(context),
        ),
      ],
    );
  }

  Widget _buildActionTile(
    String title,
    String subtitle,
    String iconName, {
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: iconName,
        color: AppTheme.textSecondary,
        size: 24,
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyLarge,
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

  void _showHelpCenter(BuildContext context) {
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
                    'Help Center',
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
              child: ListView(
                padding: EdgeInsets.all(4.w),
                children: [
                  _buildHelpCategory(
                    'Getting Started',
                    [
                      'How to create an account',
                      'Setting up your profile',
                      'Understanding user roles',
                    ],
                  ),
                  SizedBox(height: 2.h),
                  _buildHelpCategory(
                    'For Tenants',
                    [
                      'How to search for properties',
                      'Applying for rentals',
                      'Managing your applications',
                    ],
                  ),
                  SizedBox(height: 2.h),
                  _buildHelpCategory(
                    'For Landlords',
                    [
                      'Adding property listings',
                      'Managing tenant applications',
                      'Rent collection setup',
                    ],
                  ),
                  SizedBox(height: 2.h),
                  _buildHelpCategory(
                    'For Agents',
                    [
                      'Managing client relationships',
                      'Commission tracking',
                      'Listing management',
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpCategory(String title, List<String> items) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceGray,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderSubtle),
      ),
      child: ExpansionTile(
        title: Text(
          title,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        children: items
            .map((item) => ListTile(
                  title: Text(item),
                  onTap: () {
                    // Navigate to specific help article
                  },
                ))
            .toList(),
      ),
    );
  }

  void _showContactOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
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
            SizedBox(height: 3.h),
            Text(
              'Contact Support',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'email',
                color: AppTheme.primaryRed,
                size: 24,
              ),
              title: Text('Email Support'),
              subtitle: Text('support@rentalapp.com'),
              onTap: () {
                Navigator.pop(context);
                // Launch email client
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'phone',
                color: AppTheme.successGreen,
                size: 24,
              ),
              title: Text('Phone Support'),
              subtitle: Text('+1 (800) 123-4567'),
              onTap: () {
                Navigator.pop(context);
                // Launch phone dialer
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'chat',
                color: Colors.blue,
                size: 24,
              ),
              title: Text('Live Chat'),
              subtitle: Text('Available 9 AM - 6 PM EST'),
              onTap: () {
                Navigator.pop(context);
                // Open live chat
              },
            ),
            SizedBox(height: 3.h),
          ],
        ),
      ),
    );
  }

  void _showTermsOfService(BuildContext context) {
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
                    'Terms of Service',
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
Terms of Service

Last updated: [Date]

1. Acceptance of Terms
By accessing and using this rental management platform, you accept and agree to be bound by the terms and provision of this agreement.

2. Use License
Permission is granted to temporarily use this platform for personal, non-commercial transitory viewing only.

3. User Accounts
- You must provide accurate information when creating an account
- You are responsible for maintaining the confidentiality of your account
- You agree to accept responsibility for all activities under your account

4. Property Listings
- Landlords and agents must provide accurate property information
- All listings must comply with fair housing laws
- Misleading or fraudulent listings are prohibited

5. Tenant Applications
- Tenants must provide truthful information in applications
- Application fees are non-refundable unless otherwise stated
- Background checks may be conducted as part of the screening process

6. Payments and Fees
- Service fees are clearly disclosed before transactions
- Payment processing is handled by secure third-party providers
- Refund policies vary by transaction type

7. Privacy and Data Protection
- Your privacy is important to us
- We collect and use information as described in our Privacy Policy
- You consent to data processing necessary for service provision

8. Prohibited Uses
- Illegal activities or content
- Harassment or discrimination
- Spam or unauthorized marketing
- Attempts to breach security

9. Limitation of Liability
The platform and its operators shall not be liable for any damages arising from use of the service.

10. Changes to Terms
We reserve the right to modify these terms at any time. Continued use constitutes acceptance of changes.

Contact us with any questions about these terms.
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

  void _showAppInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('App Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Version: 1.2.3'),
            Text('Build: 123'),
            Text('Release Date: March 2024'),
            SizedBox(height: 2.h),
            Text('Features in this version:'),
            Text('• Enhanced search functionality'),
            Text('• Improved document management'),
            Text('• Better notification system'),
            Text('• Performance optimizations'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
