import 'package:flutter/material.dart';

import '../../../../core/colors.dart';
import '../../../../core/widgets/app_button.dart';

class RideOfferSheet extends StatelessWidget {
  const RideOfferSheet({
    super.key,
    required this.priceController,
    required this.onOrder,
    this.actionLabel = 'Заказать',
  });

  final TextEditingController priceController;
  final VoidCallback onOrder;
  final String actionLabel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                'Предложите цену',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 16,
                    ),
              ),
              const Spacer(),
              Text(
                '₸',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: priceController,
            keyboardType: TextInputType.number,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
            decoration: InputDecoration(
              hintText: '1200',
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
          const SizedBox(height: 14),
          AppButton(text: actionLabel, onPressed: onOrder),
        ],
      ),
    );
  }
}
