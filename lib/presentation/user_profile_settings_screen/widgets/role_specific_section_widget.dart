import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import './settings_section_widget.dart';

class RoleSpecificSectionWidget extends StatelessWidget {
  final String userRole;
  final Map<String, dynamic> userData;
  final Function(String, dynamic) onDataUpdate;

  const RoleSpecificSectionWidget({
    super.key,
    required this.userRole,
    required this.userData,
    required this.onDataUpdate,
  });

  @override
  Widget build(BuildContext context) {
    switch (userRole) {
      case 'tenant':
        return _buildTenantSettings();
      case 'landlord':
        return _buildLandlordSettings();
      case 'agent':
        return _buildAgentSettings();
      default:
        return SizedBox.shrink();
    }
  }

  Widget _buildTenantSettings() {
    return Column(
      children: [
        SettingsSectionWidget(
          title: 'Search Preferences',
          children: [
            _buildActionTile(
              'Saved Searches',
              'Manage your property search criteria',
              'search',
              onTap: () {},
            ),
            _buildActionTile(
              'Property Alerts',
              'Get notified about new matches',
              'notifications_active',
              onTap: () {},
            ),
            _buildActionTile(
              'Viewing History',
              'See properties you\'ve viewed',
              'history',
              onTap: () {},
            ),
          ],
        ),
        SettingsSectionWidget(
          title: 'Application Management',
          children: [
            _buildActionTile(
              'Application History',
              'Track your rental applications',
              'assignment',
              onTap: () {},
            ),
            _buildActionTile(
              'Required Documents',
              'Manage your application documents',
              'folder',
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLandlordSettings() {
    return Column(
      children: [
        SettingsSectionWidget(
          title: 'Property Management',
          children: [
            _buildActionTile(
              'Property Portfolio',
              'Manage your rental properties',
              'home',
              onTap: () {},
            ),
            _buildActionTile(
              'Tenant Screening',
              'Set screening criteria preferences',
              'people',
              onTap: () {},
            ),
            _buildActionTile(
              'Rent Collection',
              'Configure payment methods',
              'payments',
              onTap: () {},
            ),
            _buildActionTile(
              'Maintenance Requests',
              'Manage service request settings',
              'build',
              onTap: () {},
            ),
          ],
        ),
        SettingsSectionWidget(
          title: 'Financial Settings',
          children: [
            _buildActionTile(
              'Tax Information',
              'Manage tax-related documents',
              'receipt',
              onTap: () {},
            ),
            _buildActionTile(
              'Expense Tracking',
              'Set up expense categories',
              'trending_up',
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAgentSettings() {
    return Column(
      children: [
        SettingsSectionWidget(
          title: 'Brokerage Information',
          children: [
            _buildActionTile(
              'License Details',
              'Update your real estate license',
              'card_membership',
              onTap: () {},
            ),
            _buildActionTile(
              'Brokerage Affiliation',
              'Manage brokerage information',
              'business',
              onTap: () {},
            ),
            _buildActionTile(
              'Service Areas',
              'Update areas you serve',
              'location_city',
              onTap: () {},
            ),
          ],
        ),
        SettingsSectionWidget(
          title: 'Commission & Tracking',
          children: [
            _buildActionTile(
              'Commission Structure',
              'Set up commission rates',
              'percent',
              onTap: () {},
            ),
            _buildActionTile(
              'Deal Pipeline',
              'Manage your active deals',
              'timeline',
              onTap: () {},
            ),
            _buildActionTile(
              'Client Management',
              'Organize your client database',
              'group',
              onTap: () {},
            ),
          ],
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
}
