import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/amenities_widget.dart';
import './widgets/landlord_contact_widget.dart';
import './widgets/property_description_widget.dart';
import './widgets/property_image_carousel_widget.dart';
import './widgets/property_info_widget.dart';

class PropertyDetailScreen extends StatefulWidget {
  final Map<String, dynamic>? property;

  const PropertyDetailScreen({
    super.key,
    this.property,
  });

  @override
  State<PropertyDetailScreen> createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  bool _isFavorite = false;
  bool _isInterested = false;
  late ScrollController _scrollController;

  // Mock property data
  late Map<String, dynamic> propertyData;
  late List<String> imageUrls;
  late List<Map<String, dynamic>> amenities;
  late Map<String, dynamic> landlordInfo;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _initializePropertyData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _initializePropertyData() {
    propertyData = widget.property ??
        {
          'id': 1,
          'title': 'Modern Downtown Apartment',
          'location': '123 Main Street, Downtown District',
          'price': '\$1,450',
          'period': '/month',
          'bedrooms': 2,
          'bathrooms': 2,
          'area': '850 sq ft',
          'rating': 4.8,
          'description':
              'Experience urban living at its finest in this beautifully designed 2-bedroom, 2-bathroom apartment located in the heart of downtown. This modern unit features floor-to-ceiling windows, premium finishes, and an open-concept layout perfect for both relaxation and entertaining. The kitchen boasts stainless steel appliances, quartz countertops, and ample storage space. Both bedrooms offer generous closet space and natural light. Building amenities include a fitness center, rooftop terrace, and 24/7 concierge service.',
        };

    imageUrls = [
      'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3',
      'https://images.pexels.com/photos/1643383/pexels-photo-1643383.jpeg',
      'https://images.pixabay.com/photo/2016/11/18/17/46/house-1836070_1280.jpg',
      'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3',
      'https://images.pexels.com/photos/1080721/pexels-photo-1080721.jpeg',
    ];

    amenities = [
      {'name': 'Air Conditioning', 'icon': 'ac_unit'},
      {'name': 'Parking', 'icon': 'local_parking'},
      {'name': 'Gym', 'icon': 'fitness_center'},
      {'name': 'Swimming Pool', 'icon': 'pool'},
      {'name': 'Laundry', 'icon': 'local_laundry_service'},
      {'name': 'Pet Friendly', 'icon': 'pets'},
      {'name': 'Balcony', 'icon': 'balcony'},
      {'name': 'WiFi', 'icon': 'wifi'},
    ];

    landlordInfo = {
      'name': 'Sarah Johnson',
      'title': 'Licensed Real Estate Agent',
      'profileImage':
          'https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg',
      'rating': 4.8,
      'reviewCount': 127,
      'phone': '+1 (555) 123-4567',
    };
  }

  void _onBackPressed() {
    Navigator.pop(context);
  }

  void _onSharePressed() {
    // Handle property sharing
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Property shared successfully!'),
        backgroundColor: AppTheme.successGreen));
  }

  void _onFavoriteToggle() {
    setState(() {
      _isFavorite = !_isFavorite;
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text(_isFavorite ? 'Added to favorites' : 'Removed from favorites'),
        backgroundColor:
            _isFavorite ? AppTheme.successGreen : AppTheme.textSecondary));
  }

  void _onApplyNow() {
    // Handle apply now action
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => _buildApplyBottomSheet());
  }

  void _onAddToInterested() {
    setState(() {
      _isInterested = !_isInterested;
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(_isInterested
            ? 'Added to interested properties'
            : 'Removed from interested properties'),
        backgroundColor:
            _isInterested ? AppTheme.successGreen : AppTheme.textSecondary));
  }

  void _onContactLandlord() {
    // Handle contact landlord
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: Text('Contact ${landlordInfo['name']}'),
                content:
                    Text('Choose how you would like to contact the agent:'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Handle call
                      },
                      child: Text('Call')),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Handle message
                      },
                      child: Text('Message')),
                ]));
  }

  void _onImageTap() {
    // Handle image gallery view
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => _buildImageGallery()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.backgroundWhite,
        body: Stack(children: [
          CustomScrollView(controller: _scrollController, slivers: [
            _buildAppBar(),
            SliverToBoxAdapter(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  PropertyInfoWidget(property: propertyData),

                  SizedBox(height: 2.h),

                  LandlordContactWidget(
                      landlordInfo: landlordInfo,
                      onMessageTap: _onContactLandlord,
                      onCallTap: _onContactLandlord),

                  SizedBox(height: 3.h),

                  AmenitiesWidget(amenities: amenities),

                  SizedBox(height: 3.h),

                  PropertyDescriptionWidget(
                      description: propertyData['description'] ?? ''),

                  SizedBox(height: 3.h),

                  _buildLocationSection(),

                  SizedBox(height: 10.h), // Space for bottom buttons
                ])),
          ]),
          _buildFloatingFavoriteButton(),
          _buildBottomActionButtons(),
        ]));
  }

  Widget _buildAppBar() {
    return SliverAppBar(
        expandedHeight: 40.h,
        floating: false,
        pinned: true,
        backgroundColor: AppTheme.backgroundWhite,
        elevation: 0,
        leading: GestureDetector(
            onTap: _onBackPressed,
            child: Container(
                margin: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(12)),
                child: CustomIconWidget(
                    iconName: 'arrow_back',
                    color: AppTheme.backgroundWhite,
                    size: 24))),
        actions: [
          GestureDetector(
              onTap: _onSharePressed,
              child: Container(
                  margin: EdgeInsets.all(2.w),
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(12)),
                  child: CustomIconWidget(
                      iconName: 'share',
                      color: AppTheme.backgroundWhite,
                      size: 24))),
        ],
        flexibleSpace: FlexibleSpaceBar(
            background: PropertyImageCarouselWidget(
                imageUrls: imageUrls, onImageTap: _onImageTap)));
  }

  Widget _buildLocationSection() {
    return Container(
        padding: EdgeInsets.all(4.w),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Location',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
          SizedBox(height: 2.h),
          Container(
              height: 25.h,
              decoration: BoxDecoration(
                  color: AppTheme.surfaceGray,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.borderSubtle)),
              child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    CustomIconWidget(
                        iconName: 'map',
                        color: AppTheme.textSecondary,
                        size: 48),
                    SizedBox(height: 1.h),
                    Text('Interactive Map',
                        style: AppTheme.lightTheme.textTheme.titleMedium
                            ?.copyWith(color: AppTheme.textSecondary)),
                    SizedBox(height: 0.5.h),
                    Text(propertyData['location'] ?? 'Property Location',
                        style: AppTheme.lightTheme.textTheme.bodySmall
                            ?.copyWith(color: AppTheme.textSecondary),
                        textAlign: TextAlign.center),
                  ]))),
        ]));
  }

  Widget _buildFloatingFavoriteButton() {
    return Positioned(
        top: 45.h,
        right: 4.w,
        child: GestureDetector(
            onTap: _onFavoriteToggle,
            child: Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                    color: AppTheme.backgroundWhite,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: AppTheme.cardShadow),
                child: CustomIconWidget(
                    iconName: _isFavorite ? 'favorite' : 'favorite_border',
                    color: _isFavorite
                        ? AppTheme.primaryRed
                        : AppTheme.textSecondary,
                    size: 24))));
  }

  Widget _buildBottomActionButtons() {
    return Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
            padding: EdgeInsets.all(4.w),
            decoration:
                BoxDecoration(color: AppTheme.backgroundWhite, boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: Offset(0, -2)),
            ]),
            child: SafeArea(
                child: Row(children: [
              Expanded(
                  flex: 1,
                  child: OutlinedButton(
                      onPressed: _onAddToInterested,
                      style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 4.w),
                          side: BorderSide(
                              color: _isInterested
                                  ? AppTheme.successGreen
                                  : AppTheme.primaryRed)),
                      child: Text(
                          _isInterested ? 'Interested' : 'Add to Interested',
                          style: TextStyle(
                              color: _isInterested
                                  ? AppTheme.successGreen
                                  : AppTheme.primaryRed,
                              fontWeight: FontWeight.w600)))),
              SizedBox(width: 4.w),
              Expanded(
                  flex: 2,
                  child: ElevatedButton(
                      onPressed: _onApplyNow,
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 4.w),
                          backgroundColor: AppTheme.primaryRed),
                      child: Text('Apply Now',
                          style: TextStyle(
                              color: AppTheme.backgroundWhite,
                              fontWeight: FontWeight.w600,
                              fontSize: 16)))),
            ]))));
  }

  Widget _buildApplyBottomSheet() {
    return Container(
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
          Text('Apply for Property',
              style: AppTheme.lightTheme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w600)),
          SizedBox(height: 2.h),
          Text(
              'You\'re about to apply for ${propertyData['title']}. Please review the details and submit your application.',
              style: AppTheme.lightTheme.textTheme.bodyMedium
                  ?.copyWith(color: AppTheme.textSecondary),
              textAlign: TextAlign.center),
          SizedBox(height: 4.h),
          SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Application submitted successfully!'),
                        backgroundColor: AppTheme.successGreen));
                  },
                  child: Text('Submit Application'))),
          SizedBox(height: 2.h),
          SizedBox(
              width: double.infinity,
              child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'))),
        ])));
  }

  Widget _buildImageGallery() {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: IconThemeData(color: AppTheme.backgroundWhite),
            title: Text('Property Photos',
                style: TextStyle(color: AppTheme.backgroundWhite))),
        body: PageView.builder(
            itemCount: imageUrls.length,
            itemBuilder: (context, index) {
              return Center(
                  child: CustomImageWidget(
                      imageUrl: imageUrls[index],
                      width: double.infinity, 
                      fit: BoxFit.contain));
            }));
  }
}