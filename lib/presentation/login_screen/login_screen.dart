import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _leaseIdController = TextEditingController();

  late TabController _tabController;
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _isLeaseIdLogin = false;
  String _selectedRole = 'Tenant';
  String? _emailError;
  String? _passwordError;
  String? _leaseIdError;

  // Mock credentials for different user types
  final Map<String, Map<String, String>> _mockCredentials = {
    'Tenant': {
      'email': 'tenant@readyrental.com',
      'password': 'tenant123',
    },
    'Agent': {
      'email': 'agent@readyrental.com',
      'password': 'agent123',
    },
    'Landlord': {
      'email': 'landlord@readyrental.com',
      'password': 'landlord123',
      'leaseId': 'LEASE001',
    },
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _leaseIdController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    setState(() {
      _selectedRole = ['Tenant', 'Agent', 'Landlord'][_tabController.index];
      _isLeaseIdLogin = _selectedRole == 'Landlord';
      _clearErrors();
    });
  }

  void _clearErrors() {
    setState(() {
      _emailError = null;
      _passwordError = null;
      _leaseIdError = null;
    });
  }

  bool _validateInputs() {
    bool isValid = true;
    _clearErrors();

    if (_isLeaseIdLogin) {
      if (_leaseIdController.text.isEmpty) {
        setState(() {
          _leaseIdError = 'Lease ID is required';
        });
        isValid = false;
      }
    } else {
      if (_emailController.text.isEmpty) {
        setState(() {
          _emailError = 'Email is required';
        });
        isValid = false;
      } else if (!_isValidEmail(_emailController.text)) {
        setState(() {
          _emailError = 'Please enter a valid email';
        });
        isValid = false;
      }
    }

    if (_passwordController.text.isEmpty) {
      setState(() {
        _passwordError = 'Password is required';
      });
      isValid = false;
    } else if (_passwordController.text.length < 6) {
      setState(() {
        _passwordError = 'Password must be at least 6 characters';
      });
      isValid = false;
    }

    return isValid;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<void> _handleLogin() async {
    if (!_validateInputs()) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Check credentials
    bool isValidCredentials = false;
    final mockCreds = _mockCredentials[_selectedRole]!;

    if (_isLeaseIdLogin) {
      isValidCredentials = _leaseIdController.text == mockCreds['leaseId'] &&
          _passwordController.text == mockCreds['password'];
    } else {
      isValidCredentials = _emailController.text == mockCreds['email'] &&
          _passwordController.text == mockCreds['password'];
    }

    setState(() {
      _isLoading = false;
    });

    if (isValidCredentials) {
      // Haptic feedback for success
      HapticFeedback.lightImpact();

      // Navigate to appropriate dashboard
      String route;
      switch (_selectedRole) {
        case 'Tenant':
          route = '/tenant-dashboard';
          break;
        case 'Agent':
          route = '/agent-dashboard';
          break;
        case 'Landlord':
          route = '/landlord-dashboard';
          break;
        default:
          route = '/tenant-dashboard';
      }

      Navigator.pushReplacementNamed(context, route);
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Invalid credentials. Please check your ${_isLeaseIdLogin ? 'Lease ID' : 'email'} and password.',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.backgroundWhite,
            ),
          ),
          backgroundColor: AppTheme.primaryRed,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(4.w),
        ),
      );
    }
  }

  void _handleForgotPassword() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Forgot Password',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          'Password reset functionality will be implemented in the next version.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    SizedBox(height: 8.h),
                    _buildLogo(),
                    SizedBox(height: 6.h),
                    _buildRoleSelector(),
                    SizedBox(height: 4.h),
                    _buildLoginForm(),
                    const Spacer(),
                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 30.w,
      height: 30.w,
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(4.w),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Center(
        child: Text(
          'RR',
          style: AppTheme.lightTheme.textTheme.headlineLarge?.copyWith(
            color: AppTheme.backgroundWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildRoleSelector() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceGray,
        borderRadius: BorderRadius.circular(3.w),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          gradient: AppTheme.primaryGradient,
          borderRadius: BorderRadius.circular(3.w),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: AppTheme.backgroundWhite,
        unselectedLabelColor: AppTheme.textSecondary,
        labelStyle: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTheme.lightTheme.textTheme.labelLarge,
        tabs: const [
          Tab(text: 'Tenant'),
          Tab(text: 'Agent'),
          Tab(text: 'Landlord'),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _isLeaseIdLogin ? _buildLeaseIdField() : _buildEmailField(),
          SizedBox(height: 4.h),
          _buildPasswordField(),
          SizedBox(height: 2.h),
          _buildForgotPasswordLink(),
          SizedBox(height: 4.h),
          _buildLoginButton(),
          if (_selectedRole == 'Landlord') ...[
            SizedBox(height: 3.h),
            _buildLeaseIdToggle(),
          ],
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: 'Email Address',
            hintText: 'Enter your email',
            prefixIcon: CustomIconWidget(
              iconName: 'email',
              color: AppTheme.textSecondary,
              size: 5.w,
            ),
            errorText: null,
          ),
          onChanged: (value) => _clearErrors(),
        ),
        if (_emailError != null) ...[
          SizedBox(height: 1.h),
          Text(
            _emailError!,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.primaryRed,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildLeaseIdField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _leaseIdController,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: 'Lease ID',
            hintText: 'Enter your lease ID',
            prefixIcon: CustomIconWidget(
              iconName: 'badge',
              color: AppTheme.textSecondary,
              size: 5.w,
            ),
            errorText: null,
          ),
          onChanged: (value) => _clearErrors(),
        ),
        if (_leaseIdError != null) ...[
          SizedBox(height: 1.h),
          Text(
            _leaseIdError!,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.primaryRed,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _passwordController,
          obscureText: !_isPasswordVisible,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            labelText: 'Password',
            hintText: 'Enter your password',
            prefixIcon: CustomIconWidget(
              iconName: 'lock',
              color: AppTheme.textSecondary,
              size: 5.w,
            ),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
              child: CustomIconWidget(
                iconName: _isPasswordVisible ? 'visibility_off' : 'visibility',
                color: AppTheme.textSecondary,
                size: 5.w,
              ),
            ),
            errorText: null,
          ),
          onChanged: (value) => _clearErrors(),
          onFieldSubmitted: (value) => _handleLogin(),
        ),
        if (_passwordError != null) ...[
          SizedBox(height: 1.h),
          Text(
            _passwordError!,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.primaryRed,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildForgotPasswordLink() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: _handleForgotPassword,
        child: Text(
          'Forgot Password?',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.primaryRed,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Container(
      height: 7.h,
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(3.w),
        boxShadow: AppTheme.cardShadow,
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3.w),
          ),
        ),
        child: _isLoading
            ? SizedBox(
                width: 6.w,
                height: 6.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.backgroundWhite,
                  ),
                ),
              )
            : Text(
                'Login',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.backgroundWhite,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _buildLeaseIdToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _isLeaseIdLogin ? 'Use Email Login?' : 'Use Lease ID Login?',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _isLeaseIdLogin = !_isLeaseIdLogin;
              _clearErrors();
              _emailController.clear();
              _leaseIdController.clear();
              _passwordController.clear();
            });
          },
          child: Text(
            _isLeaseIdLogin ? 'Switch to Email' : 'Switch to Lease ID',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.primaryRed,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
