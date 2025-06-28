import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/tenant_card_widget.dart';
import './widgets/tenant_filter_widget.dart';
import './widgets/tenant_summary_widget.dart';

class MyTenantsScreen extends StatefulWidget {
  const MyTenantsScreen({super.key});

  @override
  State<MyTenantsScreen> createState() => _MyTenantsScreenState();
}

class _MyTenantsScreenState extends State<MyTenantsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  Map<String, dynamic> _currentFilters = {
    'leaseStatus': 'All',
    'paymentStatus': 'All',
    'property': 'All Properties',
  };

  String _searchQuery = '';
  final bool _isSearching = false;

  // Mock tenant counts
  Map<String, int> tenantCounts = {
    'active': 12,
    'pending': 3,
    'expired': 2,
  };

  // Mock tenant data
  List<Map<String, dynamic>> allTenants = [
    {
      'id': 1,
      'name': 'Alex Johnson',
      'profileImage':
          'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg',
      'propertyAddress': '123 Downtown Apt, Unit 4B',
      'rentAmount': '\$1,450/month',
      'leaseStatus': 'active',
      'paymentStatus': 'paid',
      'leaseEndDate': 'Dec 2024',
      'phone': '+1 (555) 123-4567',
      'email': 'alex.johnson@email.com',
    },
    {
      'id': 2,
      'name': 'Maria Garcia',
      'profileImage':
          'https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg',
      'propertyAddress': '456 Midtown Loft, Suite 2A',
      'rentAmount': '\$1,200/month',
      'leaseStatus': 'active',
      'paymentStatus': 'due',
      'leaseEndDate': 'Jan 2025',
      'phone': '+1 (555) 987-6543',
      'email': 'maria.garcia@email.com',
    },
    {
      'id': 3,
      'name': 'David Chen',
      'profileImage':
          'https://images.pexels.com/photos/697509/pexels-photo-697509.jpeg',
      'propertyAddress': '789 Uptown House, Unit 1',
      'rentAmount': '\$1,800/month',
      'leaseStatus': 'pending',
      'paymentStatus': 'pending',
      'leaseEndDate': 'Mar 2025',
      'phone': '+1 (555) 456-7890',
      'email': 'david.chen@email.com',
    },
    {
      'id': 4,
      'name': 'Sarah Williams',
      'profileImage':
          'https://images.pixabay.com/photo/2017/11/02/14/26/model-2911330_1280.jpg',
      'propertyAddress': '321 Riverside View, Apt 5C',
      'rentAmount': '\$1,350/month',
      'leaseStatus': 'active',
      'paymentStatus': 'paid',
      'leaseEndDate': 'Nov 2024',
      'phone': '+1 (555) 321-0987',
      'email': 'sarah.williams@email.com',
    },
    {
      'id': 5,
      'name': 'Michael Brown',
      'profileImage':
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d',
      'propertyAddress': '654 Parkside Towers, Unit 8B',
      'rentAmount': '\$1,600/month',
      'leaseStatus': 'expired',
      'paymentStatus': 'overdue',
      'leaseEndDate': 'Sep 2024',
      'phone': '+1 (555) 654-3210',
      'email': 'michael.brown@email.com',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredTenants {
    List<Map<String, dynamic>> filtered = allTenants;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((tenant) {
        final name = tenant['name']?.toLowerCase() ?? '';
        final address = tenant['propertyAddress']?.toLowerCase() ?? '';
        final query = _searchQuery.toLowerCase();
        return name.contains(query) || address.contains(query);
      }).toList();
    }

    // Apply status filters
    if (_currentFilters['leaseStatus'] != 'All') {
      filtered = filtered.where((tenant) {
        return tenant['leaseStatus']?.toLowerCase() ==
            _currentFilters['leaseStatus']?.toLowerCase();
      }).toList();
    }

    if (_currentFilters['paymentStatus'] != 'All') {
      filtered = filtered.where((tenant) {
        return tenant['paymentStatus']?.toLowerCase() ==
            _currentFilters['paymentStatus']?.toLowerCase();
      }).toList();
    }

    return filtered;
  }

  Future<void> _onRefresh() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      // Refresh tenant data
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _onFilterPressed() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => TenantFilterWidget(
            currentFilters: _currentFilters,
            onFiltersChanged: (filters) {
              setState(() {
                _currentFilters = filters;
              });
            }));
  }

  void _onAddTenant() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: Text('Add New Tenant'),
                content:
                    Text('Feature to add new tenant will be implemented here.'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel')),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Add tenant feature coming soon!'),
                            backgroundColor: AppTheme.primaryRed));
                      },
                      child: Text('Add')),
                ]));
  }

  void _onTenantTap(Map<String, dynamic> tenant) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => _buildTenantDetailScreen(tenant)));
  }

  void _onMessageTenant(Map<String, dynamic> tenant) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Opening chat with ${tenant['name']}'),
        backgroundColor: AppTheme.primaryRed));
  }

  void _onCallTenant(Map<String, dynamic> tenant) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Calling ${tenant['name']} at ${tenant['phone']}'),
        backgroundColor: AppTheme.successGreen));
  }

  void _onViewLease(Map<String, dynamic> tenant) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: Text('Lease Details'),
                content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tenant: ${tenant['name']}'),
                      SizedBox(height: 1.h),
                      Text('Property: ${tenant['propertyAddress']}'),
                      SizedBox(height: 1.h),
                      Text('Rent: ${tenant['rentAmount']}'),
                      SizedBox(height: 1.h),
                      Text('Status: ${tenant['leaseStatus']}'),
                      SizedBox(height: 1.h),
                      Text('Lease End: ${tenant['leaseEndDate']}'),
                    ]),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Close')),
                  ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('View Full Lease')),
                ]));
  }

  @override
  Widget build(BuildContext context) {
    final displayedTenants = filteredTenants;

    return Scaffold(
        backgroundColor: AppTheme.backgroundWhite,
        appBar: AppBar(
            title: Text('My Tenants',
                style: AppTheme.lightTheme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w600)),
            elevation: 0,
            backgroundColor: AppTheme.backgroundWhite,
            actions: [
              IconButton(
                  onPressed: _onFilterPressed,
                  icon: CustomIconWidget(
                      iconName: 'filter_list',
                      color: AppTheme.textPrimary,
                      size: 24)),
            ]),
        body: RefreshIndicator(
            onRefresh: _onRefresh,
            color: AppTheme.primaryRed,
            child: Column(children: [
              TenantSummaryWidget(tenantCounts: tenantCounts),
              _buildSearchBar(),
              SizedBox(height: 2.h),
              Expanded(
                  child: displayedTenants.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.only(bottom: 10.h),
                          itemCount: displayedTenants.length,
                          itemBuilder: (context, index) {
                            final tenant = displayedTenants[index];
                            return TenantCardWidget(
                                tenant: tenant,
                                onTap: () => _onTenantTap(tenant),
                                onMessage: () => _onMessageTenant(tenant),
                                onCall: () => _onCallTenant(tenant),
                                onViewLease: () => _onViewLease(tenant));
                          })),
            ])),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: _onAddTenant,
            backgroundColor: AppTheme.primaryRed,
            foregroundColor: AppTheme.backgroundWhite,
            icon: CustomIconWidget(
                iconName: 'person_add',
                color: AppTheme.backgroundWhite,
                size: 20),
            label: Text('Add Tenant',
                style: AppTheme.lightTheme.textTheme.labelLarge
                    ?.copyWith(color: AppTheme.backgroundWhite))));
  }

  Widget _buildSearchBar() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        decoration: BoxDecoration(
            color: AppTheme.surfaceGray,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.borderSubtle)),
        child: Row(children: [
          CustomIconWidget(
              iconName: 'search', color: AppTheme.textSecondary, size: 24),
          SizedBox(width: 3.w),
          Expanded(
              child: TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  style: AppTheme.lightTheme.textTheme.bodyLarge,
                  decoration: InputDecoration(
                      hintText: 'Search tenants or properties...',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 3.w)))),
          if (_searchQuery.isNotEmpty)
            GestureDetector(
                onTap: () {
                  _searchController.clear();
                  _onSearchChanged('');
                },
                child: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.textSecondary,
                    size: 20)),
        ]));
  }

  Widget _buildEmptyState() {
    return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      CustomIconWidget(
          iconName: 'group', color: AppTheme.textSecondary, size: 64),
      SizedBox(height: 2.h),
      Text(_searchQuery.isNotEmpty ? 'No tenants found' : 'No tenants yet',
          style: AppTheme.lightTheme.textTheme.headlineSmall
              ?.copyWith(color: AppTheme.textSecondary)),
      SizedBox(height: 1.h),
      Text(
          _searchQuery.isNotEmpty
              ? 'Try adjusting your search or filters'
              : 'Add your first tenant to get started',
          style: AppTheme.lightTheme.textTheme.bodyMedium
              ?.copyWith(color: AppTheme.textSecondary),
          textAlign: TextAlign.center),
      if (_searchQuery.isEmpty) ...[
        SizedBox(height: 4.h),
        ElevatedButton(
            onPressed: _onAddTenant, child: Text('Add Your First Tenant')),
      ],
    ]));
  }

  Widget _buildTenantDetailScreen(Map<String, dynamic> tenant) {
    return Scaffold(
        appBar: AppBar(
            title: Text(tenant['name'] ?? 'Tenant Details'),
            backgroundColor: AppTheme.backgroundWhite),
        backgroundColor: AppTheme.backgroundWhite,
        body: Padding(
            padding: EdgeInsets.all(4.w),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Center(
                  child: CircleAvatar(
                      radius: 15.w,
                      backgroundColor: AppTheme.surfaceGray,
                      child: CustomImageWidget(
                          imageUrl: tenant['profileImage'],
                          width: 30.w, 
                          height: 30.w, 
                          fit: BoxFit.cover))),
              SizedBox(height: 3.h),
              _buildDetailRow('Name', tenant['name'] ?? ''),
              _buildDetailRow('Property', tenant['propertyAddress'] ?? ''),
              _buildDetailRow('Rent Amount', tenant['rentAmount'] ?? ''),
              _buildDetailRow('Lease Status', tenant['leaseStatus'] ?? ''),
              _buildDetailRow('Payment Status', tenant['paymentStatus'] ?? ''),
              _buildDetailRow('Lease End Date', tenant['leaseEndDate'] ?? ''),
              _buildDetailRow('Phone', tenant['phone'] ?? ''),
              _buildDetailRow('Email', tenant['email'] ?? ''),
              Spacer(),
              Row(children: [
                Expanded(
                    child: OutlinedButton(
                        onPressed: () => _onMessageTenant(tenant),
                        child: Text('Message'))),
                SizedBox(width: 4.w),
                Expanded(
                    child: ElevatedButton(
                        onPressed: () => _onCallTenant(tenant),
                        child: Text('Call'))),
              ]),
            ])));
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
        padding: EdgeInsets.only(bottom: 2.h),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
              width: 30.w,
              child: Text(label,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondary))),
          Expanded(
              child: Text(value,
                  style: AppTheme.lightTheme.textTheme.bodyMedium
                      ?.copyWith(color: AppTheme.textPrimary))),
        ]));
  }
}