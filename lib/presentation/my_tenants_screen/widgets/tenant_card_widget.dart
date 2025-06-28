import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TenantCardWidget extends StatelessWidget {
  final Map<String, dynamic> tenant;
  final Function()? onTap;
  final Function()? onMessage;
  final Function()? onCall;
  final Function()? onViewLease;

  const TenantCardWidget({
    super.key,
    required this.tenant,
    this.onTap,
    this.onMessage,
    this.onCall,
    this.onViewLease,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: Key('tenant_${tenant['id']}'),
        secondaryBackground: _buildRightSwipeAction(),
        background: _buildLeftSwipeAction(),
        onDismissed: (direction) {
          if (direction == DismissDirection.endToStart) {
            onViewLease?.call();
          } else if (direction == DismissDirection.startToEnd) {
            onMessage?.call();
          }
        },
        child: GestureDetector(
            onTap: onTap,
            onLongPress: () => _showContextMenu(context),
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                    color: AppTheme.backgroundWhite,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: AppTheme.cardShadow,
                    border: Border.all(
                        color: AppTheme.borderSubtle.withValues(alpha: 0.5))),
                child: Row(children: [
                  CircleAvatar(
                      radius: 7.w,
                      backgroundColor: AppTheme.surfaceGray,
                      child: CustomImageWidget(
                          imageUrl: tenant['imageUrl'],
                          width: 14.w, 
                          height: 14.w, 
                          fit: BoxFit.cover)),
                  SizedBox(width: 4.w),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Row(children: [
                          Expanded(
                              child: Text(tenant['name'] ?? 'Tenant Name',
                                  style: AppTheme
                                      .lightTheme.textTheme.titleMedium
                                      ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: AppTheme.textPrimary))),
                          _buildStatusChip(tenant['leaseStatus'] ?? 'active'),
                        ]),
                        SizedBox(height: 1.h),
                        Row(children: [
                          CustomIconWidget(
                              iconName: 'location_on',
                              color: AppTheme.textSecondary,
                              size: 16),
                          SizedBox(width: 1.w),
                          Expanded(
                              child: Text(
                                  tenant['propertyAddress'] ??
                                      'Property Address',
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                          color: AppTheme.textSecondary))),
                        ]),
                        SizedBox(height: 1.h),
                        Row(children: [
                          CustomIconWidget(
                              iconName: 'payments',
                              color: AppTheme.primaryRed,
                              size: 16),
                          SizedBox(width: 1.w),
                          Text(tenant['rentAmount'] ?? '\$1,200/month',
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                      color: AppTheme.primaryRed,
                                      fontWeight: FontWeight.w600)),
                          Spacer(),
                          Text(
                              'Lease ends: ${tenant['leaseEndDate'] ?? 'Dec 2024'}',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(color: AppTheme.textSecondary)),
                        ]),
                      ])),
                ]))));
  }

  Widget _buildStatusChip(String status) {
    Color chipColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'active':
        chipColor = AppTheme.successGreen.withValues(alpha: 0.1);
        textColor = AppTheme.successGreen;
        break;
      case 'pending':
        chipColor = Colors.orange.withValues(alpha: 0.1);
        textColor = Colors.orange;
        break;
      case 'expired':
        chipColor = AppTheme.primaryRed.withValues(alpha: 0.1);
        textColor = AppTheme.primaryRed;
        break;
      default:
        chipColor = AppTheme.surfaceGray;
        textColor = AppTheme.textSecondary;
    }

    return Container(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
        decoration: BoxDecoration(
            color: chipColor, borderRadius: BorderRadius.circular(12)),
        child: Text(status.toUpperCase(),
            style: AppTheme.lightTheme.textTheme.labelSmall
                ?.copyWith(color: textColor, fontWeight: FontWeight.w600)));
  }

  Widget _buildLeftSwipeAction() {
    return Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 6.w),
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
            color: AppTheme.primaryRed,
            borderRadius: BorderRadius.circular(16)),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          CustomIconWidget(
              iconName: 'chat', color: AppTheme.backgroundWhite, size: 24),
          SizedBox(height: 0.5.h),
          Text('Message',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.backgroundWhite,
                  fontWeight: FontWeight.w500)),
        ]));
  }

  Widget _buildRightSwipeAction() {
    return Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 6.w),
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
            color: AppTheme.successGreen,
            borderRadius: BorderRadius.circular(16)),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          CustomIconWidget(
              iconName: 'description',
              color: AppTheme.backgroundWhite,
              size: 24),
          SizedBox(height: 0.5.h),
          Text('Lease',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.backgroundWhite,
                  fontWeight: FontWeight.w500)),
        ]));
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
                color: AppTheme.backgroundWhite,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
            child: SafeArea(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                  width: 12.w,
                  height: 0.5.h,
                  decoration: BoxDecoration(
                      color: AppTheme.borderSubtle,
                      borderRadius: BorderRadius.circular(10))),
              SizedBox(height: 3.h),
              Text(tenant['name'] ?? 'Tenant Actions',
                  style: AppTheme.lightTheme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.w600)),
              SizedBox(height: 3.h),
              _buildActionButton(
                  icon: 'chat',
                  label: 'Send Message',
                  onTap: () {
                    Navigator.pop(context);
                    onMessage?.call();
                  }),
              _buildActionButton(
                  icon: 'phone',
                  label: 'Call Tenant',
                  onTap: () {
                    Navigator.pop(context);
                    onCall?.call();
                  }),
              _buildActionButton(
                  icon: 'description',
                  label: 'View Lease Details',
                  onTap: () {
                    Navigator.pop(context);
                    onViewLease?.call();
                  }),
              SizedBox(height: 2.h),
              SizedBox(
                  width: double.infinity,
                  child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel'))),
            ]))));
  }

  Widget _buildActionButton({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 2.h),
        child: TextButton(
            onPressed: onTap,
            style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 4.w),
                backgroundColor: AppTheme.surfaceGray,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))),
            child: Row(children: [
              SizedBox(width: 4.w),
              CustomIconWidget(
                  iconName: icon, color: AppTheme.textPrimary, size: 24),
              SizedBox(width: 4.w),
              Text(label,
                  style: AppTheme.lightTheme.textTheme.bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w500)),
            ])));
  }
}