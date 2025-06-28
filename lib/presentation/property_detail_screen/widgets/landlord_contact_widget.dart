import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LandlordContactWidget extends StatelessWidget {
  final Map<String, dynamic> landlordInfo;
  final Function()? onMessageTap;
  final Function()? onCallTap;

  const LandlordContactWidget({
    super.key,
    required this.landlordInfo,
    this.onMessageTap,
    this.onCallTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
            color: AppTheme.backgroundWhite,
            borderRadius: BorderRadius.circular(16),
            boxShadow: AppTheme.cardShadow),
        child: Row(children: [
          CircleAvatar(
              radius: 6.w,
              backgroundColor: AppTheme.surfaceGray,
              child: CustomImageWidget(
                  imageUrl: landlordInfo['image'] ?? '',
                  width: 12.w, height: 12.w, fit: BoxFit.cover)),
          SizedBox(width: 3.w),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(landlordInfo['name'] ?? 'Agent Name',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary)),
                SizedBox(height: 0.5.h),
                Row(children: [
                  ...List.generate(5, (index) {
                    return CustomIconWidget(
                        iconName: 'star',
                        color: index < (landlordInfo['rating'] ?? 4)
                            ? AppTheme.primaryRed
                            : AppTheme.borderSubtle,
                        size: 14);
                  }),
                  SizedBox(width: 2.w),
                  Text(
                      '${landlordInfo['rating'] ?? 4.8} (${landlordInfo['reviewCount'] ?? 25} reviews)',
                      style: AppTheme.lightTheme.textTheme.bodySmall
                          ?.copyWith(color: AppTheme.textSecondary)),
                ]),
                SizedBox(height: 0.5.h),
                Text(landlordInfo['title'] ?? 'Licensed Agent',
                    style: AppTheme.lightTheme.textTheme.bodySmall
                        ?.copyWith(color: AppTheme.textSecondary)),
              ])),
          SizedBox(width: 3.w),
          Row(children: [
            GestureDetector(
                onTap: onCallTap,
                child: Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                        color: AppTheme.successGreen.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12)),
                    child: CustomIconWidget(
                        iconName: 'phone',
                        color: AppTheme.successGreen,
                        size: 20))),
            SizedBox(width: 2.w),
            GestureDetector(
                onTap: onMessageTap,
                child: Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(12)),
                    child: CustomIconWidget(
                        iconName: 'chat',
                        color: AppTheme.backgroundWhite,
                        size: 20))),
          ]),
        ]));
  }
}