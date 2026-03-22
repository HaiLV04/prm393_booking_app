class AdminNotification {
  const AdminNotification({
    required this.id,
    required this.content,
    required this.isRead,
    required this.createdAt,
  });

  final int id;
  final String content;
  final bool isRead;
  final DateTime createdAt;

  factory AdminNotification.fromJson(Map<String, dynamic> json) {
    final id = (json['id'] ?? json['Id'] ?? 0) as num;
    final content =
        (json['content'] ?? json['Content'] ?? 'Thông báo mới').toString();
    final isRead = (json['isRead'] ?? json['IsRead'] ?? false) == true;

    final createdRaw = json['createdAt'] ?? json['CreatedAt'];
    final createdAt = DateTime.tryParse(createdRaw?.toString() ?? '') ??
        DateTime.now();

    return AdminNotification(
      id: id.toInt(),
      content: content,
      isRead: isRead,
      createdAt: createdAt,
    );
  }
}
