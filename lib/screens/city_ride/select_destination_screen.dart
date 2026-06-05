import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/constants.dart';
import '../../models/order_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/location_provider.dart';
import '../../providers/order_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class SelectDestinationScreen extends StatefulWidget {
  const SelectDestinationScreen({super.key, this.initialDestination});

  final String? initialDestination;

  @override
  State<SelectDestinationScreen> createState() =>
      _SelectDestinationScreenState();
}

class _SelectDestinationScreenState extends State<SelectDestinationScreen> {
  final _destinationController = TextEditingController();
  final _priceController = TextEditingController(text: '1200');
  List<String> _suggestions = AppConstants.destinationSuggestions;

  @override
  void initState() {
    super.initState();
    _destinationController.text = widget.initialDestination ?? '';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _suggestions = context.read<LocationProvider>().filterDestinations('');
  }

  @override
  void dispose() {
    _destinationController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _createCityOrder() async {
    final authProvider = context.read<AuthProvider>();
    final orderProvider = context.read<OrderProvider>();
    final user = authProvider.user;

    if (user == null || _destinationController.text.trim().isEmpty) {
      return;
    }

    final order = OrderModel(
      id: '',
      uid: user.uid,
      type: 'city',
      from: AppConstants.currentAddress,
      to: _destinationController.text.trim(),
      date: DateFormat('d MMMM HH:mm', 'ru_RU').format(DateTime.now()),
      price: int.tryParse(_priceController.text.trim()) ?? 1200,
      passengerType: 'По городу',
      status: 'active',
    );

    final success = await orderProvider.createOrder(order);
    if (!mounted) {
      return;
    }

    if (success) {
      context.go('/orders');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.danger,
          content: Text(orderProvider.error ?? 'Не удалось создать заказ'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<OrderProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Куда едем?')),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
        child: Column(
          children: [
            CustomTextField(
              controller: _destinationController,
              hintText: 'Введите адрес назначения',
              prefixIcon: Icons.search,
              onTap: null,
            ),
            const SizedBox(height: 12),
            CustomTextField(
              controller: _priceController,
              hintText: 'Предложите цену',
              prefixIcon: Icons.payments_outlined,
              keyboardType: TextInputType.number,
              prefixText: '₸ ',
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Популярные направления',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontSize: 16),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: _suggestions.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = _suggestions[index];
                  return ListTile(
                    leading: const Icon(Icons.location_on_outlined),
                    title: Text(item),
                    subtitle: const Text('Тараз'),
                    onTap: () =>
                        setState(() => _destinationController.text = item),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            CustomButton(
              text: 'Создать заказ',
              isLoading: orderProvider.isLoading,
              onPressed: _createCityOrder,
            ),
          ],
        ),
      ),
    );
  }
}
