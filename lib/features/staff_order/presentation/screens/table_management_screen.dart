import 'package:flutter/material.dart';
import 'package:prm393_booking_app/features/staff_order/data/staff_order_repository.dart';
import 'package:prm393_booking_app/features/staff_order/presentation/staff_design_system.dart';
import 'package:prm393_booking_app/features/staff_order/presentation/widgets/staff_widgets.dart';

class TableManagementScreen extends StatefulWidget {
  const TableManagementScreen({super.key});

  @override
  State<TableManagementScreen> createState() => _TableManagementScreenState();
}

class _TableManagementScreenState extends State<TableManagementScreen> {
  final StaffOrderRepository _repository = StaffOrderRepository();
  late Future<List<TableData>> _tablesFuture;
  String _filterStatus = 'all'; // all, occupied, available, reserved, unavailable

  @override
  void initState() {
    super.initState();
    _tablesFuture = _repository.getTables();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: SafeArea(
        child: FutureBuilder<List<TableData>>(
          future: _tablesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return EmptyState(
                icon: Icons.error_outline,
                title: 'Không tải được dữ liệu',
                description: snapshot.error.toString(),
                actionLabel: 'Thử lại',
                onAction: () => setState(() => _tablesFuture = _repository.getTables()),
              );
            }

            final tables = snapshot.data ?? [];
            final filtered = _filterStatus == 'all'
                ? tables
                : tables.where((t) => t.status.toLowerCase() == _filterStatus).toList();

            return Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: Column(
                  children: [
                    StaffAppHeader(
                      title: 'Sơ đồ bàn',
                      subtitle: 'Quản lý',
                      onRefresh: () => setState(() => _tablesFuture = _repository.getTables()),
                    ),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(
                          StaffDesignSystem.spacing16,
                          StaffDesignSystem.spacing16,
                          StaffDesignSystem.spacing16,
                          StaffDesignSystem.spacing16,
                        ),
                        children: [
                          // Filter chips
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _buildFilterChip('Tất cả', 'all'),
                                const SizedBox(width: StaffDesignSystem.spacing8),
                                _buildFilterChip('Đang chiếm', 'occupied'),
                                const SizedBox(width: StaffDesignSystem.spacing8),
                                _buildFilterChip('Trống', 'available'),
                                const SizedBox(width: StaffDesignSystem.spacing8),
                                _buildFilterChip('Đặt trước', 'reserved'),
                              ],
                            ),
                          ),
                          const SizedBox(height: StaffDesignSystem.spacing24),
                          // Tables grid
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: StaffDesignSystem.spacing12,
                              mainAxisSpacing: StaffDesignSystem.spacing12,
                              childAspectRatio: 1,
                            ),
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              final table = filtered[index];
                              return _buildTableCard(table);
                            },
                          ),
                          if (filtered.isEmpty) ...[
                            const SizedBox(height: StaffDesignSystem.spacing24),
                            EmptyState(
                              icon: Icons.table_chart_outlined,
                              title: 'Không có bàn',
                              description: 'Không có bàn với trạng thái này',
                              iconColor: StaffDesignSystem.primary.withValues(alpha: 0.3),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _filterStatus == value;

    return FilterChip(
      selected: isSelected,
      onSelected: (selected) => setState(() => _filterStatus = value),
      label: Text(label),
      backgroundColor: context.cardColor,
      selectedColor: StaffDesignSystem.primary.withValues(alpha: 0.15),
      side: BorderSide(
        color: isSelected
            ? StaffDesignSystem.primary
            : context.borderColor,
      ),
    );
  }

  Widget _buildTableCard(TableData table) {
    final statusColor = StaffDesignSystem.getTableStatusColor(table.status);
    final isOccupied = table.status.toLowerCase() == 'occupied';

    return GestureDetector(
      onTap: () {
        if (isOccupied) {
          // Navigate to table detail or order
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: BorderRadius.circular(StaffDesignSystem.radiusLarge),
          border: Border.all(
            color: statusColor.withValues(alpha: 0.3),
            width: 2,
          ),
          boxShadow: StaffDesignSystem.shadowLight,
        ),
        child: Stack(
          children: [
            // Background color based on status
            Container(
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(StaffDesignSystem.radiusLarge),
              ),
            ),
            // Table info
            Padding(
              padding: const EdgeInsets.all(StaffDesignSystem.spacing12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Table number
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${table.id}',
                        style: StaffTypography.titleMedium(context.isDarkMode)
                            .copyWith(color: statusColor),
                      ),
                    ),
                  ),
                  // Status and capacity
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        table.status,
                        style: StaffTypography.labelSmall(context.isDarkMode)
                            .copyWith(color: statusColor),
                      ),
                      const SizedBox(height: StaffDesignSystem.spacing4),
                      Text(
                        '${table.capacity} chỗ',
                        style: StaffTypography.bodySmall(context.isDarkMode),
                      ),
                    ],
                  ),
                  // Indicator dot
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
