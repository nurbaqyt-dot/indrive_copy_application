import 'package:flutter/material.dart';

import '../../../../core/colors.dart';
import 'ride_offer_sheet.dart';
import 'ride_route_card.dart';
import 'ride_tariff_carousel.dart';
import 'ride_wish_chips.dart';

class RideBottomPanel extends StatelessWidget {
  const RideBottomPanel({
    super.key,
    required this.fromAddress,
    required this.toHint,
    this.toAddress,
    required this.cityLabel,
    required this.selectedTariff,
    required this.selectedWishes,
    required this.priceController,
    required this.onFromTap,
    required this.onToTap,
    required this.onTariffSelected,
    required this.onWishToggle,
    required this.onOrder,
  });

  final String fromAddress;
  final String toHint;
  final String? toAddress;
  final String cityLabel;
  final int selectedTariff;
  final Set<String> selectedWishes;
  final TextEditingController priceController;
  final VoidCallback onFromTap;
  final VoidCallback onToTap;
  final ValueChanged<int> onTariffSelected;
  final ValueChanged<String> onWishToggle;
  final VoidCallback onOrder;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.24),
            blurRadius: 24,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: RideRouteCard(
              fromAddress: fromAddress,
              toHint: toHint,
              toAddress: toAddress,
              onFromTap: onFromTap,
              onToTap: onToTap,
            ),
          ),
          const SizedBox(height: 16),
          RideTariffCarousel(
            selectedIndex: selectedTariff,
            onSelected: onTariffSelected,
          ),
          const SizedBox(height: 12),
          RideWishChips(
            selected: selectedWishes,
            onToggle: onWishToggle,
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                cityLabel,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          RideOfferSheet(
            priceController: priceController,
            onOrder: onOrder,
            actionLabel: 'Найти водителя',
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
        ],
      ),
    );
  }
}
