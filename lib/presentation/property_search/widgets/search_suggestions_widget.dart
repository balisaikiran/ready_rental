import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SearchSuggestionsWidget extends StatelessWidget {
  final List<String> suggestions;
  final Function(String) onSuggestionTap;

  const SearchSuggestionsWidget({
    super.key,
    required this.suggestions,
    required this.onSuggestionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        decoration: BoxDecoration(
          color: AppTheme.backgroundWhite,
          borderRadius: BorderRadius.circular(12),
          boxShadow: AppTheme.elevatedShadow,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppTheme.borderSubtle),
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'history',
                    color: AppTheme.textSecondary,
                    size: 20,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'Recent Searches',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: suggestions.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: AppTheme.borderSubtle,
              ),
              itemBuilder: (context, index) {
                final suggestion = suggestions[index];
                return ListTile(
                  leading: CustomIconWidget(
                    iconName: 'search',
                    color: AppTheme.textSecondary,
                    size: 18,
                  ),
                  title: Text(
                    suggestion,
                    style: AppTheme.lightTheme.textTheme.bodyLarge,
                  ),
                  trailing: CustomIconWidget(
                    iconName: 'north_west',
                    color: AppTheme.textSecondary,
                    size: 16,
                  ),
                  onTap: () => onSuggestionTap(suggestion),
                  contentPadding: EdgeInsets.symmetric(horizontal: 4.w),
                );
              },
            ),
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: AppTheme.borderSubtle),
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'trending_up',
                    color: AppTheme.primaryRed,
                    size: 20,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'Popular Areas',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryRed,
                    ),
                  ),
                ],
              ),
            ),
            _buildPopularArea('Downtown District', '120+ properties'),
            _buildPopularArea('University Area', '85+ properties'),
            _buildPopularArea('Waterfront', '45+ properties'),
            SizedBox(height: 2.w),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularArea(String area, String count) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: AppTheme.primaryRed.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: CustomIconWidget(
          iconName: 'location_on',
          color: AppTheme.primaryRed,
          size: 16,
        ),
      ),
      title: Text(
        area,
        style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        count,
        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          color: AppTheme.textSecondary,
        ),
      ),
      trailing: CustomIconWidget(
        iconName: 'arrow_forward_ios',
        color: AppTheme.textSecondary,
        size: 14,
      ),
      onTap: () => onSuggestionTap(area),
      contentPadding: EdgeInsets.symmetric(horizontal: 4.w),
    );
  }
}
