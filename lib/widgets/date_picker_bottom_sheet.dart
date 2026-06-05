import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../core/constants.dart';
import 'custom_button.dart';

Future<DateTime?> showAppDatePickerBottomSheet(
  BuildContext context, {
  DateTime? initialDate,
}) {
  final startDate = initialDate ?? DateTime.now();

  return showModalBottomSheet<DateTime>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (context) {
      var selectedDate = DateTime(
        startDate.year,
        startDate.month,
        startDate.day,
      );
      final today = DateTime.now();
      final week = List.generate(
        7,
        (index) => DateTime(today.year, today.month, today.day + index),
      );

      return StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 18,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Дата отправления',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _QuickDateChip(
                      label: 'Сегодня',
                      isSelected: _sameDay(selectedDate, today),
                      onTap: () => setState(() => selectedDate = today),
                    ),
                    const SizedBox(width: 10),
                    _QuickDateChip(
                      label: 'Завтра',
                      isSelected: _sameDay(
                        selectedDate,
                        today.add(const Duration(days: 1)),
                      ),
                      onTap: () => setState(
                        () => selectedDate = today.add(const Duration(days: 1)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: week.map((date) {
                      final isSelected = _sameDay(selectedDate, date);
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: GestureDetector(
                          onTap: () => setState(() => selectedDate = date),
                          child: Container(
                            width: 68,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.divider,
                              ),
                              color: isSelected
                                  ? AppColors.info
                                  : AppColors.surface,
                            ),
                            child: Column(
                              children: [
                                Text(
                                  DateFormat('EEE', 'ru_RU').format(date),
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  DateFormat('d').format(date),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: 'Готово',
                  onPressed: () => Navigator.of(context).pop(selectedDate),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

class _QuickDateChip extends StatelessWidget {
  const _QuickDateChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.info : AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
    );
  }
}

bool _sameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}
