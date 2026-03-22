# PRM393 Routing & Navigation Guide

## 📋 Navigation Structure (Updated)

### Entry Point
```
/login  ← All users start here
```

### Authentication Routes
```
/login                  → Login screen
/register              → Register new staff account  
/change-password       → Change password (post-login)
```

### Staff Routes (Core Workflow)
```
/staff/home              → Home/Dashboard (table overview)
/staff/dashboard         → Alias for /staff/home

/staff/tables            → Table list/map to select table for check-in

/staff/reservations      → View active reservations
/staff/reservation/create → Create new reservation or check-in

/staff/order             → Take order (add menu items)
/staff/order-detail      → View order status & item details

/staff/checkout          → Payment processing & invoice generation

/staff/profile           → Manage personal account
```

### Admin Routes (Management & Monitoring)  
```
/admin                   → Redirect to /admin/dashboard
/admin/dashboard         → KPIs, revenue, busy status

/admin/tables            → Table CRUD management
/admin/table/add         → Add new table

/admin/areas             → Dining area management

/admin/staff             → Staff account management

/admin/menu              → Menu items & categories management

/admin/statistics        → Business metrics & reports
```

### Common Routes
```
/not-found               → 404 page
```

---

## 🔐 Role-Based Access Control

### Staff Permissions
- ✅ Can access: All `/staff/*` routes + `/change-password` + `/staff/profile`
- ❌ Cannot access: `/admin/*` routes

### Admin Permissions  
- ✅ Can access: All routes (admin + staff)
- ✅ Can perform: Everything staff can + all management operations

### Authentication Flow
1. **Unauthenticated** → Show `/login`
2. **Login Success** → Route to appropriate dashboard based on role:
   - Staff role → Navigate to `/staff/home`
   - Admin role → Navigate to `/admin/dashboard`
3. **Session Expiry** → Redirect to `/login`

---

## 🔄 Core Business Workflow (Staff)

### 1. Beginning of Service
```
/staff/home  
  └─ Overview of tables and busy status

/staff/tables  
  └─ Select a table

/staff/reservation/create  
  └─ Check-in guest → Creates reservation + order (1:1 locked)
```

### 2. During Service  
```
/staff/order  
  └─ Add menu items to current order (multiple times allowed)

/staff/order-detail  
  └─ Track modification status of each item
```

### 3. End of Service
```
/staff/checkout  
  └─ Select payment method (cash, card, qr_transfer)
  └─ Process payment → Creates invoice → Closes order & reservation
  └─ Table returns to available
```

### 4. Profile Management
```
/staff/profile  
└─ View/edit personal info, change password, notifications
```

---

## 📊 Admin Management Workflow

### Table & Area Management
```
/admin/tables → Add/Edit/Delete tables
/admin/areas → Manage dining areas
```

### Menu Management  
```
/admin/menu → Add/Edit/Delete menu items → Toggle availability (còn/hết)
```

### Staff Management
```
/admin/staff → Add/Edit/Toggle active staff accounts
```

### Business Intelligence
```
/admin/statistics → View KPIs, revenue, top items, occupancy, peak hours
```

---

## 🛡️ Route Protection Implementation

### Current Status: TODO

The app currently lacks runtime authentication checks. To fully implement:

1. **Create AuthProvider** (using Provider, Riverpod, or BLoC)
   - Store: `currentUser`, `isAuthenticated`, `userRole`

2. **Wrap Routes with AuthGuard**
   ```dart
   routes: {
     '/staff/home': (context) => AuthGuard(
       requiredRole: UserRole.staff,
       child: const StaffDashboardScreen(),
     ),
   }
   ```

3. **Implement onGenerateRoute** for dynamic checks:
   ```dart
   onGenerateRoute: (settings) {
     final user = authProvider.currentUser;
     if (user == null) return LoginRoute();
     
     if (!RoleBasedNavigator.canAccessRoute(
       settings.name!, 
       user.role
     )) {
       return UnauthorizedRoute();
     }
     // Continue with normal route
   }
   ```

---

## 🔗 Navigation Examples

### After Login
```dart
// In LoginScreen after successful auth
Navigator.of(context).pushNamedAndRemoveUntil(
  RoleBasedNavigator.getInitialRoute(user.role),
  (route) => false,
);
```

### Staff Workflow Navigation
```dart
// In StaffDashboardScreen
Navigator.pushNamed(context, '/staff/tables');

// In TableManagementScreen (after selecting table)
Navigator.pushNamed(
  context, 
  '/staff/reservation/create',
  arguments: {'tableId': selectedTableId},
);

// In CheckoutScreen (after payment success)
Navigator.pushNamedAndRemoveUntil(
  context,
  '/staff/home',
  (route) => false,
);
```

### Access a Protected Admin Route
```dart
// In AdminHomeScreen
Navigator.pushNamed(context, '/admin/statistics');
```

---

## 📝 Notes

1. **One Reservation = One Order** (Business Rule)
   - Check-in creates both reservation + order in same transaction
   - Adding items goes to same order, never creates new order
   - Checkout closes both reservation & order together

2. **Payment Methods** (Accepted)
   - Cash (`cash`)
   - Bank Card (`card`)
   - QR Transfer (`qr_transfer`)

3. **Menu Item Status**
   - Available: `true` (còn)
   - Out of Stock: `false` (hết)
   - Cannot add hết items to order

4. **Route Aliases for Backward Compatibility**
   - `/reservations` → `/staff/reservations`
   - `/create_reservations` → `/staff/reservation/create`
   - `/staff/dashboard` → `/staff/home`
   - `/admin` → `/admin/dashboard`

5. **Dynamic Route Parameters**
   - For routes with IDs (e.g., edit table), use `onGenerateRoute`
   - Example: `/admin/table/123` → Use named arguments or route builder

---

## 🔮 Next Steps

1. ✅ Define routing structure (DONE)
2. ✅ Create missing screens (CheckoutScreen, CategoryMenuScreen, StatisticsScreen)
3. ⏳ Implement AuthProvider/state management
4. ⏳ Add runtime route guards
5. ⏳ Create onGenerateRoute for dynamic parameters
6. ⏳ Update login flow to redirect based on role
7. ⏳ Handle session expiry & token refresh
8. ⏳ Create Postman collection to test full flow

---

**Version:** 1.0  
**Last Updated:** 2026-03-21  
**Maintained By:** Tech Lead / Solution Architect
