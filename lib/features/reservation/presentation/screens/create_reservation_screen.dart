import 'package:flutter/material.dart';
import 'package:prm393_booking_app/features/staff_order/data/staff_order_repository.dart';
import '../../../../../shared/services/reservation_service.dart';

class CreateReservationScreen extends StatefulWidget {
  const CreateReservationScreen({super.key});

  @override
  State<CreateReservationScreen> createState() =>
      _CreateReservationScreenState();
}

class _CreateReservationScreenState extends State<CreateReservationScreen> {
  static const Color _primary = Color(0xFF13EC5B);
  static const Color _background = Color(0xFFF6F8F6);
  static const Color _surface = Colors.white;
  static const Color _surfaceSoft = Color(0xFFF0F7F2);
  static const Color _border = Color(0xFFE1E7E3);
  static const Color _muted = Color(0xFF6B7C73);
  static const Color _textPrimary = Color(0xFF17301F);

  final StaffOrderRepository _tableRepository = StaffOrderRepository();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _customerPhoneController = TextEditingController();

  late Future<List<TableData>> _tablesFuture;
  List<TableData> _tables = const [];
  TableData? _selectedTable;
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  int _guestCount = 2;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _tablesFuture = _loadTables();
    final now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day);
    _selectedTime = const TimeOfDay(hour: 19, minute: 0);
  }

  @override
  void dispose() {
    _noteController.dispose();
    _customerNameController.dispose();
    _customerPhoneController.dispose();
    super.dispose();
  }

  Future<List<TableData>> _loadTables() async {
    final allTables = await _tableRepository.getTables();
    final selectableTables = allTables
        .where((table) => table.isActive && _isTableSelectable(table.status))
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));

    final usableTables = selectableTables.isNotEmpty
        ? selectableTables
        : allTables.where((table) => table.isActive).toList();

    if (mounted) {
      setState(() {
        _tables = usableTables;
        _selectedTable ??= usableTables.isNotEmpty ? usableTables.first : null;
        if (_selectedTable != null && _guestCount > _selectedTable!.capacity) {
          _guestCount = _selectedTable!.capacity;
        }
      });
    }

    return usableTables;
  }

  bool _isTableSelectable(String status) {
    final normalized = status.trim().toLowerCase();
    if (normalized.isEmpty) {
      return true;
    }
    const blocked = {'occupied', 'inactive', 'unavailable'};
    return !blocked.contains(normalized);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: _primary,
              surface: _surface,
            ),
            dialogTheme: const DialogThemeData(backgroundColor: _surface),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: _primary,
              surface: _surface,
            ),
            dialogTheme: const DialogThemeData(backgroundColor: _surface),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final suffix = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $suffix';
  }

  String _displayTableName(String rawName) {
    return rawName.replaceFirst('Table', 'Bàn');
  }

  Future<void> _openTablePicker() async {
    if (_tables.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Chưa có dữ liệu bàn để chọn')),
      );
      return;
    }

    final selected = await showModalBottomSheet<TableData>(
      context: context,
      backgroundColor: _surface,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            itemCount: _tables.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final table = _tables[index];
              final isSelected = table.id == _selectedTable?.id;
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () => Navigator.of(context).pop(table),
                  child: Ink(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isSelected ? _surfaceSoft : _surface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isSelected ? _primary : _border,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: _primary.withValues(alpha: 0.16),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.table_restaurant,
                            color: _primary,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _displayTableName(table.name),
                                style: const TextStyle(
                                  color: _textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${table.areaName} • ${table.capacity} chỗ',
                                style: const TextStyle(
                                  color: _muted,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          const Icon(Icons.check_circle, color: _primary),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );

    if (selected != null) {
      setState(() {
        _selectedTable = selected;
        if (_guestCount > selected.capacity) {
          _guestCount = selected.capacity;
        }
      });
    }
  }

  Future<bool> _ensureCustomerInfo() async {
    if (_customerNameController.text.trim().isNotEmpty &&
        _customerPhoneController.text.trim().isNotEmpty) {
      return true;
    }

    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: _surface,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Thông tin khách hàng',
                style: TextStyle(
                  color: _textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'API yêu cầu tên và số điện thoại khách hàng để check-in.',
                style: TextStyle(color: _muted, fontSize: 14),
              ),
              const SizedBox(height: 18),
              _CustomerField(
                controller: _customerNameController,
                label: 'Tên khách hàng',
                icon: Icons.person_outline,
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 12),
              _CustomerField(
                controller: _customerPhoneController,
                label: 'Số điện thoại',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_customerNameController.text.trim().isEmpty ||
                        _customerPhoneController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Vui lòng nhập đủ tên và số điện thoại'),
                        ),
                      );
                      return;
                    }
                    Navigator.of(context).pop(true);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primary,
                    foregroundColor: const Color(0xFF08110B),
                    minimumSize: const Size.fromHeight(54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Tiếp tục check-in',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    return result ?? false;
  }

  String _buildNotePayload() {
    return _noteController.text.trim();
  }

  DateTime _buildCheckInTime() {
    return DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );
  }

  Future<void> _submitReservation() async {
    if (_selectedTable == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn bàn trước khi xác nhận')),
      );
      return;
    }

    final hasCustomerInfo = await _ensureCustomerInfo();
    if (!hasCustomerInfo) {
      return;
    }

    final checkInTime = _buildCheckInTime();
    if (checkInTime.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Thời gian check-in phải ở hiện tại hoặc tương lai'),
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await ReservationService.createReservation(
        tableId: _selectedTable!.id,
        customerName: _customerNameController.text.trim(),
        customerPhone: _customerPhoneController.text.trim(),
        guestCount: _guestCount,
        checkInTime: checkInTime,
        note: _buildNotePayload(),
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Check-in thành công')),
      );
      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể check-in: $error')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Widget _buildLoadedContent(List<TableData> tables) {
    final selectedTable = _selectedTable;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: _openTablePicker,
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: _surfaceSoft,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _border),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 58,
                          height: 58,
                          decoration: BoxDecoration(
                            color: const Color(0xFFB8CCBE),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.local_florist,
                            color: Color(0xFF3A6446),
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: selectedTable == null
                              ? const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Chọn bàn',
                                      style: TextStyle(
                                              color: _textPrimary,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Nhấn để chọn bàn cho khách đang check-in',
                                      style: TextStyle(
                                        color: _muted,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _displayTableName(selectedTable.name),
                                      style: const TextStyle(
                                        color: _textPrimary,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${selectedTable.areaName} • ${selectedTable.capacity} chỗ',
                                      style: const TextStyle(
                                        color: _muted,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                        IconButton(
                          onPressed: selectedTable == null
                              ? null
                              : () {
                                  setState(() {
                                    _selectedTable = null;
                                  });
                                },
                          icon: const Icon(Icons.close, color: _muted),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _surface,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: _border),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: _primary.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.group, color: _primary),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Text(
                          'Số khách',
                          style: TextStyle(
                            color: _textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      _CountButton(
                        icon: Icons.remove,
                        onPressed: _guestCount > 1
                            ? () {
                                setState(() {
                                  _guestCount -= 1;
                                });
                              }
                            : null,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Text(
                          '$_guestCount',
                          style: const TextStyle(
                            color: _textPrimary,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      _CountButton(
                        icon: Icons.add,
                        onPressed: () {
                          final capacity = _selectedTable?.capacity;
                          if (capacity != null && _guestCount >= capacity) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Bàn này tối đa $capacity khách'),
                              ),
                            );
                            return;
                          }
                          setState(() {
                            _guestCount += 1;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: _PickerField(
                        label: 'Ngày',
                        icon: Icons.calendar_today,
                        value: _formatDate(_selectedDate),
                        onTap: _pickDate,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _PickerField(
                        label: 'Giờ',
                        icon: Icons.schedule,
                        value: _formatTime(_selectedTime),
                        onTap: _pickTime,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const Text(
                  'Ghi chú',
                  style: TextStyle(
                    color: _textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _noteController,
                  maxLines: 5,
                  style: const TextStyle(color: _textPrimary, fontSize: 15),
                  decoration: InputDecoration(
                    hintText: 'Thêm yêu cầu đặc biệt...',
                    hintStyle: const TextStyle(color: _muted),
                    filled: true,
                    fillColor: _surface,
                    contentPadding: const EdgeInsets.all(18),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: const BorderSide(color: _border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: const BorderSide(color: _border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: const BorderSide(color: _primary),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
          decoration: const BoxDecoration(
            color: _background,
            border: Border(top: BorderSide(color: _border)),
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isSubmitting ? null : _submitReservation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primary,
                  foregroundColor: const Color(0xFF08110B),
                  disabledBackgroundColor: _primary.withValues(alpha: 0.45),
                  minimumSize: const Size.fromHeight(58),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 0,
                ),
                icon: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF08110B)),
                        ),
                      )
                    : const Icon(Icons.check_circle),
                label: Text(
                  _isSubmitting ? 'Đang xử lý...' : 'Xác nhận check-in',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: _surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back, color: _textPrimary),
        ),
        centerTitle: true,
        title: const Text(
          'Check-in khách',
          style: TextStyle(
            color: _textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: FutureBuilder<List<TableData>>(
        future: _tablesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: _primary));
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Không thể tải danh sách bàn',
                      style: TextStyle(
                        color: _textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: _muted),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _tablesFuture = _loadTables();
                        });
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: _primary),
                      child: const Text(
                        'Thử lại',
                        style: TextStyle(color: Color(0xFF08110B)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final tables = snapshot.data ?? const <TableData>[];
          return _buildLoadedContent(tables);
        },
      ),
    );
  }
}

class _PickerField extends StatelessWidget {
  const _PickerField({
    required this.label,
    required this.icon,
    required this.value,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: _CreateReservationScreenState._textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Ink(
            height: 54,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: _CreateReservationScreenState._surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: _CreateReservationScreenState._border),
            ),
            child: Row(
              children: [
                Icon(icon, color: _CreateReservationScreenState._muted, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    value,
                    style: const TextStyle(
                      color: _CreateReservationScreenState._textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CountButton extends StatelessWidget {
  const _CountButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(999),
      child: Ink(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: onPressed == null
              ? const Color(0xFFE8EFEB)
              : _CreateReservationScreenState._primary.withValues(alpha: 0.16),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 18,
          color: onPressed == null
              ? const Color(0xFFA2B1A8)
              : _CreateReservationScreenState._primary,
        ),
      ),
    );
  }
}

class _CustomerField extends StatelessWidget {
  const _CustomerField({
    required this.controller,
    required this.label,
    required this.icon,
    required this.keyboardType,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: _CreateReservationScreenState._textPrimary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: _CreateReservationScreenState._muted),
        prefixIcon: Icon(icon, color: _CreateReservationScreenState._muted),
        filled: true,
        fillColor: _CreateReservationScreenState._surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _CreateReservationScreenState._border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _CreateReservationScreenState._border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _CreateReservationScreenState._primary),
        ),
      ),
    );
  }
}
