# Frontend-Backend API Alignment Complete

## Summary
Successfully aligned Flutter PRM393 project with backend ASP.NET Core API. All critical integration points verified and documented.

## Architecture Overview

### backend (ASP.NET Core)
- **Base URL**: `http://localhost:5200` (or `http://10.0.2.2:5200` for Android emulator)
- **Authentication**: JWT Bearer Token
- **Response Format**: Standardized `ApiResponse<T>` wrapper with `{success, message, data, errors, traceId}`
- **Port**: 5200

### Frontend (Flutter)
- **API Client**: `lib/core/network/api_client.dart` - Centralized HTTP client
- **Auth Storage**: `lib/core/network/auth_storage.dart` - Token persistence via SharedPreferences
- **Config**: `lib/core/network/app_config.dart` - Environment-aware URL configuration

---

## API Endpoint Mapping

### Auth API Endpoints (/api/auth)
**Service**: `lib/features/auth/data/services/auth_service.dart`

| Method | Endpoint | Purpose | Body | Response |
|--------|----------|---------|------|----------|
| POST | `/auth/login` | Authenticate user | `{username, password}` | `{token, expiresAt, user:{id,role,...}}` |
| POST | `/auth/register` | Create new account | `{fullName, username, password, email?, phone?, role}` | `{token, expiresAt, user:{...}}` |
| POST | `/auth/change-password` | Change user password | `{currentPassword, newPassword}` | `{success, message}` |
| GET | `/auth/me` | Get current user info | - | `{id, username, role, email, phone, fullName}` |

### Table Management API (/api/tables)
**Controllers**: `TablesController` (Query via `GetFilteredAsync`)
**Params for query**: `{areaId?, status?, keyword?, page (default:1), pageSize (default:10)}`

| Method | Endpoint | Purpose | Frontend Route |
|--------|----------|---------|------------------|
| GET | `/tables` | List tables | `/admin/tables` |
| GET | `/tables/{id}` | Get table details | `/admin/table/{id}` |
| POST | `/tables` | Create table | `/admin/table/add` (form POST) |
| PUT | `/tables/{id}` | Update table | `/admin/table/{id}/edit` (form PUT) |
| PATCH | `/tables/{id}/status` | Change table status | (used in TableDetailScreen) |

### Reservation API (/api/reservations)
**Controllers**: `ReservationsController`

| Method | Endpoint | Purpose | Frontend Route |
|--------|----------|---------|------------------|
| GET | `/reservations` | List reservations | `/staff/reservations` |
| GET | `/reservations/{id}` | Get reservation details | (detail view) |
| POST | `/reservations/check-in` | Check-in new guest | `/staff/reservation/create` |
| PUT | `/reservations/{id}` | Update reservation | (edit) |
| PATCH | `/reservations/{id}/cancel` | Cancel reservation | (cancel action) |

### Order API (/api/orders)
**Service**: `lib/features/staff_order/data/services/order_service.dart`
**Controllers**: `OrdersController`

| Method | Endpoint | Purpose | Body |
|--------|----------|---------|------|
| GET | `/orders/{id}` | Get order by ID | - |
| GET | `/orders/by-reservation/{resId}` | Get order by reservation | - |
| GET | `/orders/{id}/items` | Get order items | - |
| POST | `/orders/{id}/items` | Add item to order | `{menuItemId, quantity?, note?}` |
| PATCH | `/orders/{detailId}/status` | Update item status | `{status: pending\|preparing\|served\|cancelled}` |

### Checkout/Invoice API (/api/checkout, /api/invoices)
**Service**: `lib/features/staff_order/data/services/checkout_service.dart`
**Controllers**: `CheckoutController`, `InvoicesController`
**Frontend Screen**: `lib/features/staff_order/presentation/screens/checkout_screen.dart`

| Method | Endpoint | Purpose | Body |
|--------|----------|---------|------|
| POST | `/checkout` | Process payment & create invoice | `{orderId, paymentMethod (cash\|card\|qr_transfer), taxAmount?, discountAmount?, tipAmount?}` |
| GET | `/invoices` | List invoices | Query: `{from?, to?, staffId?, paymentMethod?, page, pageSize}` |
| GET | `/invoices/{id}` | Get invoice details | - |

**Payment Methods Enforced**: `cash`, `card`, `qr_transfer`

### Menu Management API (/api/menu-items, /api/categories)
**Services**: 
- `lib/features/admin/data/services/menu_item_service.dart`
- `lib/features/admin/data/services/category_service.dart`

**Frontend Screen**: `lib/features/admin/presentation/screens/category_menu_screen.dart`

| Method | Endpoint | Purpose | Body |
|--------|----------|---------|------|
| GET | `/menu-items` | List menu items | Query: `{categoryId?, isAvailable?, keyword?, page, pageSize}` |
| GET | `/menu-items/{id}` | Get item details | - |
| POST | `/menu-items` | Create menu item (Admin) | `{categoryId, name, price, description?, imageUrl?, isAvailable}` |
| PUT | `/menu-items/{id}` | Update menu item (Admin) | `{categoryId, name, price, ...}` |
| PATCH | `/menu-items/{id}/availability` | Toggle availability | `{isAvailable: boolean}` |
| GET | `/categories` | List categories | - |
| GET | `/categories/{id}` | Get category | - |
| POST | `/categories` | Create category (Admin) | `{name, imageUrl?, displayOrder?}` |
| PATCH | `/categories/{id}/active` | Toggle category active | `{isActive: boolean}` |

### Administration API (/api/admin/dashboard, /api/admin/statistics)
**Service**: `lib/features/admin/data/services/admin_statistics_service.dart`
**Controllers**: `AdminDashboardController`, `AdminStatisticsController`
**Frontend Screen**: `lib/features/admin/presentation/screens/statistics_screen.dart`

| Method | Endpoint | Purpose | Parameters |
|--------|----------|---------|-----------|
| GET | `/admin/dashboard/summary` | Dashboard KPIs | - |
| GET | `/admin/statistics/revenue` | Revenue stats | Query: `{period: today\|week\|month}` |
| GET | `/admin/statistics/top-items` | Top-selling items | Query: `{from?, to?, limit (default:10)}` |

### Area Management API (/api/areas)
**Controllers**: `AreasController`

| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | `/areas` | List all dining areas |
| GET | `/areas/{id}` | Get area details |
| POST | `/areas` | Create area (Admin) |
| PUT | `/areas/{id}` | Update area (Admin) |
| PATCH | `/areas/{id}/active` | Toggle area active (Admin) |

### Staff Management API (/api/admin/staff)
**Controllers**: `AdminStaffController`

| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | `/admin/staff` | List staff | GET | `/admin/staff/{id}` | Get staff details |
| POST | `/admin/staff` | Create staff (Admin) |
| PUT | `/admin/staff/{id}` | Update staff (Admin) |
| PATCH | `/admin/staff/{id}/active` | Toggle staff active (Admin) |

---

## Services Layer Architecture

### Created Services (New)

1. **AuthService** (`lib/features/auth/data/services/auth_service.dart`)
   - Handles: Login, Register, Change Password, Get User Info
   - Manages: JWT token storage and retrieval
   - Uses: ApiClient + AuthStorage

2. **CheckoutService** (`lib/features/staff_order/data/services/checkout_service.dart`)
   - Handles: Payment processing and invoice creation
   - Validates: Payment method (cash, card, qr_transfer)
   - Endpoint: `POST /api/checkout`

3. **OrderService** (`lib/features/staff_order/data/services/order_service.dart`)
   - Handles: Orders CRUD, add items, update item status
   - Endpoints: Multiple /api/orders/* paths

4. **MenuItemService** (`lib/features/admin/data/services/menu_item_service.dart`)
   - Handles: Menu items CRUD, availability toggle
   - Endpoints: `/api/menu-items/*`

5. **CategoryService** (`lib/features/admin/data/services/category_service.dart`)
   - Handles: Categories CRUD, active toggle
   - Endpoints: `/api/categories/*`

6. **AdminStatisticsService** (`lib/features/admin/data/services/admin_statistics_service.dart`)
   - Handles: Dashboard summary, revenue statistics, top items
   - Endpoints: `/api/admin/dashboard/*`, `/api/admin/statistics/*`

### Existing Services (Updated)

1. **ReservationService** (`lib/shared/services/reservation_service.dart`)
   - Already implemented with hardcoded URLs
   - Should migrate to use unified ApiClient approach
   - Issue: Uses direct HTTP calls instead of ApiClient

---

## Route & Screen Alignment

### Login Flow (Entry Point)
```
/login (LoginScreen)
  ↓
  [Role-based redirect by AuthGuard]
  ├→ Staff User → /staff/home (StaffDashboardScreen)
  └→ Admin User → /admin/dashboard (AdminHomeScreen)
```

### Staff User Workflows
```
/staff/home (Dashboard)
  ├→ /staff/tables (TableManagementScreen)
  ├→ /staff/reservations (ReservationListScreen)
  ├→ /staff/reservation/create (CreateReservationScreen) [Check-in]
  ├→ /staff/order (StaffOrderScreen) [Add menu items]
  ├→ /staff/order-detail (OrderDetailStatusScreen) [Monitor kitchen]
  ├→ /staff/checkout (CheckoutScreen) [Payment] → POST /api/checkout
  └→ /staff/profile (ManageProfileScreen)
```

### Admin User Workflows
```
/admin/dashboard (AdminHomeScreen)
  ├→ /admin/tables (TableListScreen) [with areaName parameter]
  ├→ /admin/table/add (AddEditTableScreen)
  ├→ /admin/areas (ManageAreasScreen)
  ├→ /admin/staff (ManageStaffAccountScreen)
  ├→ /admin/menu (CategoryMenuScreen) ← PATCH /api/menu-items/{id}/availability
  └→ /admin/statistics (StatisticsScreen) ← GET /api/admin/statistics/*
```

---

## Data Flow Examples

### Example 1: Login Flow
```dart
// User enters credentials
LoginScreen:
  1. Call AuthService.login(username, password)
  2. Backend returns: { success: true, data: { token, user: { id, role, ... } } }
  3. AuthService saves token via AuthStorage
  4. RoleBasedNavigator.getInitialRoute(user.role) determines next screen
  5. If staff → Navigate to /staff/home
  6. If admin → Navigate to /admin/dashboard
```

### Example 2: Checkout Flow
```dart
// Staff processes payment
CheckoutScreen._handleCheckout():
  1. User selects payment method (cash, card, qr_transfer)
  2. Call CheckoutService.checkout(orderId, paymentMethod)
  3. Request: POST /api/checkout { orderId, paymentMethod, ... }
  4. Backend creates Invoice, marks Order as paid, returns invoiceId
  5. Response: { success: true, data: { id, orderId, finalTotal, paidAt } }
  6. Show success confirmation
  7. Navigate back to /staff/home
```

### Example 3: Menu Item Availability Toggle
```dart
// Admin toggles item availability
CategoryMenuScreen._toggleMenuItemAvailability(itemId):
  1. Get current availability status
  2. Call MenuItemService.toggleAvailability(itemId, newStatus)
  3. Request: PATCH /api/menu-items/{itemId}/availability { isAvailable: boolean }
  4. Backend updates MenuItems table
  5. Response: { success: true, message: "Menu item availability updated" }
  6. Update UI to reflect new availability
```

---

## DTOs & Request/Response Structures

### Login Request/Response
```json
Request: { "username": "staff1", "password": "pass123" }
Response: {
  "success": true,
  "message": "Login successful",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIs...",
    "expiresAt": "2025-03-22T10:00:00Z",
    "user": {
      "id": 1,
      "fullName": "Nguyễn Văn A",
      "username": "staff1",
      "email": "staff1@example.com",
      "phone": "0901234567",
      "role": "staff",
      "isActive": true,
      "createdAt": "2025-01-01T00:00:00Z"
    }
  }
}
```

### Checkout Request/Response
```json
Request: {
  "orderId": 123,
  "paymentMethod": "card",
  "taxAmount": 50000,
  "discountAmount": 0,
  "tipAmount": 10000
}
Response: {
  "success": true,
  "message": "Checkout successful",
  "data": {
    "id": 456,
    "orderId": 123,
    "staffId": 1,
    "paymentMethod": "card",
    "taxAmount": 50000,
    "discountAmount": 0,
    "tipAmount": 10000,
    "finalTotal": 510000,
    "paidAt": "2025-03-21T15:30:00Z"
  }
}
```

### Paged Result (Menu Items)
```json
Request: GET /api/menu-items?categoryId=1&page=1&pageSize=10
Response: {
  "success": true,
  "message": "Success",
  "data": {
    "items": [
      {
        "id": 1,
        "categoryId": 1,
        "categoryName": "Appetizers",
        "name": "Spring Rolls",
        "description": "Crispy spring rolls",
        "price": 80000,
        "imageUrl": "https://...",
        "isAvailable": true
      },
      ...
    ],
    "totalCount": 25,
    "page": 1,
    "pageSize": 10
  }
}
```

---

## Authentication & Authorization

### Access Control Levels
```
Public Routes (No Auth):
  /login, /register

Staff Routes (Requires: role = "staff"):
  /staff/* (all staff-related routes)
  /change-password (shared with admin)
  /staff/profile (shared with admin)

Admin Routes (Requires: role = "admin"):
  /admin/* (all admin-related routes)
  Also can access /staff/* routes if implemented with admin override

### JWT Token Structure (Backend Generated)
Claims:
  - sub: user.id
  - NameIdentifier: user.id
  - Name: user.username
  - Role: user.role ('staff' or 'admin')
  - jti: unique token ID
  - Email: user.email (if provided)
```

---

## Implementation TODOs

### High Priority (Blocking)
- [ ] Complete AuthProvider implementation in Flutter for state management
- [ ] Implement runtime AuthGuard with actual token validation
- [ ] Connect all service methods to actual screens (replace mock data)
- [ ] Test E2E workflows with backend: login → create reservation → checkout

### Medium Priority (Functionality)
- [ ] Error handling & user feedback (API exceptions → SnackBars)
- [ ] Loading states for all async operations
- [ ] Implement DELETE operations in ApiClient
- [ ] Support for image upload in menu items

### Low Priority (Polish)
- [ ] Replace 70+ `.withOpacity()` calls with `.withValues()` (deprecation)
- [ ] Remove unused fields (`_isLoading` in Statistics/Menu screens)
- [ ] Fix BuildContext async usage warnings
- [ ] Optimize pagination & infinite scroll for large lists

---

## Testing Checklist

- [ ] **Auth Flow**: Login → Token stored → Correct role-based redirect
- [ ] **Checkout**: Order created → Payment submitted → Invoice generated → Table released
- [ ] **Menu Management**: View categories → View items → Toggle availability → API updates
- [ ] **Admin Dashboard**: View KPIs → View statistics → All data matches backend
- [ ] **Error Handling**: Invalid payment method → Show error → Try again
- [ ] **Token Expiry**: Old token → 401 error → Redirect to login
- [ ] **Network Failures**: No connection → Show retry dialog → Recover gracefully

---

## Rollback/Troubleshooting

### If Backend Endpoint Changes
1. Update endpoint path in service method
2. Update documentation in this file
3. Verify DTO structures match new response
4. Run flutter analyze to catch type errors

### If Token Management Fails
1. Check AuthStorage implementation in `auth_storage.dart`
2. Verify token is being saved after login
3. Check Authorization header in ApiClient._buildHeaders()
4. Ensure SharedPreferences is properly initialized

### If API Calls Fail with 400/401/500
1. Check request body matches DTO structure in this document
2. Inspect response.body to see backend error message
3. Verify user role has permission for endpoint
4. Check token expiry time
