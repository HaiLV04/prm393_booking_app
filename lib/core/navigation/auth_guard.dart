import 'package:flutter/material.dart';
import 'package:prm393_booking_app/core/models/user_role.dart';

/// AuthGuard: Protects routes based on authentication status and user role
/// 
/// Usage:
/// ```dart
/// '/staff/dashboard': (context) => AuthGuard(
///   requiredRole: UserRole.staff,
///   child: const StaffDashboardScreen(),
/// ),
/// ```
class AuthGuard extends StatelessWidget {
  final UserRole? requiredRole;
  final Widget child;

  const AuthGuard({
    super.key,
    this.requiredRole,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: Get current user from auth service/provider
    // final currentUser = context.read<AuthProvider>().currentUser;
    
    // For now, return the child directly
    // In production, implement authentication check:
    // 1. If user is null → redirect to /login
    // 2. If user doesn't have required role → redirect to /unauthorized
    // 3. Otherwise → show the child
    
    return child;
  }
}

/// Helper function to safely navigate based on user role
class RoleBasedNavigator {
  /// After login, navigate user to appropriate home screen based on role
  static String getInitialRoute(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return '/admin/dashboard';
      case UserRole.staff:
        return '/staff/home';
    }
  }

  /// Check if a route is accessible for a given role
  static bool canAccessRoute(String routeName, UserRole role) {
    // Protected admin routes
    const adminRoutes = {
      '/admin',
      '/admin/dashboard',
      '/admin/tables',
      '/admin/table/add',
      '/admin/areas',
      '/admin/staff',
      '/admin/menu',
      '/admin/statistics',
    };

    // Protected staff routes (staff can access these)
    const staffRoutes = {
      '/staff/home',
      '/staff/dashboard',
      '/staff/tables',
      '/staff/reservations',
      '/reservations',
      '/staff/reservation/create',
      '/create_reservations',
      '/staff/order',
      '/staff/order-detail',
      '/staff/checkout',
      '/staff/profile',
    };

    // Public routes (accessible to all authenticated users)
    const publicRoutes = {
      '/change-password',
      '/staff/profile', // Both staff and admin can access
      '/not-found',
    };

    if (publicRoutes.contains(routeName)) return true;

    if (role == UserRole.admin) {
      // Admin can access all routes except public
      return !publicRoutes.contains(routeName) || adminRoutes.contains(routeName);
    }

    if (role == UserRole.staff) {
      // Staff can only access staff routes
      return staffRoutes.contains(routeName);
    }

    return false;
  }

  /// Get the appropriate bottom navigation route for a role
  static String getBottomNavRoute(UserRole role, int index) {
    switch (role) {
      case UserRole.admin:
        switch (index) {
          case 0:
            return '/admin/dashboard';
          case 1:
            return '/admin/tables';
          case 2:
            return '/admin/menu';
          case 3:
            return '/admin/statistics';
          default:
            return '/admin/dashboard';
        }
      case UserRole.staff:
        switch (index) {
          case 0:
            return '/staff/home';
          case 1:
            return '/staff/tables';
          case 2:
            return '/staff/reservations';
          case 3:
            return '/staff/profile';
          default:
            return '/staff/home';
        }
    }
  }
}
