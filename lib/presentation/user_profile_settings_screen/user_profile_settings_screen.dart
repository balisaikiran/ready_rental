import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/privacy_section_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/role_specific_section_widget.dart';
import './widgets/settings_section_widget.dart';
import './widgets/support_section_widget.dart';

class UserProfileSettingsScreen extends StatefulWidget {
  const UserProfileSettingsScreen({super.key});

  @override
  State<UserProfileSettingsScreen> createState() =>
      _UserProfileSettingsScreenState();
}

class _UserProfileSettingsScreenState extends State<UserProfileSettingsScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _hasUnsavedChanges = false;

  // User data - replace with actual user data
  final Map<String, dynamic> _userData = {
    'name': 'John Smith',
    'email': 'john.smith@email.com',
    'phone': '+1 (555) 123-4567',
    'role': 'landlord', // tenant, landlord, agent
    'profileImage':
        'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200',
    'joinDate': DateTime(2023, 1, 15),
    'propertiesManaged': 12,
    'notifications': {
      'push': true,
      'email': true,
      'sms': false,
      'marketing': false,
    },
    'twoFactorEnabled': false,
    'biometricEnabled': true,
    'darkMode': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundWhite,
        elevation: 0,
        title: Text(
          'Profile & Settings',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          if (_hasUnsavedChanges)
            TextButton(
              onPressed: _saveChanges,
              child: Text(
                'Save',
                style: TextStyle(
                  color: AppTheme.primaryRed,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            // Profile header
            ProfileHeaderWidget(
              userData: _userData,
              onProfileImageTap: _handleProfileImageUpdate,
              onEditPressed: _handleProfileEdit,
            ),

            SizedBox(height: 2.h),

            // Personal Information Section
            SettingsSectionWidget(
              title: 'Personal Information',
              children: [
                _buildEditableField(
                  'Full Name',
                  _userData['name'],
                  'person',
                  onChanged: (value) => _updateUserData('name', value),
                ),
                _buildEditableField(
                  'Email Address',
                  _userData['email'],
                  'email',
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) => _updateUserData('email', value),
                ),
                _buildEditableField(
                  'Phone Number',
                  _userData['phone'],
                  'phone',
                  keyboardType: TextInputType.phone,
                  onChanged: (value) => _updateUserData('phone', value),
                ),
              ],
            ),

            // Account Settings Section
            SettingsSectionWidget(
              title: 'Account Settings',
              children: [
                _buildActionTile(
                  'Change Password',
                  'Update your account password',
                  'lock',
                  onTap: _handlePasswordChange,
                ),
                _buildSwitchTile(
                  'Two-Factor Authentication',
                  'Add extra security to your account',
                  'security',
                  _userData['twoFactorEnabled'],
                  onChanged: (value) =>
                      _updateUserData('twoFactorEnabled', value),
                ),
                _buildSwitchTile(
                  'Biometric Authentication',
                  'Use fingerprint or face recognition',
                  'fingerprint',
                  _userData['biometricEnabled'],
                  onChanged: (value) =>
                      _updateUserData('biometricEnabled', value),
                ),
              ],
            ),

            // Notification Preferences Section
            SettingsSectionWidget(
              title: 'Notification Preferences',
              children: [
                _buildSwitchTile(
                  'Push Notifications',
                  'Receive notifications on this device',
                  'notifications',
                  _userData['notifications']['push'],
                  onChanged: (value) =>
                      _updateNotificationSetting('push', value),
                ),
                _buildSwitchTile(
                  'Email Notifications',
                  'Receive updates via email',
                  'email',
                  _userData['notifications']['email'],
                  onChanged: (value) =>
                      _updateNotificationSetting('email', value),
                ),
                _buildSwitchTile(
                  'SMS Notifications',
                  'Receive text message alerts',
                  'sms',
                  _userData['notifications']['sms'],
                  onChanged: (value) =>
                      _updateNotificationSetting('sms', value),
                ),
                _buildSwitchTile(
                  'Marketing Communications',
                  'Receive promotional content',
                  'campaign',
                  _userData['notifications']['marketing'],
                  onChanged: (value) =>
                      _updateNotificationSetting('marketing', value),
                ),
              ],
            ),

            // Role-specific sections
            RoleSpecificSectionWidget(
              userRole: _userData['role'],
              userData: _userData,
              onDataUpdate: _updateUserData,
            ),

            // Privacy Section
            PrivacySectionWidget(
              onDataExport: _handleDataExport,
              onAccountDeletion: _handleAccountDeletion,
            ),

            // App Preferences Section
            SettingsSectionWidget(
              title: 'App Preferences',
              children: [
                _buildSwitchTile(
                  'Dark Mode',
                  'Switch to dark theme',
                  'brightness_6',
                  _userData['darkMode'],
                  onChanged: (value) => _updateUserData('darkMode', value),
                ),
                _buildActionTile(
                  'Language',
                  'English (US)',
                  'language',
                  onTap: _handleLanguageSelection,
                ),
              ],
            ),

            // Support Section
            SupportSectionWidget(),

            // Logout Section
            SettingsSectionWidget(
              title: '',
              children: [
                _buildActionTile(
                  'Sign Out',
                  'Sign out of your account',
                  'logout',
                  textColor: AppTheme.primaryRed,
                  onTap: _handleLogout,
                ),
              ],
            ),

            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableField(
    String label,
    String value,
    String iconName, {
    TextInputType? keyboardType,
    required Function(String) onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: TextFormField(
        initialValue: value,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: CustomIconWidget(
            iconName: iconName,
            color: AppTheme.textSecondary,
            size: 20,
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    String iconName,
    bool value, {
    required Function(bool) onChanged,
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
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
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

  void _updateUserData(String key, dynamic value) {
    setState(() {
      _userData[key] = value;
      _hasUnsavedChanges = true;
    });
  }

  void _updateNotificationSetting(String key, bool value) {
    setState(() {
      _userData['notifications'][key] = value;
      _hasUnsavedChanges = true;
    });
  }

  void _handleProfileImageUpdate() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildImagePickerSheet(),
    );
  }

  Widget _buildImagePickerSheet() {
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
          SizedBox(height: 3.h),
          Text(
            'Update Profile Photo',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),
          ListTile(
            leading: CustomIconWidget(
                iconName: 'camera_alt',
                color: AppTheme.textSecondary,
                size: 24),
            title: Text('Take Photo'),
            onTap: () {
              Navigator.pop(context);
              // Implement camera capture
            },
          ),
          ListTile(
            leading: CustomIconWidget(
                iconName: 'photo_library',
                color: AppTheme.textSecondary,
                size: 24),
            title: Text('Choose from Gallery'),
            onTap: () {
              Navigator.pop(context);
              // Implement gallery selection
            },
          ),
          if (_userData['profileImage'] != null)
            ListTile(
              leading: CustomIconWidget(
                  iconName: 'delete', color: AppTheme.primaryRed, size: 24),
              title: Text('Remove Photo',
                  style: TextStyle(color: AppTheme.primaryRed)),
              onTap: () {
                Navigator.pop(context);
                _updateUserData('profileImage', null);
              },
            ),
          SizedBox(height: 3.h),
        ],
      ),
    );
  }

  void _handleProfileEdit() {
    // Navigate to detailed profile edit screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening profile editor')),
    );
  }

  void _handlePasswordChange() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Current Password'),
              obscureText: true,
            ),
            SizedBox(height: 2.h),
            TextField(
              decoration: InputDecoration(labelText: 'New Password'),
              obscureText: true,
            ),
            SizedBox(height: 2.h),
            TextField(
              decoration: InputDecoration(labelText: 'Confirm New Password'),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Password updated successfully')),
              );
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  void _handleLanguageSelection() {
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
              'Select Language',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            ListTile(
              title: Text('English (US)'),
              trailing: CustomIconWidget(
                  iconName: 'check', color: AppTheme.primaryRed, size: 20),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: Text('Spanish'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: Text('French'),
              onTap: () => Navigator.pop(context),
            ),
            SizedBox(height: 3.h),
          ],
        ),
      ),
    );
  }

  void _handleDataExport() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              'Data export initiated. You will receive an email with your data.')),
    );
  }

  void _handleAccountDeletion() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Account'),
        content: Text(
          'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently removed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement account deletion
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Account deletion request submitted'),
                  backgroundColor: AppTheme.primaryRed,
                ),
              );
            },
            child: Text('Delete', style: TextStyle(color: AppTheme.primaryRed)),
          ),
        ],
      ),
    );
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sign Out'),
        content: Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement logout logic
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.loginScreen,
                (route) => false,
              );
            },
            child:
                Text('Sign Out', style: TextStyle(color: AppTheme.primaryRed)),
          ),
        ],
      ),
    );
  }

  void _saveChanges() {
    setState(() {
      _hasUnsavedChanges = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Profile updated successfully'),
        backgroundColor: AppTheme.successGreen,
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
