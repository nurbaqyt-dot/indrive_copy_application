import 'package:flutter/material.dart';
import '../../../../core/colors.dart';

class RideRouteCard extends StatelessWidget {
  const RideRouteCard({
    super.key,
    required this.fromAddress,
    required this.toHint,
    this.toAddress,
    required this.onFromTap,
    required this.onToTap,
  });

  final String fromAddress;
  final String toHint;
  final String? toAddress;
  final VoidCallback onFromTap;
  final VoidCallback onToTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _RouteRow(
            dotColor: AppColors.routeFrom,
            label: 'Откуда',
            value: fromAddress,
            onTap: onFromTap,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(width: 2, height: 18, color: AppColors.divider),
            ),
          ),
          _RouteRow(
            dotColor: AppColors.routeTo,
            label: 'Куда',
            value: toAddress ?? toHint,
            isPlaceholder: toAddress == null,
            onTap: onToTap,
          ),
        ],
      ),
    );
  }
}

class _RouteRow extends StatelessWidget {
  const _RouteRow({
    required this.dotColor,
    required this.label,
    required this.value,
    required this.onTap,
    this.isPlaceholder = false,
  });

  final Color dotColor;
  final String label;
  final String value;
  final VoidCallback onTap;
  final bool isPlaceholder;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isPlaceholder
                              ? AppColors.textHint
                              : AppColors.textPrimary,
                        ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textHint,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
