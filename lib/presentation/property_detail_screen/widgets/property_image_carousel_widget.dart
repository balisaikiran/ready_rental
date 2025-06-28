import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PropertyImageCarouselWidget extends StatefulWidget {
  final List<String> imageUrls;
  final Function()? onImageTap;

  const PropertyImageCarouselWidget({
    super.key,
    required this.imageUrls,
    this.onImageTap,
  });

  @override
  State<PropertyImageCarouselWidget> createState() =>
      _PropertyImageCarouselWidgetState();
}

class _PropertyImageCarouselWidgetState
    extends State<PropertyImageCarouselWidget> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 40.h,
        child: Stack(children: [
          PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemCount: widget.imageUrls.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: widget.onImageTap,
                    child: CustomImageWidget(
                        imageUrl: widget.imageUrls[index],
                        width: double.infinity,
                        height: 40.h,
                        fit: BoxFit.cover));
              }),

          // Page indicators
          Positioned(
              bottom: 2.h,
              left: 0,
              right: 0,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                      widget.imageUrls.length,
                      (index) => Container(
                          margin: EdgeInsets.symmetric(horizontal: 1.w),
                          width: _currentIndex == index ? 4.w : 2.w,
                          height: 1.h,
                          decoration: BoxDecoration(
                              color: _currentIndex == index
                                  ? AppTheme.backgroundWhite
                                  : AppTheme.backgroundWhite
                                      .withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(1.h)))))),

          // Image count indicator
          Positioned(
              top: 2.h,
              right: 4.w,
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(
                      '${_currentIndex + 1} / ${widget.imageUrls.length}',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.backgroundWhite,
                          fontWeight: FontWeight.w500)))),
        ]));
  }
}