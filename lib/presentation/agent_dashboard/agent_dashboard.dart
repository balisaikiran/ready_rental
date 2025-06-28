import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/activity_item_widget.dart';
import './widgets/metrics_card_widget.dart';
import './widgets/property_performance_widget.dart';
import './widgets/quick_action_widget.dart';

class AgentDashboard extends StatefulWidget {
  const AgentDashboard({super.key});

  @override
  State<AgentDashboard> createState() => _AgentDashboardState();
}

class _AgentDashboardState extends State<AgentDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isRefreshing = false;
  int _currentTabIndex = 0;

  // Mock data for agent dashboard
  final Map<String, dynamic> agentData = {
    "name": "Sarah Johnson",
    "pendingRequests": 3,
    "activeListings": 12,
    "pendingApplications": 8,
    "monthlyRevenue": "\$15,750",
    "profileImage":
        "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=400&h=400&fit=crop&crop=face"
  };

  final List<Map<String, dynamic>> metricsData = [
    {
      "title": "Active Listings",
      "value": "12",
      "change": "+2",
      "isPositive": true,
      "icon": "home"
    },
    {
      "title": "Pending Applications",
      "value": "8",
      "change": "+3",
      "isPositive": true,
      "icon": "description"
    },
    {
      "title": "Monthly Revenue",
      "value": "\$15,750",
      "change": "+12%",
      "isPositive": true,
      "icon": "attach_money"
    }
  ];

  final List<Map<String, dynamic>> quickActions = [
    {
      "title": "Add Property",
      "icon": "add_home",
      "color": Color(0xFFE53E3E),
      "route": "/property-search"
    },
    {
      "title": "New Tenant",
      "icon": "person_add",
      "color": Color(0xFF38A169),
      "route": "/tenant-dashboard"
    },
    {
      "title": "Service Requests",
      "icon": "build",
      "color": Color(0xFF3182CE),
      "route": "/agent-dashboard"
    },
    {
      "title": "Brokerage Invites",
      "icon": "group_add",
      "color": Color(0xFF805AD5),
      "route": "/landlord-dashboard"
    }
  ];

  final List<Map<String, dynamic>> recentActivities = [
    {
      "id": 1,
      "type": "application",
      "title": "New Application Received",
      "description": "John Smith applied for 123 Oak Street",
      "timestamp": "2 hours ago",
      "priority": "high",
      "avatar":
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop&crop=face"
    },
    {
      "id": 2,
      "type": "message",
      "title": "Tenant Message",
      "description": "Emily Davis: \"When can I schedule a viewing?\"",
      "timestamp": "4 hours ago",
      "priority": "medium",
      "avatar":
          "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&h=100&fit=crop&crop=face"
    },
    {
      "id": 3,
      "type": "inquiry",
      "title": "Property Inquiry",
      "description": "3 new inquiries for Sunset Apartments",
      "timestamp": "6 hours ago",
      "priority": "medium",
      "avatar":
          "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&h=100&fit=crop&crop=face"
    },
    {
      "id": 4,
      "type": "service",
      "title": "Service Request",
      "description": "Maintenance needed at 456 Pine Street",
      "timestamp": "1 day ago",
      "priority": "low",
      "avatar":
          "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&h=100&fit=crop&crop=face"
    }
  ];

  final List<Map<String, dynamic>> propertyPerformance = [
    {
      "title": "Listing Views",
      "value": "1,234",
      "trend": "+15%",
      "isPositive": true
    },
    {"title": "Inquiries", "value": "89", "trend": "+8%", "isPositive": true},
    {
      "title": "Application Rate",
      "value": "23%",
      "trend": "-2%",
      "isPositive": false
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    });
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

  void _handleQuickAction(String route) {
    Navigator.pushNamed(context, route);
  }

  void _handleActivityAction(Map<String, dynamic> activity, String action) {
    // Handle activity actions like respond, archive, etc.
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('$action action for ${activity["title"]}'),
        duration: Duration(seconds: 2)));
  }

  void _showAddActionSheet() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (context) => Container(
            padding: EdgeInsets.all(4.w),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                  width: 12.w,
                  height: 0.5.h,
                  decoration: BoxDecoration(
                      color: AppTheme.borderSubtle,
                      borderRadius: BorderRadius.circular(2))),
              SizedBox(height: 3.h),
              Text('Quick Actions',
                  style: AppTheme.lightTheme.textTheme.titleLarge),
              SizedBox(height: 3.h),
              ...quickActions.map((action) => ListTile(
                  leading: Container(
                      width: 10.w,
                      height: 10.w,
                      decoration: BoxDecoration(
                          color:
                              (action["color"] as Color).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8)),
                      child: CustomIconWidget(
                          iconName: action["icon"],
                          color: action["color"],
                          size: 6.w)),
                  title: Text(action["title"]),
                  onTap: () {
                    Navigator.pop(context);
                    _handleQuickAction(action["route"]);
                  })),
              SizedBox(height: 2.h),
            ])));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.backgroundWhite,
        body: SafeArea(
            child: Column(children: [
          _buildHeader(),
          Expanded(
              child: _currentTabIndex == 0
                  ? _buildDashboardContent()
                  : _buildOtherTabContent()),
        ])),
        bottomNavigationBar: _buildBottomNavigation(),
        floatingActionButton: _currentTabIndex == 0
            ? FloatingActionButton(
                onPressed: _showAddActionSheet,
                child: CustomIconWidget(
                    iconName: 'add',
                    color: AppTheme.backgroundWhite,
                    size: 6.w))
            : null);
  }

  Widget _buildHeader() {
    return Container(
        decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient, boxShadow: AppTheme.cardShadow),
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Row(children: [
          CircleAvatar(
              radius: 6.w,
              backgroundImage: NetworkImage(agentData["profileImage"])),
          SizedBox(width: 3.w),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text('Welcome back,',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color:
                            AppTheme.backgroundWhite.withValues(alpha: 0.8))),
                Text(agentData["name"],
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        color: AppTheme.backgroundWhite,
                        fontWeight: FontWeight.w600)),
              ])),
          Stack(children: [
            Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                    color: AppTheme.backgroundWhite.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8)),
                child: CustomIconWidget(
                    iconName: 'notifications',
                    color: AppTheme.backgroundWhite,
                    size: 6.w)),
            if (agentData["pendingRequests"] > 0)
              Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                      padding: EdgeInsets.all(1.w),
                      decoration: BoxDecoration(
                          color: AppTheme.backgroundWhite,
                          borderRadius: BorderRadius.circular(10)),
                      constraints:
                          BoxConstraints(minWidth: 5.w, minHeight: 5.w),
                      child: Text('${agentData["pendingRequests"]}',
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                                  color: AppTheme.primaryRed,
                                  fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center))),
          ]),
        ]));
  }

  Widget _buildDashboardContent() {
    return RefreshIndicator(
        onRefresh: _handleRefresh,
        color: AppTheme.primaryRed,
        child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(4.w),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _buildMetricsSection(),
              SizedBox(height: 3.h),
              _buildQuickActionsSection(),
              SizedBox(height: 3.h),
              _buildPropertyPerformanceSection(),
              SizedBox(height: 3.h),
              _buildRecentActivitySection(),
              SizedBox(height: 10.h), // Space for FAB
            ])));
  }

  Widget _buildMetricsSection() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Performance Overview',
          style: AppTheme.lightTheme.textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.w600)),
      SizedBox(height: 2.h),
      SizedBox(
          height: 20.h,
          child: PageView.builder(
              itemCount: metricsData.length,
              itemBuilder: (context, index) {
                return Padding(
                    padding: EdgeInsets.only(right: 3.w),
                    child: MetricsCardWidget(data: metricsData[index]));
              })),
    ]);
  }

  Widget _buildQuickActionsSection() {
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
            return QuickActionWidget(
                data: quickActions[index],
                onTap: () => _handleQuickAction(quickActions[index]["route"]));
          }),
    ]);
  }

  Widget _buildPropertyPerformanceSection() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Property Performance',
          style: AppTheme.lightTheme.textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.w600)),
      SizedBox(height: 2.h),
      Row(
          children: propertyPerformance.map((data) {
        return Expanded(
            child: Padding(
                padding: EdgeInsets.only(
                    right: data == propertyPerformance.last ? 0 : 2.w),
                child: PropertyPerformanceWidget(data: data)));
      }).toList()),
    ]);
  }

  Widget _buildRecentActivitySection() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('Recent Activity',
            style: AppTheme.lightTheme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.w600)),
        TextButton(
            onPressed: () {
              // Navigate to full activity list
            },
            child: Text('View All')),
      ]),
      SizedBox(height: 1.h),
      recentActivities.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: recentActivities.length,
              itemBuilder: (context, index) {
                return ActivityItemWidget(
                    data: recentActivities[index],
                    onAction: (action) =>
                        _handleActivityAction(recentActivities[index], action));
              }),
    ]);
  }

  Widget _buildEmptyState() {
    return Container(
        padding: EdgeInsets.all(8.w),
        child: Column(children: [
          CustomIconWidget(
              iconName: 'inbox', color: AppTheme.textSecondary, size: 15.w),
          SizedBox(height: 2.h),
          Text('No recent activity',
              style: AppTheme.lightTheme.textTheme.titleMedium
                  ?.copyWith(color: AppTheme.textSecondary)),
          SizedBox(height: 1.h),
          Text('Your activity feed will appear here',
              style: AppTheme.lightTheme.textTheme.bodyMedium
                  ?.copyWith(color: AppTheme.textSecondary),
              textAlign: TextAlign.center),
        ]));
  }

  Widget _buildOtherTabContent() {
    return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      CustomIconWidget(
          iconName: 'construction', color: AppTheme.textSecondary, size: 20.w),
      SizedBox(height: 2.h),
      Text('Coming Soon',
          style: AppTheme.lightTheme.textTheme.titleLarge
              ?.copyWith(color: AppTheme.textSecondary)),
      SizedBox(height: 1.h),
      Text('This section is under development',
          style: AppTheme.lightTheme.textTheme.bodyMedium
              ?.copyWith(color: AppTheme.textSecondary)),
    ]));
  }

  Widget _buildBottomNavigation() {
    return Container(
        decoration: BoxDecoration(color: AppTheme.backgroundWhite, boxShadow: [
          BoxShadow(
              color: AppTheme.shadowLight,
              blurRadius: 8,
              offset: Offset(0, -2)),
        ]),
        child: TabBar(
            controller: _tabController,
            indicatorColor: AppTheme.primaryRed,
            labelColor: AppTheme.primaryRed,
            unselectedLabelColor: AppTheme.textSecondary,
            labelStyle: AppTheme.lightTheme.textTheme.labelSmall
                ?.copyWith(fontWeight: FontWeight.w500),
            unselectedLabelStyle: AppTheme.lightTheme.textTheme.labelSmall,
            tabs: [
              Tab(
                  icon: CustomIconWidget(
                      iconName: 'dashboard',
                      color: _currentTabIndex == 0
                          ? AppTheme.primaryRed
                          : AppTheme.textSecondary,
                      size: 6.w),
                  text: 'Dashboard'),
              Tab(
                  icon: CustomIconWidget(
                      iconName: 'people',
                      color: _currentTabIndex == 1
                          ? AppTheme.primaryRed
                          : AppTheme.textSecondary,
                      size: 6.w),
                  text: 'Tenants'),
              Tab(
                  icon: CustomIconWidget(
                      iconName: 'home_work',
                      color: _currentTabIndex == 2
                          ? AppTheme.primaryRed
                          : AppTheme.textSecondary,
                      size: 6.w),
                  text: 'Properties'),
              Tab(
                  icon: CustomIconWidget(
                      iconName: 'business',
                      color: _currentTabIndex == 3
                          ? AppTheme.primaryRed
                          : AppTheme.textSecondary,
                      size: 6.w),
                  text: 'Brokerage'),
              Tab(
                  icon: CustomIconWidget(
                      iconName: 'person',
                      color: _currentTabIndex == 4
                          ? AppTheme.primaryRed
                          : AppTheme.textSecondary,
                      size: 6.w),
                  text: 'Profile'),
            ]));
  }
}
