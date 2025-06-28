import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _fadeAnimationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _screenFadeAnimation;

  bool _isInitialized = false;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startSplashSequence();
  }

  void _initializeAnimations() {
    // Logo animation controller
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Screen fade animation controller
    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Logo scale animation
    _logoScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));

    // Logo fade animation
    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    // Screen fade animation for transition
    _screenFadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _fadeAnimationController,
      curve: Curves.easeInOut,
    ));

    // Start logo animation
    _logoAnimationController.forward();
  }

  Future<void> _startSplashSequence() async {
    try {
      // Simulate initialization tasks
      await Future.wait([
        _checkAuthenticationStatus(),
        _loadUserPreferences(),
        _fetchEssentialConfig(),
        _prepareCachedData(),
      ]);

      setState(() {
        _isInitialized = true;
      });

      // Wait for minimum splash duration
      await Future.delayed(const Duration(milliseconds: 500));

      // Navigate based on authentication status
      _navigateToNextScreen();
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Failed to initialize app. Please try again.';
      });

      // Show retry option after 5 seconds
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted && _hasError) {
          _showRetryOption();
        }
      });
    }
  }

  Future<void> _checkAuthenticationStatus() async {
    // Simulate authentication check
    await Future.delayed(const Duration(milliseconds: 800));
  }

  Future<void> _loadUserPreferences() async {
    // Simulate loading user preferences
    await Future.delayed(const Duration(milliseconds: 600));
  }

  Future<void> _fetchEssentialConfig() async {
    // Simulate fetching essential config data
    await Future.delayed(const Duration(milliseconds: 700));
  }

  Future<void> _prepareCachedData() async {
    // Simulate preparing cached property listings
    await Future.delayed(const Duration(milliseconds: 900));
  }

  void _navigateToNextScreen() {
    if (!mounted) return;

    // Start fade out animation
    _fadeAnimationController.forward().then((_) {
      if (mounted) {
        // Mock authentication logic - in real app, check actual auth status
        final bool isAuthenticated = false; // Mock value
        final String userRole =
            'tenant'; // Mock value: 'tenant', 'agent', 'landlord'
        final bool isFirstTime = true; // Mock value

        if (isAuthenticated) {
          // Navigate to role-specific dashboard
          switch (userRole) {
            case 'tenant':
              Navigator.pushReplacementNamed(context, '/tenant-dashboard');
              break;
            case 'agent':
              Navigator.pushReplacementNamed(context, '/agent-dashboard');
              break;
            case 'landlord':
              Navigator.pushReplacementNamed(context, '/landlord-dashboard');
              break;
            default:
              Navigator.pushReplacementNamed(context, '/login-screen');
          }
        } else if (isFirstTime) {
          // Navigate to onboarding (for now, go to login)
          Navigator.pushReplacementNamed(context, '/login-screen');
        } else {
          // Navigate to login screen
          Navigator.pushReplacementNamed(context, '/login-screen');
        }
      }
    });
  }

  void _showRetryOption() {
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Connection Error',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          content: Text(
            _errorMessage,
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _retryInitialization();
              },
              child: const Text('Retry'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/login-screen');
              },
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );
  }

  void _retryInitialization() {
    setState(() {
      _hasError = false;
      _isInitialized = false;
      _errorMessage = '';
    });

    // Reset animations
    _logoAnimationController.reset();
    _fadeAnimationController.reset();
    _logoAnimationController.forward();

    // Retry initialization
    _startSplashSequence();
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _fadeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _screenFadeAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _screenFadeAnimation.value,
            child: Container(
              width: 100.w,
              height: 100.h,
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
              ),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Spacer to push content to center
                    const Spacer(flex: 2),

                    // Logo section with animation
                    AnimatedBuilder(
                      animation: _logoAnimationController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _logoScaleAnimation.value,
                          child: Opacity(
                            opacity: _logoFadeAnimation.value,
                            child: _buildLogoSection(),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 8.h),

                    // Loading indicator section
                    _buildLoadingSection(),

                    // Spacer to balance layout
                    const Spacer(flex: 3),

                    // App version info
                    _buildVersionInfo(),

                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLogoSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // App logo container
        Container(
          width: 25.w,
          height: 25.w,
          decoration: BoxDecoration(
            color: AppTheme.backgroundWhite,
            borderRadius: BorderRadius.circular(20),
            boxShadow: AppTheme.elevatedShadow,
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: 'home',
              color: AppTheme.primaryRed,
              size: 12.w,
            ),
          ),
        ),

        SizedBox(height: 3.h),

        // App name
        Text(
          'Ready Rental',
          style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
            color: AppTheme.backgroundWhite,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),

        SizedBox(height: 1.h),

        // App tagline
        Text(
          'Your Property, Our Priority',
          style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
            color: AppTheme.backgroundWhite.withValues(alpha: 0.9),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingSection() {
    if (_hasError) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: 'error_outline',
            color: AppTheme.backgroundWhite,
            size: 6.w,
          ),
          SizedBox(height: 2.h),
          Text(
            'Connection Error',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.backgroundWhite,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Loading indicator
        SizedBox(
          width: 6.w,
          height: 6.w,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(
              AppTheme.backgroundWhite,
            ),
          ),
        ),

        SizedBox(height: 2.h),

        // Loading text
        Text(
          _isInitialized ? 'Ready!' : 'Initializing...',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.backgroundWhite.withValues(alpha: 0.9),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildVersionInfo() {
    return Text(
      'Version 1.0.0',
      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
        color: AppTheme.backgroundWhite.withValues(alpha: 0.7),
        fontSize: 10.sp,
      ),
    );
  }
}
