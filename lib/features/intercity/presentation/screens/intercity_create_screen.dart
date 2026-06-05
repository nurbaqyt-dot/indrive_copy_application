import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../home/presentation/providers/location_provider.dart';

class IntercityCreateScreen extends ConsumerStatefulWidget {
  const IntercityCreateScreen({super.key});

  @override
  ConsumerState<IntercityCreateScreen> createState() =>
      _IntercityCreateScreenState();
}

class _IntercityCreateScreenState extends ConsumerState<IntercityCreateScreen> {
  final _toController = TextEditingController();
  final _priceController = TextEditingController(text: '3500');
  final _seatsController = TextEditingController(text: '3');

  @override
  void dispose() {
    _toController.dispose();
    _priceController.dispose();
    _seatsController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_toController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.danger,
          content: Text('Укажите город назначения'),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Межгород заказ создан (демо)')),
    );
    context.go('/orders');
  }

  @override
  Widget build(BuildContext context) {
    final city = ref.watch(selectedCityProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Создать заказ'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  const Icon(Icons.trip_origin, color: AppColors.routeFrom),
                  const SizedBox(width: 10),
                  Text(
                    'Откуда: $city',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: _toController,
              hintText: 'Куда (город)',
              prefixIcon: Icons.location_on_outlined,
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: _priceController,
              hintText: 'Цена за место',
              prefixIcon: Icons.payments_outlined,
              keyboardType: TextInputType.number,
              prefixText: '₸ ',
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: _seatsController,
              hintText: 'Свободных мест',
              prefixIcon: Icons.event_seat_outlined,
              keyboardType: TextInputType.number,
            ),
            const Spacer(),
            AppButton(text: 'Опубликовать', onPressed: _submit),
          ],
        ),
      ),
    );
  }
}
