enum UserRole { admin, customer, staff }

extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.admin:
        return 'Admin';
      case UserRole.customer:
        return 'Customer';
      case UserRole.staff:
        return 'Staff';
    }
  }
}
