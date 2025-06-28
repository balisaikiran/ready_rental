import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/quick_action_card_widget.dart';
import './widgets/recent_search_card_widget.dart';
import './widgets/recommended_property_card_widget.dart';

class TenantDashboard extends StatefulWidget {
  const TenantDashboard({super.key});

  @override
  State<TenantDashboard> createState() => _TenantDashboardState();
}

class _TenantDashboardState extends State<TenantDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final ScrollController _scrollController = ScrollController();

  // Mock data for recent searches
  final List<Map<String, dynamic>> recentSearches = [
    {
      "id": 1,
      "location": "Downtown",
      "type": "Apartment",
      "priceRange": "\$1200-\$1800",
      "searchDate": "2 days ago",
      "icon": "location_on"
    },
    {
      "id": 2,
      "location": "Midtown",
      "type": "Studio",
      "priceRange": "\$800-\$1200",
      "searchDate": "1 week ago",
      "icon": "apartment"
    },
    {
      "id": 3,
      "location": "Uptown",
      "type": "2 Bedroom",
      "priceRange": "\$1500-\$2200",
      "searchDate": "2 weeks ago",
      "icon": "home"
    },
  ];

  // Mock data for recommended properties
  final List<Map<String, dynamic>> recommendedProperties = [
    {
      "id": 1,
      "title": "Modern Downtown Apartment",
      "location": "Downtown District",
      "price": "\$1,450",
      "period": "/month",
      "bedrooms": 2,
      "bathrooms": 2,
      "area": "850 sq ft",
      "imageUrl":
          "https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "rating": 4.8,
      "isInterested": false,
      "agentName": "Sarah Johnson",
      "agentPhone": "+1 (555) 123-4567"
    },
    {
      "id": 2,
      "title": "Cozy Studio Loft",
      "location": "Arts Quarter",
      "price": "\$950",
      "period": "/month",
      "bedrooms": 1,
      "bathrooms": 1,
      "area": "520 sq ft",
      "imageUrl":
          "https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "rating": 4.6,
      "isInterested": false,
      "agentName": "Mike Chen",
      "agentPhone": "+1 (555) 987-6543"
    },
    {
      "id": 3,
      "title": "Luxury Penthouse Suite",
      "location": "Skyline Heights",
      "price": "\$2,800",
      "period": "/month",
      "bedrooms": 3,
      "bathrooms": 3,
      "area": "1200 sq ft",
      "imageUrl":
          "https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "rating": 4.9,
      "isInterested": true,
      "agentName": "Emma Rodriguez",
      "agentPhone": "+1 (555) 456-7890"
    },
  ];

  // Mock data for quick actions
  final List<Map<String, dynamic>> quickActions = [
    {
      "id": 1,
      "title": "My Applications",
      "subtitle": "3 pending",
      "icon": "description",
      "color": AppTheme.primaryRed,
      "route": "/my-applications"
    },
    {
      "id": 2,
      "title": "Interested Properties",
      "subtitle": "5 saved",
      "icon": "favorite",
      "color": AppTheme.successGreen,
      "route": "/interested-properties"
    },
    {
      "id": 3,
      "title": "Ready! Perks",
      "subtitle": "250 points",
      "icon": "card_giftcard",
      "color": AppTheme.primaryRedLight,
      "route": "/ready-perks"
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await Future.delayed(Duration(seconds: 2));
    if (mounted) {
      setState(() {
        // Refresh data here
      });
    }
  }

  void _onPropertyInterested(int propertyId) {
    setState(() {
      final propertyIndex = recommendedProperties
          .indexWhere((property) => property["id"] == propertyId);
      if (propertyIndex != -1) {
        recommendedProperties[propertyIndex]["isInterested"] =
            !recommendedProperties[propertyIndex]["isInterested"];
      }
    });
  }

  void _onQuickActionTap(String route) {
    // Navigate to respective screen
    Navigator.pushNamed(context, route);
  }

  void _onSearchTap() {
    Navigator.pushNamed(context, '/property-search');
  }

  void _onNotificationTap() {
    // Handle notification tap
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildSearchTab(),
                  _buildPropertiesTab(),
                  _buildDocumentsTab(),
                  _buildChatTab(),
                  _buildProfileTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton.extended(
              onPressed: _onSearchTap,
              backgroundColor: AppTheme.primaryRed,
              foregroundColor: AppTheme.backgroundWhite,
              icon: CustomIconWidget(
                iconName: 'search',
                color: AppTheme.backgroundWhite,
                size: 20,
              ),
              label: Text(
                'Search',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.backgroundWhite,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        boxShadow: AppTheme.cardShadow,
      ),
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good Morning!',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.backgroundWhite.withValues(alpha: 0.8),
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'Alex Johnson',
                  style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                    color: AppTheme.backgroundWhite,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: _onNotificationTap,
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.backgroundWhite.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: CustomIconWidget(
                iconName: 'notifications',
                color: AppTheme.backgroundWhite,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: AppTheme.backgroundWhite,
      child: TabBar(
        controller: _tabController,
        isScrollable: false,
        labelColor: AppTheme.primaryRed,
        unselectedLabelColor: AppTheme.textSecondary,
        indicatorColor: AppTheme.primaryRed,
        indicatorWeight: 3,
        labelStyle: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTheme.lightTheme.textTheme.labelMedium,
        tabs: [
          Tab(
            icon: CustomIconWidget(
              iconName: 'search',
              color: _tabController.index == 0
                  ? AppTheme.primaryRed
                  : AppTheme.textSecondary,
              size: 20,
            ),
            text: 'Search',
          ),
          Tab(
            icon: CustomIconWidget(
              iconName: 'home',
              color: _tabController.index == 1
                  ? AppTheme.primaryRed
                  : AppTheme.textSecondary,
              size: 20,
            ),
            text: 'Properties',
          ),
          Tab(
            icon: CustomIconWidget(
              iconName: 'folder',
              color: _tabController.index == 2
                  ? AppTheme.primaryRed
                  : AppTheme.textSecondary,
              size: 20,
            ),
            text: 'Documents',
          ),
          Tab(
            icon: CustomIconWidget(
              iconName: 'chat',
              color: _tabController.index == 3
                  ? AppTheme.primaryRed
                  : AppTheme.textSecondary,
              size: 20,
            ),
            text: 'Chat',
          ),
          Tab(
            icon: CustomIconWidget(
              iconName: 'person',
              color: _tabController.index == 4
                  ? AppTheme.primaryRed
                  : AppTheme.textSecondary,
              size: 20,
            ),
            text: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildSearchTab() {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _onRefresh,
      color: AppTheme.primaryRed,
      child: SingleChildScrollView(
        controller: _scrollController,
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFeaturedSearchBar(),
            SizedBox(height: 3.h),
            _buildRecentSearches(),
            SizedBox(height: 3.h),
            _buildQuickActions(),
            SizedBox(height: 3.h),
            _buildRecommendedProperties(),
            SizedBox(height: 10.h), // Extra space for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedSearchBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
        border: Border.all(color: AppTheme.borderSubtle),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'location_on',
            color: AppTheme.primaryRed,
            size: 24,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              'Search for properties...',
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          CustomIconWidget(
            iconName: 'mic',
            color: AppTheme.textSecondary,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSearches() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Searches',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'View All',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.primaryRed,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 1.h),
        SizedBox(
          height: 12.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            itemCount: recentSearches.length,
            itemBuilder: (context, index) {
              final search = recentSearches[index];
              return RecentSearchCardWidget(
                search: search,
                onTap: () => _onSearchTap(),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Text(
            'Quick Actions',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: 1.h),
        SizedBox(
          height: 12.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            itemCount: quickActions.length,
            itemBuilder: (context, index) {
              final action = quickActions[index];
              return QuickActionCardWidget(
                action: action,
                onTap: () => _onQuickActionTap(action["route"]),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendedProperties() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recommended Properties',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.pushNamed(context, '/property-search'),
                child: Text(
                  'View All',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.primaryRed,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 1.h),
        SizedBox(
          height: 35.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            itemCount: recommendedProperties.length,
            itemBuilder: (context, index) {
              final property = recommendedProperties[index];
              return RecommendedPropertyCardWidget(
                property: property,
                onInterested: () => _onPropertyInterested(property["id"]),
                onShare: () {
                  // Handle share
                },
                onContactAgent: () {
                  // Handle contact agent
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPropertiesTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'home',
            color: AppTheme.textSecondary,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'Properties',
            style: AppTheme.lightTheme.textTheme.headlineSmall,
          ),
          SizedBox(height: 1.h),
          Text(
            'View your saved and interested properties',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'folder',
            color: AppTheme.textSecondary,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'My Documents',
            style: AppTheme.lightTheme.textTheme.headlineSmall,
          ),
          SizedBox(height: 1.h),
          Text(
            'Access your rental documents and applications',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildChatTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'chat',
            color: AppTheme.textSecondary,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'Chat with Agents',
            style: AppTheme.lightTheme.textTheme.headlineSmall,
          ),
          SizedBox(height: 1.h),
          Text(
            'Connect with real estate agents and landlords',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'person',
            color: AppTheme.textSecondary,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'Profile',
            style: AppTheme.lightTheme.textTheme.headlineSmall,
          ),
          SizedBox(height: 1.h),
          Text(
            'Manage your account and preferences',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
