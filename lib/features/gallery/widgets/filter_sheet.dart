import 'package:flutter/material.dart';
import 'package:shieldcam/core/utils/date_time_utils.dart';

class FilterSheetResult {
  final DateTime from;
  final DateTime to;
  final bool byLocation;

  const FilterSheetResult({
    required this.from,
    required this.to,
    required this.byLocation,
  });
}

/// Filter bottom sheet: date range, year, month and location-only toggle.
class FilterSheet extends StatefulWidget {
  const FilterSheet({
    super.key,
    this.currentYear,
    this.currentMonth,
    this.fromDate,
    this.toDate,
    this.onlyWithLocation = false,
  });

  final int? currentYear;
  final int? currentMonth;
  final DateTime? fromDate;
  final DateTime? toDate;
  final bool onlyWithLocation;

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  DateTime? _from;
  DateTime? _to;
  int? _year;
  int? _month;
  bool _byLocation = false;

  @override
  void initState() {
    super.initState();
    _from = widget.fromDate;
    _to = widget.toDate;
    _year = widget.currentYear;
    _month = widget.currentMonth;
    _byLocation = widget.onlyWithLocation;
  }

  List<int> get _availableYears {
    final now = DateTime.now();
    return List.generate(now.year - 2020 + 1, (i) => now.year - i);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Filters', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _from = null;
                      _to = null;
                      _year = null;
                      _month = null;
                      _byLocation = false;
                    });
                  },
                  child: const Text('Reset'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Only events with location'),
              subtitle: const Text('Show events that captured GPS coordinates'),
              value: _byLocation,
              onChanged: (v) => setState(() => _byLocation = v),
            ),
            const Divider(height: 32),
            Text('Date range', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _DateButton(
                    label: _from == null ? 'From' : DateTimeUtils.formatDate(_from!),
                    icon: Icons.event,
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _from ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) setState(() => _from = picked);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _DateButton(
                    label: _to == null ? 'To' : DateTimeUtils.formatDate(_to!),
                    icon: Icons.event,
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _to ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) setState(() => _to = picked);
                    },
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
            Text('Period', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            DropdownButtonFormField<int?>(
              initialValue: _year,
              decoration: const InputDecoration(labelText: 'Year'),
              items: [
                const DropdownMenuItem<int?>(value: null, child: Text('All years')),
                ..._availableYears.map(
                  (y) => DropdownMenuItem<int?>(value: y, child: Text('$y')),
                ),
              ],
              onChanged: (v) => setState(() {
                _year = v;
                _month = null;
              }),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int?>(
              initialValue: _month,
              decoration: const InputDecoration(labelText: 'Month'),
              items: [
                const DropdownMenuItem<int?>(value: null, child: Text('All months')),
                ...List.generate(12, (i) => i + 1).map(
                  (m) => DropdownMenuItem<int?>(
                    value: m,
                    child: Text(_monthName(m)),
                  ),
                ),
              ],
              onChanged: (v) => setState(() => _month = v),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  final now = DateTime.now();
                  final from = _from ?? DateTime(2020, 1, 1);
                  final to = _to ?? DateTimeUtils.endOfDay(now);
                  Navigator.pop(
                    context,
                    FilterSheetResult(
                      from: DateTimeUtils.startOfDay(from),
                      to: to,
                      byLocation: _byLocation,
                    ),
                  );
                },
                child: const Text('Apply filters'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _monthName(int m) {
    const names = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return names[m - 1];
  }
}

class _DateButton extends StatelessWidget {
  const _DateButton({required this.label, required this.icon, required this.onTap});

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label, overflow: TextOverflow.ellipsis),
      style: OutlinedButton.styleFrom(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
    );
  }
}
