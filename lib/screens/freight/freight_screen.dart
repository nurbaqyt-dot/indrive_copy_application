import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/constants.dart';
import '../../models/order_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/order_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class FreightScreen extends StatefulWidget {
  const FreightScreen({super.key});

  @override
  State<FreightScreen> createState() => _FreightScreenState();
}

class _FreightScreenState extends State<FreightScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  final _cargoController = TextEditingController();
  final List<String> _tabs = ['4 мест', 'Межгород', 'Грузовые', 'Курьер'];
  final List<String> _times = [
    '15-20 мин',
    'До 1 часа',
    'Запланировать доставку',
  ];
  final List<String> _options = [
    'Один Грузчик',
    'Два Грузчика',
    'Пассажирская Поездка',
  ];
  int _selectedTab = 2;
  String _selectedTime = '15-20 мин';
  String _selectedBodyType = AppConstants.freightBodyTypes.first;
  final Set<String> _selectedOptions = {};

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    _cargoController.dispose();
    super.dispose();
  }

  Future<void> _createOrder() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final orderProvider = context.read<OrderProvider>();
    final user = authProvider.user;

    if (user == null) {
      return;
    }

    final notes = [
      'Подача: $_selectedTime',
      'Тип кузова: $_selectedBodyType',
      if (_selectedOptions.isNotEmpty) 'Опции: ${_selectedOptions.join(', ')}',
      if (_cargoController.text.trim().isNotEmpty) _cargoController.text.trim(),
    ].join(' • ');

    final order = OrderModel(
      id: '',
      uid: user.uid,
      type: 'freight',
      from: _fromController.text.trim(),
      to: _toController.text.trim(),
      date: DateFormat('d MMMM HH:mm', 'ru_RU').format(DateTime.now()),
      price: 0,
      passengerType: 'Грузовые',
      status: 'active',
      notes: notes,
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
      appBar: AppBar(title: const Text('Грузовые')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(_tabs.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: ChoiceChip(
                        label: Text(_tabs[index]),
                        selected: _selectedTab == index,
                        onSelected: (_) => setState(() => _selectedTab = index),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 18),
              CustomTextField(
                controller: _fromController,
                hintText: 'Откуда',
                prefixIcon: Icons.trip_origin,
                validator: (value) => (value ?? '').trim().isEmpty
                    ? 'Введите точку отправления'
                    : null,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _toController,
                hintText: 'Куда',
                prefixIcon: Icons.location_on_outlined,
                validator: (value) => (value ?? '').trim().isEmpty
                    ? 'Введите точку назначения'
                    : null,
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _times.map((item) {
                  final isSelected = _selectedTime == item;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedTime = item),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: isSelected ? AppColors.info : AppColors.surface,
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.divider,
                        ),
                      ),
                      child: Text(item),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 18),
              CustomTextField(
                controller: _cargoController,
                hintText: 'Описание груза',
                prefixIcon: Icons.inventory_2_outlined,
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _selectedBodyType,
                items: AppConstants.freightBodyTypes
                    .map(
                      (item) =>
                          DropdownMenuItem(value: item, child: Text(item)),
                    )
                    .toList(),
                decoration: const InputDecoration(hintText: 'Тип кузова'),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedBodyType = value);
                  }
                },
              ),
              const SizedBox(height: 18),
              Text(
                'Нано',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontSize: 16),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _options.map((item) {
                  final isSelected = _selectedOptions.contains(item);
                  return FilterChip(
                    label: Text(item),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() {
                        if (isSelected) {
                          _selectedOptions.remove(item);
                        } else {
                          _selectedOptions.add(item);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Создать заказ',
                isLoading: orderProvider.isLoading,
                onPressed: _createOrder,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
