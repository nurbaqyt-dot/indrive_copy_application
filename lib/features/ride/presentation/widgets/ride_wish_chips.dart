import 'package:flutter/material.dart';

import '../../../../core/constants.dart';

class RideWishChips extends StatelessWidget {
  const RideWishChips({
    super.key,
    required this.selected,
    required this.onToggle,
  });

  final Set<String> selected;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: AppConstants.rideWishes.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final wish = AppConstants.rideWishes[index];
          final isSelected = selected.contains(wish);

          return FilterChip(
            label: Text(wish),
            selected: isSelected,
            showCheckmark: false,
            onSelected: (_) => onToggle(wish),
            backgroundColor: AppColors.surface,
            selectedColor: AppColors.info,
            side: BorderSide(
              color: isSelected ? AppColors.primary : AppColors.divider,
            ),
            labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          );
        },
      ),
    );
  }
}
