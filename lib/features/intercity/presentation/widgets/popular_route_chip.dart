import 'package:flutter/material.dart';

import '../../../../core/colors.dart';
import '../../domain/route_model.dart';

class PopularRouteChip extends StatelessWidget {
  const PopularRouteChip({
    super.key,
    required this.route,
    required this.onTap,
  });

  final IntercityRouteModel route;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.divider),
        ),
        child: RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  height: 1.2,
                ),
            children: [
              TextSpan(text: route.title),
              TextSpan(
                text: '  [${route.count}]',
                style: const TextStyle(
                  color: AppColors.link,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
