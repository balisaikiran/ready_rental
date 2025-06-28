import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/join_brokerage_card_widget.dart';
import './widgets/portfolio_summary_card_widget.dart';
import './widgets/property_performance_widget.dart';
import './widgets/quick_action_card_widget.dart';
import './widgets/recent_activity_item_widget.dart';

class LandlordDashboard extends StatefulWidget {
  const LandlordDashboard({super.key});

  @override
  State<LandlordDashboard> createState() => _LandlordDashboardState();
}

class _LandlordDashboardState extends State<LandlordDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isRefreshing = false;

  // Mock data for landlord dashboard
  final Map<String, dynamic> landlordData = {
    "name": "Sarah Johnson",
    "totalProperties": 12,
    "occupiedUnits": 10,
    "monthlyRevenue": 24500.0,
    "pendingMaintenance": 3,
    "occupancyRate": 83.3,
    "rentCollectionRate": 95.2,
    "maintenanceCosts": 2800.0,
    "hasNotifications": true,
    "hasBrokerageInvitation": true,
    "brokerageInvitation": {
      "agentName": "Michael Rodriguez",
      "brokerageName": "Prime Properties Group",
      "invitationDate": "2024-01-15"
    }
  };

  final List<Map<String, dynamic>> portfolioSummary = [
    {
      "title": "Total Properties",
      "value": "12",
      "trend": "+2",
      "trendPositive": true,
      "icon": "home",
      "color": 0xFF4299E1
    },
    {
      "title": "Occupied Units",
      "value": "10/12",
      "trend": "+1",
      "trendPositive": true,
      "icon": "people",
      "color": 0xFF48BB78
    },
    {
      "title": "Monthly Revenue",
      "value": "\$24.5K",
      "trend": "+8.2%",
      "trendPositive": true,
      "icon": "attach_money",
      "color": 0xFF38A169
    },
    {
      "title": "Pending Maintenance",
      "value": "3",
      "trend": "-2",
      "trendPositive": true,
      "icon": "build",
      "color": 0xFFED8936
    }
  ];

  final List<Map<String, dynamic>> quickActions = [
    {
      "title": "View All Properties",
      "icon": "home_work",
      "route": "/property-search",
      "color": 0xFF4299E1
    },
    {
      "title": "Tenant Communications",
      "icon": "chat",
      "route": "/tenant-dashboard",
      "color": 0xFF48BB78
    },
    {
      "title": "Service Requests",
      "icon": "build_circle",
      "route": "/agent-dashboard",
      "color": 0xFFED8936
    },
    {
      "title": "Financial Reports",
      "icon": "assessment",
      "route": "/landlord-dashboard",
      "color": 0xFF9F7AEA
    }
  ];

  final List<Map<String, dynamic>> recentActivities = [
    {
      "id": 1,
      "type": "rent_payment",
      "title": "Rent Payment Received",
      "description": "Unit 4B - \$1,850 from Jennifer Chen",
      "timestamp": "2 hours ago",
      "priority": "normal",
      "icon": "payment",
      "color": 0xFF48BB78,
      "actionable": false
    },
    {
      "id": 2,
      "type": "maintenance_request",
      "title": "Maintenance Request",
      "description": "Unit 2A - Leaking faucet in kitchen",
      "timestamp": "4 hours ago",
      "priority": "high",
      "icon": "plumbing",
      "color": 0xFFED8936,
      "actionable": true
    },
    {
      "id": 3,
      "type": "lease_renewal",
      "title": "Lease Renewal Due",
      "description": "Unit 1C - David Martinez (expires in 30 days)",
      "timestamp": "1 day ago",
      "priority": "medium",
      "icon": "description",
      "color": 0xFF4299E1,
      "actionable": true
    },
    {
      "id": 4,
      "type": "tenant_communication",
      "title": "Tenant Message",
      "description": "Unit 3B - Question about parking policy",
      "timestamp": "2 days ago",
      "priority": "low",
      "icon": "message",
      "color": 0xFF9F7AEA,
      "actionable": true
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });
  }

  void _handleNotificationTap() {
    // Handle notification bell tap
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: Text('Notifications'),
                content:
                    Text('You have 3 new service requests and 2 rent alerts.'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Close')),
                ]));
  }

  void _handleTabChange(int index) {
    switch (index) {
      case 1:
        Navigator.pushNamed(context, '/property-search');
        break;
      case 2:
        Navigator.pushNamed(context, '/tenant-dashboard');
        break;
      case 3:
        Navigator.pushNamed(context, '/agent-dashboard');
        break;
      case 4:
        Navigator.pushNamed(context, '/login-screen');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        body: SafeArea(
            child: Column(children: [
          _buildHeader(),
          Expanded(
              child: TabBarView(controller: _tabController, children: [
            _buildOverviewTab(),
            Container(), // Properties tab placeholder
            Container(), // Tenants tab placeholder
            Container(), // Reports tab placeholder
            Container(), // Profile tab placeholder
          ])),
        ])),
        bottomNavigationBar: _buildBottomTabBar());
  }

  Widget _buildHeader() {
    return Container(
        decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient, boxShadow: AppTheme.cardShadow),
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Row(children: [
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text('Welcome back,',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color:
                            AppTheme.backgroundWhite.withValues(alpha: 0.8))),
                SizedBox(height: 0.5.h),
                Text(landlordData["name"] as String,
                    style: AppTheme.lightTheme.textTheme.headlineSmall
                        ?.copyWith(
                            color: AppTheme.backgroundWhite,
                            fontWeight: FontWeight.w600)),
              ])),
          GestureDetector(
              onTap: _handleNotificationTap,
              child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                      color: AppTheme.backgroundWhite.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12)),
                  child: Stack(children: [
                    CustomIconWidget(
                        iconName: 'notifications',
                        color: AppTheme.backgroundWhite,
                        size: 24),
                    if (landlordData["hasNotifications"] == true)
                      Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                  color: AppTheme.backgroundWhite,
                                  shape: BoxShape.circle))),
                  ]))),
        ]));
  }

  Widget _buildBottomTabBar() {
    return Container(
        decoration: BoxDecoration(color: AppTheme.backgroundWhite, boxShadow: [
          BoxShadow(
              color: AppTheme.shadowLight,
              blurRadius: 8,
              offset: Offset(0, -2)),
        ]),
        child: TabBar(
            controller: _tabController,
            onTap: (index) {
              if (index != 0) {
                _handleTabChange(index);
              }
            },
            indicatorColor: AppTheme.primaryRed,
            labelColor: AppTheme.primaryRed,
            unselectedLabelColor: AppTheme.textSecondary,
            labelStyle: AppTheme.lightTheme.textTheme.labelSmall,
            unselectedLabelStyle: AppTheme.lightTheme.textTheme.labelSmall,
            tabs: [
              Tab(
                  icon: CustomIconWidget(
                      iconName: 'dashboard',
                      color: AppTheme.primaryRed,
                      size: 20),
                  text: 'Overview'),
              Tab(
                  icon: CustomIconWidget(
                      iconName: 'home_work',
                      color: AppTheme.textSecondary,
                      size: 20),
                  text: 'Properties'),
              Tab(
                  icon: CustomIconWidget(
                      iconName: 'people',
                      color: AppTheme.textSecondary,
                      size: 20),
                  text: 'Tenants'),
              Tab(
                  icon: CustomIconWidget(
                      iconName: 'assessment',
                      color: AppTheme.textSecondary,
                      size: 20),
                  text: 'Reports'),
              Tab(
                  icon: CustomIconWidget(
                      iconName: 'person',
                      color: AppTheme.textSecondary,
                      size: 20),
                  text: 'Profile'),
            ]));
  }

  Widget _buildOverviewTab() {
    return RefreshIndicator(
        onRefresh: _handleRefresh,
        color: AppTheme.primaryRed,
        child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(4.w),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _buildPortfolioSummary(),
              SizedBox(height: 3.h),
              _buildQuickActions(),
              SizedBox(height: 3.h),
              if (landlordData["hasBrokerageInvitation"] == true) ...[
                JoinBrokerageCardWidget(
                    invitationData: landlordData["brokerageInvitation"]
                        as Map<String, dynamic>,
                    onAccept: () => _handleBrokerageInvitation(true),
                    onDecline: () => _handleBrokerageInvitation(false)),
                SizedBox(height: 3.h),
              ],
              _buildPropertyPerformance(),
              SizedBox(height: 3.h),
              _buildRecentActivity(),
              SizedBox(height: 2.h),
            ])));
  }

  Widget _buildPortfolioSummary() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Portfolio Summary',
          style: AppTheme.lightTheme.textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.w600)),
      SizedBox(height: 2.h),
      GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 3.w,
              mainAxisSpacing: 2.h,
              childAspectRatio: 1.2),
          itemCount: portfolioSummary.length,
          itemBuilder: (context, index) {
            return PortfolioSummaryCardWidget(
                data: portfolioSummary[index],
                onTap: () => _handlePortfolioCardTap(index));
          }),
    ]);
  }

  Widget _buildQuickActions() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Quick Actions',
          style: AppTheme.lightTheme.textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.w600)),
      SizedBox(height: 2.h),
      GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 3.w,
              mainAxisSpacing: 2.h,
              childAspectRatio: 1.5),
          itemCount: quickActions.length,
          itemBuilder: (context, index) {
            return QuickActionCardWidget(
                data: quickActions[index],
                onTap: () => _handleQuickActionTap(
                    quickActions[index]["route"] as String));
          }),
    ]);
  }

  Widget _buildPropertyPerformance() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Property Performance',
          style: AppTheme.lightTheme.textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.w600)),
      SizedBox(height: 2.h),
      PropertyPerformanceWidget(
          occupancyRate: landlordData["occupancyRate"] as double,
          rentCollectionRate: landlordData["rentCollectionRate"] as double,
          maintenanceCosts: landlordData["maintenanceCosts"] as double),
    ]);
  }

  Widget _buildRecentActivity() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('Recent Activity',
            style: AppTheme.lightTheme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.w600)),
        TextButton(
            onPressed: () => Navigator.pushNamed(context, '/agent-dashboard'),
            child: Text('View All')),
      ]),
      SizedBox(height: 1.h),
      recentActivities.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: recentActivities.length,
              separatorBuilder: (context, index) => SizedBox(height: 1.h),
              itemBuilder: (context, index) {
                return RecentActivityItemWidget(
                    data: recentActivities[index],
                    onTap: () => _handleActivityTap(recentActivities[index]),
                    onSwipeRight: recentActivities[index]["actionable"] == true
                        ? () => _handleActivityApproval(recentActivities[index])
                        : null,
                    onSwipeLeft: recentActivities[index]["actionable"] == true
                        ? () => _handleActivityReview(recentActivities[index])
                        : null,
                    onLongPress: recentActivities[index]["actionable"] == true
                        ? () =>
                            _showActivityContextMenu(recentActivities[index])
                        : null);
              }),
    ]);
  }

  Widget _buildEmptyState() {
    return Container(
        padding: EdgeInsets.all(6.w),
        decoration: BoxDecoration(
            color: AppTheme.surfaceGray,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.borderSubtle)),
        child: Column(children: [
          CustomIconWidget(
              iconName: 'home_work', color: AppTheme.textSecondary, size: 48),
          SizedBox(height: 2.h),
          Text('Welcome to Ready Rental!',
              style: AppTheme.lightTheme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600)),
          SizedBox(height: 1.h),
          Text(
              'Get started by adding your first property or connecting with an agent.',
              style: AppTheme.lightTheme.textTheme.bodyMedium
                  ?.copyWith(color: AppTheme.textSecondary),
              textAlign: TextAlign.center),
          SizedBox(height: 3.h),
          Column(children: [
            ElevatedButton(
                onPressed: () =>
                    Navigator.pushNamed(context, '/property-search'),
                child: Text('Add Property')),
            SizedBox(height: 1.h),
            OutlinedButton(
                onPressed: () =>
                    Navigator.pushNamed(context, '/agent-dashboard'),
                child: Text('Connect with Agent')),
          ]),
        ]));
  }

  void _handlePortfolioCardTap(int index) {
    // Handle portfolio card tap for detailed breakdown
    Navigator.pushNamed(context, '/property-search');
  }

  void _handleQuickActionTap(String route) {
    Navigator.pushNamed(context, route);
  }

  void _handleBrokerageInvitation(bool accept) {
    setState(() {
      landlordData["hasBrokerageInvitation"] = false;
    });

    String message = accept
        ? 'Brokerage invitation accepted!'
        : 'Brokerage invitation declined.';

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _handleActivityTap(Map<String, dynamic> activity) {
    // Handle activity item tap
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: Text(activity["title"] as String),
                content: Text(activity["description"] as String),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Close')),
                  if (activity["actionable"] == true)
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _handleActivityApproval(activity);
                        },
                        child: Text('Take Action')),
                ]));
  }

  void _handleActivityApproval(Map<String, dynamic> activity) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('${activity["title"]} approved')));
  }

  void _handleActivityReview(Map<String, dynamic> activity) {
    Navigator.pushNamed(context, '/agent-dashboard');
  }

  void _showActivityContextMenu(Map<String, dynamic> activity) {
    showModalBottomSheet(
        context: context,
        builder: (context) => Container(
            padding: EdgeInsets.all(4.w),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              ListTile(
                  leading: CustomIconWidget(
                      iconName: 'reply', color: AppTheme.primaryRed, size: 24),
                  title: Text('Respond'),
                  onTap: () {
                    Navigator.pop(context);
                    _handleActivityApproval(activity);
                  }),
              ListTile(
                  leading: CustomIconWidget(
                      iconName: 'schedule',
                      color: AppTheme.primaryRed,
                      size: 24),
                  title: Text('Schedule'),
                  onTap: () {
                    Navigator.pop(context);
                    // Handle schedule action
                  }),
              ListTile(
                  leading: CustomIconWidget(
                      iconName: 'person_add',
                      color: AppTheme.primaryRed,
                      size: 24),
                  title: Text('Delegate'),
                  onTap: () {
                    Navigator.pop(context);
                    // Handle delegate action
                  }),
            ])));
  }
}
