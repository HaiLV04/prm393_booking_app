import 'package:prm393_booking_app/core/network/api_client.dart';

class StaffOrderRepository {
  StaffOrderRepository({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<List<CategoryData>> getCategories() async {
    final json = await _apiClient.get('/api/categories');
    final data = (json['data'] as List<dynamic>? ?? <dynamic>[])
        .cast<Map<String, dynamic>>();

    return data
        .map(CategoryData.fromJson)
        .where((category) => category.isActive)
        .toList()
      ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
  }

  Future<List<MenuItemData>> getMenuItems({int? categoryId}) async {
    final query = <String, dynamic>{
      'page': 1,
      'pageSize': 100,
      'isAvailable': true,
      'categoryId': categoryId,
    }..removeWhere((key, value) => value == null);

    final json = await _apiClient.get(
      '/api/menu-items',
      query: query,
    );

    final paged = json['data'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final items = (paged['items'] as List<dynamic>? ?? <dynamic>[])
        .cast<Map<String, dynamic>>();
    return items.map(MenuItemData.fromJson).toList();
  }

  Future<List<TableData>> getTables() async {
    final json = await _apiClient.get(
      '/api/tables',
      query: {'page': 1, 'pageSize': 100},
    );
    final paged = json['data'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final items = (paged['items'] as List<dynamic>? ?? <dynamic>[])
        .cast<Map<String, dynamic>>();
    return items.map(TableData.fromJson).toList();
  }

  Future<List<ReservationData>> getReservations({String? status}) async {
    final json = await _apiClient.get(
      '/api/reservations',
      query: {
        'page': 1,
        'pageSize': 100,
        if (status != null && status.isNotEmpty) 'status': status,
      },
    );

    final paged = json['data'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final items = (paged['items'] as List<dynamic>? ?? <dynamic>[])
        .cast<Map<String, dynamic>>();
    return items.map(ReservationData.fromJson).toList();
  }

  Future<OrderData> getOrder(int orderId) async {
    final json = await _apiClient.get('/api/orders/$orderId');
    final data = json['data'] as Map<String, dynamic>? ?? <String, dynamic>{};
    return OrderData.fromJson(data);
  }

  Future<List<OrderItemData>> getOrderItems(int orderId) async {
    final json = await _apiClient.get('/api/orders/$orderId/items');
    final data = (json['data'] as List<dynamic>? ?? <dynamic>[])
        .cast<Map<String, dynamic>>();
    return data.map(OrderItemData.fromJson).toList();
  }

  Future<void> addOrderItem({
    required int orderId,
    required int menuItemId,
    required int quantity,
    String? note,
  }) async {
    await _apiClient.post(
      '/api/orders/$orderId/items',
      body: {
        'menuItemId': menuItemId,
        'quantity': quantity,
        if (note != null && note.isNotEmpty) 'note': note,
      },
    );
  }

  Future<void> checkout({
    required int orderId,
    required String paymentMethod,
    double taxAmount = 0,
    double discountAmount = 0,
    double tipAmount = 0,
  }) async {
    await _apiClient.post(
      '/api/checkout',
      body: {
        'orderId': orderId,
        'paymentMethod': paymentMethod,
        'taxAmount': taxAmount,
        'discountAmount': discountAmount,
        'tipAmount': tipAmount,
      },
    );
  }

  Future<StaffOrderContext?> getActiveContext() async {
    final reservations = await getReservations();

    final eligible = reservations
        .where((reservation) =>
            reservation.orderId != null &&
            _isServingStatus(reservation.status))
        .toList()
      ..sort((a, b) => b.checkInTime.compareTo(a.checkInTime));

    final selected = eligible.isNotEmpty ? eligible.first : null;
    if (selected == null || selected.orderId == null) {
      return null;
    }

    return StaffOrderContext(
      tableId: selected.tableId,
      tableName: selected.tableName,
      reservationId: selected.id,
      orderId: selected.orderId!,
      guestCount: selected.guestCount,
      checkInTime: selected.checkInTime,
      customerName: selected.customerName,
    );
  }

  bool _isServingStatus(String status) {
    final normalized = status.trim().toLowerCase();
    if (normalized.isEmpty) {
      return true;
    }

    const closed = <String>{'cancelled', 'completed', 'checkedout', 'finished'};
    return !closed.contains(normalized);
  }
}

class StaffOrderContext {
  const StaffOrderContext({
    required this.tableId,
    required this.tableName,
    required this.reservationId,
    required this.orderId,
    required this.guestCount,
    required this.checkInTime,
    required this.customerName,
  });

  final int tableId;
  final String tableName;
  final int reservationId;
  final int orderId;
  final int guestCount;
  final DateTime checkInTime;
  final String customerName;
}

class CategoryData {
  const CategoryData({
    required this.id,
    required this.name,
    required this.displayOrder,
    required this.isActive,
  });

  final int id;
  final String name;
  final int displayOrder;
  final bool isActive;

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
      id: json['id'] as int? ?? 0,
      name: (json['name'] ?? '').toString(),
      displayOrder: json['displayOrder'] as int? ?? 0,
      isActive: json['isActive'] as bool? ?? false,
    );
  }
}

class MenuItemData {
  const MenuItemData({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.isAvailable,
  });

  final int id;
  final int categoryId;
  final String categoryName;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final bool isAvailable;

  factory MenuItemData.fromJson(Map<String, dynamic> json) {
    return MenuItemData(
      id: json['id'] as int? ?? 0,
      categoryId: json['categoryId'] as int? ?? 0,
      categoryName: (json['categoryName'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      price: (json['price'] as num?)?.toDouble() ?? 0,
      imageUrl: (json['imageUrl'] ?? '').toString(),
      isAvailable: json['isAvailable'] as bool? ?? false,
    );
  }
}

class ReservationData {
  const ReservationData({
    required this.id,
    required this.tableId,
    required this.tableName,
    required this.staffId,
    required this.staffName,
    required this.customerName,
    required this.customerPhone,
    required this.guestCount,
    required this.checkInTime,
    required this.checkOutTime,
    required this.note,
    required this.status,
    required this.createdAt,
    required this.orderId,
  });

  final int id;
  final int tableId;
  final String tableName;
  final int staffId;
  final String staffName;
  final String customerName;
  final String customerPhone;
  final int guestCount;
  final DateTime checkInTime;
  final DateTime? checkOutTime;
  final String note;
  final String status;
  final DateTime createdAt;
  final int? orderId;

  factory ReservationData.fromJson(Map<String, dynamic> json) {
    return ReservationData(
      id: json['id'] as int? ?? 0,
      tableId: json['tableId'] as int? ?? 0,
      tableName: (json['tableName'] ?? '').toString(),
      staffId: json['staffId'] as int? ?? 0,
      staffName: (json['staffName'] ?? '').toString(),
      customerName: (json['customerName'] ?? '').toString(),
      customerPhone: (json['customerPhone'] ?? '').toString(),
      guestCount: json['guestCount'] as int? ?? 0,
      checkInTime: DateTime.tryParse((json['checkInTime'] ?? '').toString()) ?? DateTime.now(),
      checkOutTime: DateTime.tryParse((json['checkOutTime'] ?? '').toString()),
      note: (json['note'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      createdAt: DateTime.tryParse((json['createdAt'] ?? '').toString()) ?? DateTime.now(),
      orderId: json['orderId'] as int?,
    );
  }
}

class TableData {
  const TableData({
    required this.id,
    required this.areaId,
    required this.areaName,
    required this.name,
    required this.capacity,
    required this.status,
    required this.isActive,
  });

  final int id;
  final int areaId;
  final String areaName;
  final String name;
  final int capacity;
  final String status;
  final bool isActive;

  factory TableData.fromJson(Map<String, dynamic> json) {
    return TableData(
      id: json['id'] as int? ?? 0,
      areaId: json['areaId'] as int? ?? 0,
      areaName: (json['areaName'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      capacity: json['capacity'] as int? ?? 0,
      status: (json['status'] ?? '').toString(),
      isActive: json['isActive'] as bool? ?? false,
    );
  }
}

class OrderData {
  const OrderData({
    required this.id,
    required this.reservationId,
    required this.totalAmount,
    required this.status,
    required this.note,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final int reservationId;
  final double totalAmount;
  final String status;
  final String note;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      id: json['id'] as int? ?? 0,
      reservationId: json['reservationId'] as int? ?? 0,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0,
      status: (json['status'] ?? '').toString(),
      note: (json['note'] ?? '').toString(),
      createdAt: DateTime.tryParse((json['createdAt'] ?? '').toString()) ?? DateTime.now(),
      updatedAt: DateTime.tryParse((json['updatedAt'] ?? '').toString()) ?? DateTime.now(),
    );
  }
}

class OrderItemData {
  const OrderItemData({
    required this.id,
    required this.orderId,
    required this.menuItemId,
    required this.menuItemName,
    required this.quantity,
    required this.unitPrice,
    required this.note,
    required this.itemStatus,
  });

  final int id;
  final int orderId;
  final int menuItemId;
  final String menuItemName;
  final int quantity;
  final double unitPrice;
  final String note;
  final String itemStatus;

  factory OrderItemData.fromJson(Map<String, dynamic> json) {
    return OrderItemData(
      id: json['id'] as int? ?? 0,
      orderId: json['orderId'] as int? ?? 0,
      menuItemId: json['menuItemId'] as int? ?? 0,
      menuItemName: (json['menuItemName'] ?? '').toString(),
      quantity: json['quantity'] as int? ?? 0,
      unitPrice: (json['unitPrice'] as num?)?.toDouble() ?? 0,
      note: (json['note'] ?? '').toString(),
      itemStatus: (json['itemStatus'] ?? '').toString(),
    );
  }
}
