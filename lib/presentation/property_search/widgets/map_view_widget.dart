import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MapViewWidget extends StatefulWidget {
  final List<Map<String, dynamic>> properties;
  final Function(int) onPropertyTap;

  const MapViewWidget({
    super.key,
    required this.properties,
    required this.onPropertyTap,
  });

  @override
  State<MapViewWidget> createState() => _MapViewWidgetState();
}

class _MapViewWidgetState extends State<MapViewWidget> {
  double _currentZoom = 12.0;
  Map<String, dynamic>? _selectedProperty;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildMapContainer(),
        if (_selectedProperty != null) _buildPropertyPreview(),
        _buildMapControls(),
      ],
    );
  }

  Widget _buildMapContainer() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppTheme.surfaceGray,
      child: Stack(
        children: [
          // Map background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.surfaceGray,
                  AppTheme.borderSubtle,
                ],
              ),
            ),
          ),
          // Map grid pattern
          CustomPaint(
            size: Size(double.infinity, double.infinity),
            painter: MapGridPainter(),
          ),
          // Property pins
          ...widget.properties.map((property) => _buildPropertyPin(property)),
          // Map overlay
          Center(
            child: Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.backgroundWhite.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(12),
                boxShadow: AppTheme.cardShadow,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'map',
                    color: AppTheme.primaryRed,
                    size: 48,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Interactive Map View',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Tap property pins to view details',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyPin(Map<String, dynamic> property) {
    final isSelected = _selectedProperty?['id'] == property['id'];
    final price = property['price'] as String;

    return Positioned(
      left: (property['id'] as int) * 15.w + 10.w,
      top: (property['id'] as int) * 12.h + 15.h,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedProperty = isSelected ? null : property;
          });
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          transform: Matrix4.identity()..scale(isSelected ? 1.1 : 1.0),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.primaryRed
                      : AppTheme.backgroundWhite,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: AppTheme.primaryRed,
                    width: 2,
                  ),
                  boxShadow: AppTheme.cardShadow,
                ),
                child: Text(
                  price,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: isSelected
                        ? AppTheme.backgroundWhite
                        : AppTheme.primaryRed,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                width: 0,
                height: 0,
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: Colors.transparent,
                      width: 1.5.w,
                    ),
                    right: BorderSide(
                      color: Colors.transparent,
                      width: 1.5.w,
                    ),
                    top: BorderSide(
                      color: isSelected
                          ? AppTheme.primaryRed
                          : AppTheme.backgroundWhite,
                      width: 2.w,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPropertyPreview() {
    if (_selectedProperty == null) return SizedBox.shrink();

    return Positioned(
      bottom: 4.w,
      left: 4.w,
      right: 4.w,
      child: GestureDetector(
        onTap: () => widget.onPropertyTap(_selectedProperty!['id'] as int),
        child: Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.backgroundWhite,
            borderRadius: BorderRadius.circular(12),
            boxShadow: AppTheme.elevatedShadow,
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CustomImageWidget(
                  imageUrl: _selectedProperty!['imageUrl'] as String,
                  width: 20.w,
                  height: 15.w,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedProperty!['title'] as String,
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      _selectedProperty!['price'] as String,
                      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                        color: AppTheme.primaryRed,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'bed',
                          color: AppTheme.textSecondary,
                          size: 14,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          '${_selectedProperty!['bedrooms']}',
                          style: AppTheme.lightTheme.textTheme.bodySmall,
                        ),
                        SizedBox(width: 3.w),
                        CustomIconWidget(
                          iconName: 'bathtub',
                          color: AppTheme.textSecondary,
                          size: 14,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          '${_selectedProperty!['bathrooms']}',
                          style: AppTheme.lightTheme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              CustomIconWidget(
                iconName: 'arrow_forward_ios',
                color: AppTheme.textSecondary,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMapControls() {
    return Positioned(
      right: 4.w,
      top: 20.h,
      child: Column(
        children: [
          _buildMapControlButton(
            icon: 'add',
            onTap: () {
              setState(() {
                _currentZoom = (_currentZoom + 1).clamp(8.0, 18.0);
              });
            },
          ),
          SizedBox(height: 2.w),
          _buildMapControlButton(
            icon: 'remove',
            onTap: () {
              setState(() {
                _currentZoom = (_currentZoom - 1).clamp(8.0, 18.0);
              });
            },
          ),
          SizedBox(height: 4.w),
          _buildMapControlButton(
            icon: 'my_location',
            onTap: () {
              // Center map on user location
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMapControlButton({
    required String icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: AppTheme.backgroundWhite,
          borderRadius: BorderRadius.circular(8),
          boxShadow: AppTheme.cardShadow,
        ),
        child: CustomIconWidget(
          iconName: icon,
          color: AppTheme.textPrimary,
          size: 20,
        ),
      ),
    );
  }
}

class MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.borderSubtle.withValues(alpha: 0.3)
      ..strokeWidth = 1;

    const gridSize = 50.0;

    // Draw vertical lines
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Draw horizontal lines
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
