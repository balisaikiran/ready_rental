import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/tenant_dashboard/tenant_dashboard.dart';
import '../presentation/agent_dashboard/agent_dashboard.dart';
import '../presentation/landlord_dashboard/landlord_dashboard.dart';
import '../presentation/property_search/property_search.dart';
import '../presentation/property_detail_screen/property_detail_screen.dart';
import '../presentation/my_tenants_screen/my_tenants_screen.dart';
import '../presentation/documents_manager_screen/documents_manager_screen.dart';
import '../presentation/user_profile_settings_screen/user_profile_settings_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String splashScreen = '/splash-screen';
  static const String loginScreen = '/login-screen';
  static const String tenantDashboard = '/tenant-dashboard';
  static const String agentDashboard = '/agent-dashboard';
  static const String landlordDashboard = '/landlord-dashboard';
  static const String propertySearch = '/property-search';
  static const String propertyDetailScreen = '/property-detail-screen';
  static const String myTenantsScreen = '/my-tenants-screen';
  static const String documentsManagerScreen = '/documents-manager-screen';
  static const String userProfileSettingsScreen =
      '/user-profile-settings-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splashScreen: (context) => const SplashScreen(),
    loginScreen: (context) => const LoginScreen(),
    tenantDashboard: (context) => const TenantDashboard(),
    agentDashboard: (context) => const AgentDashboard(),
    landlordDashboard: (context) => const LandlordDashboard(),
    propertySearch: (context) => const PropertySearch(),
    propertyDetailScreen: (context) => const PropertyDetailScreen(),
    myTenantsScreen: (context) => const MyTenantsScreen(),
    documentsManagerScreen: (context) => const DocumentsManagerScreen(),
    userProfileSettingsScreen: (context) => const UserProfileSettingsScreen(),
    // TODO: Add your other routes here
  };
}
