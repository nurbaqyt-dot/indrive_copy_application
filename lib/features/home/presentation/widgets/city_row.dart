import 'package:flutter/material.dart';

import '../../../../core/colors.dart';

class CityRow extends StatelessWidget {
  const CityRow({
    super.key,
    required this.cityName,
    required this.onChangeCity,
  });

  final String cityName;
  final VoidCallback onChangeCity;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.circle, color: AppColors.success, size: 12),
        const SizedBox(width: 8),
        Text(
          cityName,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontSize: 16),
        ),
        const Spacer(),
        TextButton(
          onPressed: onChangeCity,
          child: const Text('Изменить город'),
        ),
      ],
    );
  }
}
