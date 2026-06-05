import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';

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

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Грузовой заказ создан (демо)')),
    );
    context.go('/orders');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Грузовые'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
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
                    final isSelected = _selectedTab == index;
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: ChoiceChip(
                        label: Text(_tabs[index]),
                        selected: isSelected,
                        selectedColor: AppColors.primary,
                        onSelected: (_) => setState(() => _selectedTab = index),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 18),
              AppTextField(
                controller: _fromController,
                hintText: 'Откуда',
                prefixIcon: Icons.trip_origin,
                validator: (value) => (value ?? '').trim().isEmpty
                    ? 'Введите точку отправления'
                    : null,
              ),
              const SizedBox(height: 12),
              AppTextField(
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
                      child: Text(
                        item,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 18),
              AppTextField(
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
                'Опции',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 16,
                    ),
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
              AppButton(text: 'Создать заказ', onPressed: _submit),
            ],
          ),
        ),
      ),
    );
  }
}
