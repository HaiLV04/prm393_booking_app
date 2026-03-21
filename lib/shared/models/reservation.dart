class Reservation {
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
  final String? note;
  final String status;
  final DateTime createdAt;
  final int? orderId;

  Reservation({
    required this.id,
    required this.tableId,
    required this.tableName,
    required this.staffId,
    required this.staffName,
    required this.customerName,
    required this.customerPhone,
    required this.guestCount,
    required this.checkInTime,
    this.checkOutTime,
    this.note,
    required this.status,
    required this.createdAt,
    this.orderId,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'],
      tableId: json['tableId'],
      tableName: json['tableName'] ?? "",
      staffId: json['staffId'],
      staffName: json['staffName'] ?? "",
      customerName: json['customerName'] ?? "",
      customerPhone: json['customerPhone'] ?? "",
      guestCount: json['guestCount'] ?? 0,
      checkInTime: DateTime.parse(json['checkInTime']),
      checkOutTime: json['checkOutTime'] != null
          ? DateTime.parse(json['checkOutTime'])
          : null,
      note: json['note'],
      status: json['status'] ?? "",
      createdAt: DateTime.parse(json['createdAt']),
      orderId: json['orderId'],
    );
  }
}