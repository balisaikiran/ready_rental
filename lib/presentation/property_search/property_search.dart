import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/empty_results_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/map_view_widget.dart';
import './widgets/property_card_widget.dart';
import './widgets/search_suggestions_widget.dart';

class PropertySearch extends StatefulWidget {
  const PropertySearch({super.key});

  @override
  State<PropertySearch> createState() => _PropertySearchState();
}

class _PropertySearchState extends State<PropertySearch>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late TabController _viewTabController;

  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _showSuggestions = false;
  int _activeFilters = 0;
  String _selectedSort = 'Price: Low to High';
  final int _currentPage = 1;
  final int _itemsPerPage = 10;

  // Mock data for properties
  final List<Map<String, dynamic>> _allProperties = [
    {
      "id": 1,
      "title": "Modern Downtown Apartment",
      "price": "\$2,500",
      "bedrooms": 2,
      "bathrooms": 2,
      "distance": "0.5 miles",
      "rating": 4.8,
      "imageUrl":
          "https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800&h=600&fit=crop",
      "address": "123 Main St, Downtown",
      "amenities": ["Parking", "Gym", "Pool"],
      "isInterested": false,
      "latitude": 40.7128,
      "longitude": -74.0060,
    },
    {
      "id": 2,
      "title": "Cozy Studio Near University",
      "price": "\$1,800",
      "bedrooms": 1,
      "bathrooms": 1,
      "distance": "1.2 miles",
      "rating": 4.5,
      "imageUrl":
          "https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800&h=600&fit=crop",
      "address": "456 College Ave, University District",
      "amenities": ["WiFi", "Laundry"],
      "isInterested": false,
      "latitude": 40.7589,
      "longitude": -73.9851,
    },
    {
      "id": 3,
      "title": "Luxury Penthouse with View",
      "price": "\$4,200",
      "bedrooms": 3,
      "bathrooms": 3,
      "distance": "2.1 miles",
      "rating": 4.9,
      "imageUrl":
          "https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=800&h=600&fit=crop",
      "address": "789 Skyline Dr, Uptown",
      "amenities": ["Parking", "Gym", "Pool", "Concierge"],
      "isInterested": true,
      "latitude": 40.7831,
      "longitude": -73.9712,
    },
    {
      "id": 4,
      "title": "Family Home with Garden",
      "price": "\$3,100",
      "bedrooms": 4,
      "bathrooms": 2,
      "distance": "3.5 miles",
      "rating": 4.6,
      "imageUrl":
          "https://images.unsplash.com/photo-1570129477492-45c003edd2be?w=800&h=600&fit=crop",
      "address": "321 Oak Street, Suburbs",
      "amenities": ["Garden", "Parking", "Pet Friendly"],
      "isInterested": false,
      "latitude": 40.7282,
      "longitude": -74.0776,
    },
    {
      "id": 5,
      "title": "Industrial Loft Space",
      "price": "\$2,800",
      "bedrooms": 2,
      "bathrooms": 1,
      "distance": "1.8 miles",
      "rating": 4.4,
      "imageUrl":
          "https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=800&h=600&fit=crop",
      "address": "654 Industrial Blvd, Arts District",
      "amenities": ["High Ceilings", "Exposed Brick"],
      "isInterested": false,
      "latitude": 40.7505,
      "longitude": -73.9934,
    },
  ];

  List<Map<String, dynamic>> _filteredProperties = [];
  List<Map<String, dynamic>> _displayedProperties = [];

  final List<String> _searchSuggestions = [
    "Downtown apartments",
    "Near subway station",
    "Pet-friendly rentals",
    "Luxury condos",
    "Student housing",
    "Family homes",
  ];

  final List<String> _sortOptions = [
    'Price: Low to High',
    'Price: High to Low',
    'Distance: Nearest',
    'Newest Listed',
    'Highest Rated',
  ];

  @override
  void initState() {
    super.initState();
    _viewTabController = TabController(length: 2, vsync: this);
    _filteredProperties = List.from(_allProperties);
    _loadInitialProperties();
    _scrollController.addListener(_onScroll);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _viewTabController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _loadInitialProperties() {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(Duration(milliseconds: 800), () {
      setState(() {
        _displayedProperties = _filteredProperties.take(_itemsPerPage).toList();
        _isLoading = false;
      });
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore &&
        _displayedProperties.length < _filteredProperties.length) {
      _loadMoreProperties();
    }
  }

  void _loadMoreProperties() {
    setState(() {
      _isLoadingMore = true;
    });

    Future.delayed(Duration(milliseconds: 500), () {
      final nextItems = _filteredProperties
          .skip(_displayedProperties.length)
          .take(_itemsPerPage)
          .toList();

      setState(() {
        _displayedProperties.addAll(nextItems);
        _isLoadingMore = false;
      });
    });
  }

  void _onSearchChanged() {
    setState(() {
      _showSuggestions = _searchController.text.isNotEmpty;
    });
  }

  void _performSearch(String query) {
    setState(() {
      _showSuggestions = false;
      _isLoading = true;
    });

    Future.delayed(Duration(milliseconds: 600), () {
      final filtered = _allProperties.where((property) {
        final title = (property['title'] as String).toLowerCase();
        final address = (property['address'] as String).toLowerCase();
        final searchQuery = query.toLowerCase();
        return title.contains(searchQuery) || address.contains(searchQuery);
      }).toList();

      setState(() {
        _filteredProperties = filtered;
        _displayedProperties = filtered.take(_itemsPerPage).toList();
        _isLoading = false;
      });
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheetWidget(
        onFiltersApplied: (filterCount) {
          setState(() {
            _activeFilters = filterCount;
          });
          _applyFilters();
        },
      ),
    );
  }

  void _applyFilters() {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _displayedProperties = _filteredProperties.take(_itemsPerPage).toList();
        _isLoading = false;
      });
    });
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 10.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.borderSubtle,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Sort by',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 2.h),
            ..._sortOptions.map((option) => ListTile(
                  title: Text(
                    option,
                    style: AppTheme.lightTheme.textTheme.bodyLarge,
                  ),
                  trailing: _selectedSort == option
                      ? CustomIconWidget(
                          iconName: 'check',
                          color: AppTheme.primaryRed,
                          size: 20,
                        )
                      : null,
                  onTap: () {
                    setState(() {
                      _selectedSort = option;
                    });
                    Navigator.pop(context);
                    _applySorting();
                  },
                )),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _applySorting() {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(Duration(milliseconds: 400), () {
      List<Map<String, dynamic>> sorted = List.from(_filteredProperties);

      switch (_selectedSort) {
        case 'Price: Low to High':
          sorted.sort((a, b) {
            final priceA = double.parse(
                (a['price'] as String).replaceAll(RegExp(r'[^\d.]'), ''));
            final priceB = double.parse(
                (b['price'] as String).replaceAll(RegExp(r'[^\d.]'), ''));
            return priceA.compareTo(priceB);
          });
          break;
        case 'Price: High to Low':
          sorted.sort((a, b) {
            final priceA = double.parse(
                (a['price'] as String).replaceAll(RegExp(r'[^\d.]'), ''));
            final priceB = double.parse(
                (b['price'] as String).replaceAll(RegExp(r'[^\d.]'), ''));
            return priceB.compareTo(priceA);
          });
          break;
        case 'Distance: Nearest':
          sorted.sort((a, b) {
            final distA = double.parse((a['distance'] as String).split(' ')[0]);
            final distB = double.parse((b['distance'] as String).split(' ')[0]);
            return distA.compareTo(distB);
          });
          break;
        case 'Highest Rated':
          sorted.sort((a, b) =>
              (b['rating'] as double).compareTo(a['rating'] as double));
          break;
      }

      setState(() {
        _filteredProperties = sorted;
        _displayedProperties = sorted.take(_itemsPerPage).toList();
        _isLoading = false;
      });
    });
  }

  void _onPropertyInterested(int propertyId) {
    setState(() {
      final index =
          _displayedProperties.indexWhere((p) => p['id'] == propertyId);
      if (index != -1) {
        _displayedProperties[index]['isInterested'] =
            !_displayedProperties[index]['isInterested'];
      }
    });
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(Duration(milliseconds: 1000));

    setState(() {
      _displayedProperties = _filteredProperties.take(_itemsPerPage).toList();
      _isLoading = false;
    });
  }

  void _clearFilters() {
    setState(() {
      _activeFilters = 0;
      _filteredProperties = List.from(_allProperties);
      _displayedProperties = _filteredProperties.take(_itemsPerPage).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildViewToggle(),
            Expanded(
              child: Stack(
                children: [
                  TabBarView(
                    controller: _viewTabController,
                    children: [
                      _buildListView(),
                      MapViewWidget(
                        properties: _filteredProperties,
                        onPropertyTap: (propertyId) {
                          // Navigate to property detail
                        },
                      ),
                    ],
                  ),
                  if (_showSuggestions) _buildSearchSuggestions(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundWhite.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: 'arrow_back',
                    color: AppTheme.backgroundWhite,
                    size: 20,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundWhite,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: AppTheme.cardShadow,
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search properties...',
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(3.w),
                        child: CustomIconWidget(
                          iconName: 'search',
                          color: AppTheme.textSecondary,
                          size: 20,
                        ),
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? GestureDetector(
                              onTap: () {
                                _searchController.clear();
                                setState(() {
                                  _showSuggestions = false;
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.all(3.w),
                                child: CustomIconWidget(
                                  iconName: 'close',
                                  color: AppTheme.textSecondary,
                                  size: 20,
                                ),
                              ),
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 2.h,
                      ),
                    ),
                    onSubmitted: _performSearch,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              GestureDetector(
                onTap: _showFilterBottomSheet,
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundWhite.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Stack(
                    children: [
                      CustomIconWidget(
                        iconName: 'tune',
                        color: AppTheme.backgroundWhite,
                        size: 20,
                      ),
                      if (_activeFilters > 0)
                        Positioned(
                          right: -2,
                          top: -2,
                          child: Container(
                            padding: EdgeInsets.all(1.w),
                            decoration: BoxDecoration(
                              color: AppTheme.backgroundWhite,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              _activeFilters.toString(),
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: AppTheme.primaryRed,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 2.w),
              GestureDetector(
                onTap: _showSortOptions,
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundWhite.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: 'sort',
                    color: AppTheme.backgroundWhite,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildViewToggle() {
    return Container(
      margin: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceGray,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _viewTabController,
        indicator: BoxDecoration(
          color: AppTheme.primaryRed,
          borderRadius: BorderRadius.circular(10),
        ),
        labelColor: AppTheme.backgroundWhite,
        unselectedLabelColor: AppTheme.textSecondary,
        dividerColor: Colors.transparent,
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'list',
                  color: _viewTabController.index == 0
                      ? AppTheme.backgroundWhite
                      : AppTheme.textSecondary,
                  size: 18,
                ),
                SizedBox(width: 2.w),
                Text('List'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'map',
                  color: _viewTabController.index == 1
                      ? AppTheme.backgroundWhite
                      : AppTheme.textSecondary,
                  size: 18,
                ),
                SizedBox(width: 2.w),
                Text('Map'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListView() {
    if (_isLoading && _displayedProperties.isEmpty) {
      return _buildLoadingView();
    }

    if (_displayedProperties.isEmpty) {
      return EmptyResultsWidget(
        onClearFilters: _clearFilters,
        hasActiveFilters: _activeFilters > 0,
      );
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: AppTheme.primaryRed,
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: _displayedProperties.length + (_isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _displayedProperties.length) {
            return _buildLoadingMoreIndicator();
          }

          final property = _displayedProperties[index];
          return PropertyCardWidget(
            property: property,
            onInterested: () => _onPropertyInterested(property['id'] as int),
            onTap: () {
              // Navigate to property detail
            },
          );
        },
      ),
    );
  }

  Widget _buildSearchSuggestions() {
    return SearchSuggestionsWidget(
      suggestions: _searchSuggestions,
      onSuggestionTap: (suggestion) {
        _searchController.text = suggestion;
        _performSearch(suggestion);
      },
    );
  }

  Widget _buildLoadingView() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      itemCount: 5,
      itemBuilder: (context, index) => _buildSkeletonCard(),
    );
  }

  Widget _buildSkeletonCard() {
    return Container(
      margin: EdgeInsets.only(bottom: 4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 25.h,
            decoration: BoxDecoration(
              color: AppTheme.surfaceGray,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            width: 60.w,
            height: 2.h,
            decoration: BoxDecoration(
              color: AppTheme.surfaceGray,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(height: 1.h),
          Container(
            width: 40.w,
            height: 1.5.h,
            decoration: BoxDecoration(
              color: AppTheme.surfaceGray,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingMoreIndicator() {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Center(
        child: CircularProgressIndicator(
          color: AppTheme.primaryRed,
          strokeWidth: 2,
        ),
      ),
    );
  }
}
